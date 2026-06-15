INSERT INTO
    stg_October
SELECT
    event_time,
    event_type,
    product_id,
    category_id,
    category_code,
    brand,
    price,
    user_id,
    user_session
FROM
    dbo.[2019-Oct];

INSERT INTO
    stg_November
SELECT
    event_time,
    event_type,
    product_id,
    category_id,
    category_code,
    brand,
    price,
    user_id,
    user_session
FROM
    dbo.[2019-Nov];

INSERT INTO
    Dim_Products (Product_id, Category_id, Category_code, Brand)
SELECT
    product_id,
    category_id,
    category_code,
    brand
FROM
    vw_dim_products;

INSERT INTO
    Dim_Users (User_id, User_session)
SELECT
    user_id,
    user_session
FROM
    vw_dim_users;

INSERT INTO
    Dim_Time (
        Event_time_cleaned,
        Year,
        MONTH,
        DAY,
        Dayofweek,
        HOUR
    )
SELECT
    event_time_cleaned,
    year,
    MONTH,
    DAY,
    dayofweek,
    HOUR
FROM
    vw_dim_time;