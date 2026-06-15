-- =========================================================
-- 1. CREATE STAGING TABLES & LOAD DATA
-- =========================================================
CREATE TABLE stg_October (
    event_time NVARCHAR(100),
    event_type NVARCHAR(100),
    product_id INT,
    category_id bigint,
    category_code NVARCHAR(100),
    brand NVARCHAR(100),
    price FLOAT,
    user_id INT,
    user_session NVARCHAR(100)
);

CREATE TABLE stg_November (
    event_time NVARCHAR(100),
    event_type NVARCHAR(100),
    product_id INT,
    category_id bigint,
    category_code NVARCHAR(100),
    brand NVARCHAR(100),
    price FLOAT,
    user_id INT,
    user_session NVARCHAR(100)
);