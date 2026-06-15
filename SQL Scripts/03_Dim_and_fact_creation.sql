-- =========================================================
-- 3. CREATE PRODUCTION TABLES & LOAD DIMENSIONS
-- =========================================================
CREATE TABLE Dim_Products(
    Product_key int identity(1, 1) PRIMARY KEY,
    Product_id int,
    Category_id bigint,
    Category_code NVARCHAR(100),
    Brand NVARCHAR(100)
);

CREATE TABLE Dim_Users(
    User_key int identity(1, 1) PRIMARY KEY,
    User_id int,
    User_session NVARCHAR(100)
);

CREATE TABLE Dim_Time(
    Time_key int identity(1, 1) PRIMARY KEY,
    Event_time_cleaned datetime2,
    Year int,
    MONTH int,
    DAY int,
    Dayofweek int,
    HOUR int
);

-- =========================================================
-- 4. CREATE FACT TABLE & LOAD DATA WITH SURROGATE KEYS
-- =========================================================
CREATE TABLE Fact_Events(
    Event_key int identity(1, 1) PRIMARY KEY,
    Product_key int FOREIGN KEY REFERENCES Dim_Products(Product_key),
    User_key int FOREIGN KEY REFERENCES Dim_Users(User_key),
    time_key int FOREIGN KEY REFERENCES Dim_Time(Time_key),
    Event_type NVARCHAR(100),
    Price float,
    Event_time_cleaned datetime2
);

INSERT INTO
    Fact_Events (
        Product_key,
        User_key,
        Time_key,
        Event_type,
        Price,
        Event_time_cleaned
    )
SELECT
    p.product_key,
    u.user_key,
    t.time_key,
    f.event_type,
    f.price,
    t.event_time_cleaned
FROM
    vw_fact_events f
    INNER JOIN Dim_Products p ON f.Product_id = p.Product_id
    AND f.Category_id = p.Category_id
    INNER JOIN Dim_Users u ON f.User_id = u.User_id
    AND f.User_session = u.User_session
    INNER JOIN Dim_Time t ON f.event_time_cleaned = t.event_time_cleaned;