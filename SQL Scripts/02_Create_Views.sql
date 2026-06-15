-- =========================================================
-- 2. CREATE CLEANED VIEWS
-- =========================================================
CREATE VIEW vw_dim_products AS
SELECT
    DISTINCT product_id,
    category_id,
    coalesce(category_code, 'Undefined') AS category_code,
    coalesce(brand, 'Undefined') AS brand
FROM
    stg_October
WHERE
    product_id IS NOT NULL
UNION
SELECT
    DISTINCT product_id,
    category_id,
    coalesce(category_code, 'Undefined') AS category_code,
    coalesce(brand, 'Undefined') AS brand
FROM
    stg_November
WHERE
    product_id IS NOT NULL;

CREATE VIEW vw_dim_users AS
SELECT
    DISTINCT user_id,
    coalesce(user_session, 'Undefined') AS user_session
FROM
    stg_October
WHERE
    user_id IS NOT NULL
UNION
SELECT
    DISTINCT user_id,
    coalesce(user_session, 'Undefined') AS user_session
FROM
    stg_November
WHERE
    user_id IS NOT NULL;

CREATE VIEW vw_dim_time AS
SELECT
    DISTINCT TRY_CONVERT(DATETIME2, REPLACE(event_time, ' UTC', '')) AS event_time_cleaned,
    datepart(year, REPLACE(event_time, ' UTC', '')) AS year,
    datepart(MONTH, REPLACE(event_time, ' UTC', '')) AS MONTH,
    datepart(DAY, REPLACE(event_time, ' UTC', '')) AS DAY,
    datepart(weekday, REPLACE(event_time, ' UTC', '')) AS dayofweek,
    datepart(HOUR, REPLACE(event_time, ' UTC', '')) AS HOUR
FROM
    stg_October
WHERE
    event_time IS NOT NULL
UNION
SELECT
    DISTINCT TRY_CONVERT(DATETIME2, REPLACE(event_time, ' UTC', '')) AS event_time_cleaned,
    datepart(year, REPLACE(event_time, ' UTC', '')) AS year,
    datepart(MONTH, REPLACE(event_time, ' UTC', '')) AS MONTH,
    datepart(DAY, REPLACE(event_time, ' UTC', '')) AS DAY,
    datepart(weekday, REPLACE(event_time, ' UTC', '')) AS dayofweek,
    datepart(HOUR, REPLACE(event_time, ' UTC', '')) AS HOUR
FROM
    stg_November
WHERE
    event_time IS NOT NULL;

CREATE VIEW vw_fact_events AS WITH combined AS (
    SELECT
        *
    FROM
        stg_October
    UNION
    ALL
    SELECT
        *
    FROM
        stg_November
),
DeDuplicatedEvents AS (
    SELECT
        [product_id],
        [category_id],
        [user_id],
        coalesce([user_session], 'Undefined') AS user_session,
        COALESCE([event_type], 'Undefined') AS event_type,
        TRY_CONVERT(DATETIME2, REPLACE(event_time, ' UTC', '')) AS event_time_cleaned,
        datepart(year, REPLACE(event_time, ' UTC', '')) AS year,
        datepart(MONTH, REPLACE(event_time, ' UTC', '')) AS MONTH,
        datepart(DAY, REPLACE(event_time, ' UTC', '')) AS DAY,
        datepart(weekday, REPLACE(event_time, ' UTC', '')) AS dayofweek,
        datepart(HOUR, REPLACE(event_time, ' UTC', '')) AS HOUR,
        coalesce([price], 0) AS price,
        ROW_NUMBER() OVER (
            PARTITION by [product_id],
            [category_id],
            [user_id],
            [user_session],
            [event_type],
            REPLACE(event_time, ' UTC', ''),
            [price]
            ORDER BY
                event_time
        ) AS rn
    FROM
        combined
)
SELECT
    [product_id],
    [category_id],
    [user_id],
    user_session,
    event_type,
    event_time_cleaned,
    year,
    MONTH,
    DAY,
    dayofweek,
    HOUR,
    price
FROM
    DeDuplicatedEvents
WHERE
    rn = 1;

-- =========================================================
-- 3. CREATE VIEWS FOR ANALYSIS
-- MoM Analysis
CREATE VIEW MoM_Growth AS WITH MoM_growth AS (
    SELECT
        t.month,
        cast(sum(price) AS decimal(10, 2)) AS total_revenue
    FROM
        Fact_Events f
        JOIN Dim_Time t ON f.time_key = t.time_key
    WHERE
        event_type = 'Purchase'
    GROUP BY
        MONTH
)
SELECT
    MONTH,
    total_revenue,
    cast(
        lag(total_revenue, 1) over (
            ORDER BY
                MONTH
        ) AS decimal(10, 2)
    ) AS previous_month_revenue,
    CAST(
        (
            total_revenue - lag(total_revenue, 1) over (
                ORDER BY
                    MONTH
            )
        ) / lag(total_revenue, 1) over (
            ORDER BY
                MONTH
        ) AS decimal(10, 2)
    ) * 100 AS MoM_growth
