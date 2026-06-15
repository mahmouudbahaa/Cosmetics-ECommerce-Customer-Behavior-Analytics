# 📊 Cosmetics E-Commerce Sales & Consumer Behavior Analytics

**End-to-End Data Engineering & Analytics Project using SQL Server (T-SQL) & Power BI**

---

## 📌 Project Overview

This project transforms raw operational e-commerce web logs from a large-scale **Cosmetics & Beauty marketplace** into a structured analytical solution using **SQL Server** and **Power BI**.

The pipeline covers:

- Data staging and cleansing
- Star Schema warehouse design
- Business logic enrichment
- Advanced SQL analytics
- Interactive dashboard development

The final solution delivers executive-level insights for data-driven decision making.

---

## 📷 Dashboard Preview

![Executive Dashboard Overview](https://github.com/mahmouudbahaa/YOUR_REPO_NAME/raw/main/{05C5CD8A-82FC-4367-B687-C7B4B0E87B82}.png)

---

## 🛠️ Tech Stack & Skills Demonstrated

### Database Engine
- SQL Server (T-SQL)

### Data Architecture
- Staging Layer
- Star Schema Modeling
- Surrogate Key Management (`IDENTITY`)

### Advanced SQL
- CTEs
- Window Functions
  - `ROW_NUMBER()`
  - `NTILE()`
  - `LAG()`
- Aggregations
- Percentile Analysis (`PERCENTILE_DISC`)
- Relational Offsets

### Power BI
- Interactive Dashboards
- KPI Cards
- DAX Calculations

### Power BI Modeling
- Variables (`VAR`)
- `REMOVEFILTERS()`
- Filter Context Management
- Disconnected Tables Handling

### Data Modeling
- Fact & Dimension Design
- Primary Keys / Foreign Keys
- Referential Integrity Controls

---

# 📐 Data Warehouse Architecture (Star Schema)

To optimize analytical query performance and minimize data redundancy across millions of event logs, the raw staging tables were transformed into a strict **Star Schema** model.

---

## Fact Tables

### `Fact_Events`

Central fact table containing:

- User events (`view`, `cart`, `purchase`)
- Product Keys
- User Keys
- Pricing metrics

---

## Dimension Tables

- `Dim_Products`
- `Dim_Users`
- `Dim_Time`

---

## Database Diagram (DBML)

```dbml
Table Dim_Users {
  User_key int [pk]
  User_id int
  User_session string
}

Table Dim_Products {
  Product_key int [pk]
  Product_id int
  Category_id bigint
  Category_code string
  Brand string
}

Table Dim_Time {
  Time_key int [pk]
  Event_time_cleaned datetime2
  Year int
  MONTH int
  DAY int
  Dayofweek int
  HOUR int
}

Table Fact_Events {
  Event_key int [pk]
  Product_key int
  User_key int
  Time_key int
  Event_type string
  Price float
  Event_time_cleaned datetime2
}

Ref: Dim_Users.User_key < Fact_Events.User_key
Ref: Dim_Products.Product_key < Fact_Events.Product_key
Ref: Dim_Time.Time_key < Fact_Events.Time_key
```

---

# 🚀 Key Implementation Steps

## 1. Data Staging & Preprocessing

### Consistency Control

Applied surrogate keys using:

```sql
IDENTITY(1,1)
```

alongside foreign key constraints to ensure reliable dimensional modeling.

### Deduplication & Cleansing

Implemented:

```sql
ROW_NUMBER() OVER(PARTITION BY ...)
```

to eliminate duplicate transactional logs and utilized:

```sql
TRY_CONVERT()
```

to sanitize raw UTC strings into precise `datetime2` formats.

---

## 2. Business Logic Enrichment (SQL Views)

### Customer Segmentation (RFM)

Developed dynamic scoring using:

```sql
NTILE(5)
```

combined with:

```sql
DATEDIFF()
```

to bucket users into Recency, Frequency, and Monetary tiers.

### Month-over-Month Analysis

Built revenue growth metrics using:

```sql
LAG()
```

window functions over aggregated time dimensions to track financial momentum.

---

## 3. Business Intelligence Dashboard

Designed a professional cosmetics-themed dashboard focusing on:

- UI/UX
- KPI visibility
- Interactive cross-filtering
- Performance optimization

### Business Metrics Tracked

- Revenue Performance Trends (MoM)
- E-Commerce Conversion Funnel Drop-offs
- RFM Customer Segment Volumes
- Purchase Frequency Distributions

---

# 📈 Advanced SQL Analytics

The project leverages advanced SQL techniques to generate business insights, including:

- Common Table Expressions (CTEs)
- Window Functions
  - `NTILE()`
  - `LAG()`
  - `ROW_NUMBER()`
- Percentile Analysis (`PERCENTILE_DISC`)
- Revenue & Growth Analysis
- Customer RFM Segmentation
- Digital Funnel Conversion Analytics

---

# 📊 Power BI Dashboard Features

### Interactive KPI Cards

Provide a quick overview of key business metrics.

### Revenue Trend Line Charts

DAX-optimized for efficient filter context management.

### Top Brand Performance Bar Charts

Highlight the highest-performing cosmetic brands.

### Customer Segment Distribution

Treemap visualization for RFM segments.

### Funnel Conversion Tracking

Step-by-step visualization of user journey drop-offs.

### Dynamic Filtering

Filter by:

- Brand
- Monthly cohorts

---

# 🎯 Business Value Delivered

This solution enables stakeholders to:

- Monitor revenue performance and growth velocity.
- Identify severe bottlenecks in the checkout process.
- Target high-value customers dynamically.
- Reallocate marketing spend toward high-converting cosmetic brands.
- Support data-driven marketing and UX optimization decisions.

---

# 📈 Executive Results

For a complete business insights report, see:

```text
docs/EXECUTIVE_SUMMARY.md
```

---

# 📁 Repository Structure

```text
Cosmetics-End-to-End-SQL-Analysis
│
├── README.md
│
├── Screenshots/
│
├── SQL Scripts/
│   ├── 01_Staging_Table.sql
│   ├── 02_Create_Views.sql
│   ├── 03_Dim_and_fact_creation.sql
│   ├── 04_Etl_data_loading.sql
│   └── 05_Analysis.sql
│
├── Power BI/
│
└── docs/
    └── EXECUTIVE_SUMMARY.md
```

---

# 👤 Author

## Bahaa Mandour

**Data Analyst | Project Manager | SQL & Power BI Enthusiast**

---

### Connect with me

- LinkedIn
- GitHub

---
