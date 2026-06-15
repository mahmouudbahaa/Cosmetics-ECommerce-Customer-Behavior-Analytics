-- Calculate the min, max, average and median price for all purchases
SELECT
    DISTINCT MIN(price) over () AS min_price,
    MAX(price) over () AS max_price,
    cast(AVG(price) over () AS decimal(10, 2)) AS avg_price,
    PERCENTILE_DISC(0.5) WITHIN GROUP (
        ORDER BY
            price
    ) over () AS median_price
FROM
    Fact_Events
WHERE
    Event_type = 'Purchase'
    AND price > 0;

-- Calculate the total number of unique products
SELECT
    count(DISTINCT product_key)
FROM
    Fact_Events
WHERE
    event_type = 'Purchase';

-- Calculate the total number of purchases, total number of users, and the average number of purchases per user
SELECT
    count(event_key) AS total_purchases,
    count(DISTINCT user_key) AS total_users,
    cast(
        count(Event_key) * 1.0 / count(DISTINCT user_key) AS decimal (10, 2)
    ) AS Purchase_frequency
FROM
    Fact_Events
WHERE
    Event_type = 'Purchase';

-- Calculate MoM growth of total revenue
WITH MoM_growth AS (
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

-- Rfm analysis and segmentation
WITH last_purchase AS (
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
    END AS Customer_Segment,
    count(
        CASE
            WHEN r_score >= 4
            AND f_score >= 4
            AND m_score >= 4 THEN user_id
        END
    ) over () AS total_champions,
    count(
        CASE
            WHEN r_score >= 3
            AND f_score >= 3
            AND m_score >= 3 THEN user_id
        END
    ) over () AS total_loyal_customers,
    count(
        CASE
            WHEN r_score >= 2
            AND f_score >= 4
            AND m_score >= 4 THEN user_id
        END
    ) over () AS total_at_risk_customers,
    count(
        CASE
            WHEN r_score <= 2
            AND f_score <= 2
            AND m_score <= 2 THEN user_id
        END
    ) over () AS total_lost_customers,
    count(
        CASE
            WHEN r_score >= 3
            AND f_score <= 2
            AND m_score <= 2 THEN user_id
        END
    ) over () AS total_new_customers
FROM
    rfm_score;

-- Funnel analysis and conversion rates
WITH funnel AS (
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

-- Funnel analysis by brand
WITH funnel_by_brand AS (
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
ORDER BY
    total_conversion DESC,
    purchase DESC;