FROM
    MoM_growth;

-- RFM Analysis
CREATE VIEW rfm_analysis AS WITH last_purchase AS (
    SELECT
        u.user_id,
        MAX(event_time_cleaned) AS last_purchase_per_cus,
        count(event_key) AS frequency,
        sum(price) AS monetary_value
    FROM
        Fact_Events f
        JOIN Dim_Users u ON f.user_key = u.user_key
    WHERE
        event_type = 'Purchase'
        AND price > 0
    GROUP BY
        user_id
),
Last_purchase_on_data AS (
    SELECT
        max(event_time_cleaned) AS last_purchase
    FROM
        Fact_Events
),
rfm_score AS (
    SELECT
        User_id,
        Recency,
        Frequency,
        Monetary_value,
        NTILE(5) OVER (
            ORDER BY
                Recency DESC
        ) AS R_Score,
        NTILE(5) OVER (
            ORDER BY
                Frequency ASC
        ) AS F_Score,
        NTILE(5) OVER (
            ORDER BY
                Monetary_value ASC
        ) AS M_Score
    FROM
        (
            SELECT
                user_id,
                datediff(DAY, last_purchase_per_cus, last_purchase) AS Recency,
                frequency,
                monetary_value
            FROM
                last_purchase
                CROSS JOIN Last_purchase_on_data
        ) AS RFM_Base
)
SELECT
    user_id,
    Recency,
    Frequency,
    Monetary_value,
    R_Score,
    F_Score,
    M_Score,
    CASE
        WHEN R_Score >= 4
        AND F_Score >= 4
        AND M_Score >= 4 THEN 'Champions'
        WHEN R_Score >= 3
        AND F_Score >= 3
        AND M_Score >= 3 THEN 'Loyal Customers'
        WHEN R_Score >= 2
        AND F_Score >= 4
        AND M_Score >= 4 THEN 'At-Risk Customers'
        WHEN R_Score <= 2
        AND F_Score <= 2
        AND M_Score <= 2 THEN 'Lost Customers'
        ELSE 'New Customers'
    END AS Customer_Segment
FROM
    rfm_score;

-- Funnel Analysis
CREATE VIEW Funnel_Customer AS WITH funnel AS (
    SELECT
        count(
            DISTINCT CASE
                WHEN event_type = 'View' THEN user_key
            END
        ) AS viewed,
        count(
            DISTINCT CASE
                WHEN event_type = 'Cart' THEN user_key
            END
        ) AS add_to_cart,
        count(
            DISTINCT CASE
                WHEN event_type = 'Purchase' THEN user_key
            END
        ) AS purchase
    FROM
        Fact_Events
)
SELECT
    viewed,
    add_to_cart,
    purchase,
    CAST((100.0 * add_to_cart / viewed) AS decimal(10, 2)) AS cart_rate,
    cast (
        (100.0 * purchase / add_to_cart) AS decimal(10, 2)
    ) AS purchase_rate,
    cast ((100.0 * purchase / viewed) AS decimal(10, 2)) AS total_conversion
FROM
    funnel;

-- Funnel Analysis by Brand
CREATE VIEW funnel_by_brand AS WITH funnel_by_brand AS (
    SELECT
        p.brand,
        count(
            DISTINCT CASE
                WHEN event_type = 'view' THEN user_key
            END
        ) AS viewed,
        count(
            DISTINCT CASE
                WHEN event_type = 'cart' THEN user_key
            END
        ) AS add_to_cart,
        count(
            DISTINCT CASE
                WHEN event_type = 'purchase' THEN user_key
            END
        ) AS purchase
    FROM
        Fact_Events f
        JOIN dim_products p ON f.product_key = p.product_key
    GROUP BY
        p.brand
)
SELECT
    brand,
    viewed,
    add_to_cart,
    purchase,
    CAST(
        (100.0 * add_to_cart / nullif(viewed, 0)) AS decimal(10, 2)
    ) AS cart_rate,
    cast (
        (100.0 * purchase / nullif(add_to_cart, 0)) AS decimal(10, 2)
    ) AS purchase_rate,
    cast (
        (100.0 * purchase / nullif(viewed, 0)) AS decimal(10, 2)
    ) AS total_conversion
FROM
    funnel_by_brand