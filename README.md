# 📊 Cosmetics E-Commerce Sales & Customer Behavior Analytics  
**End-to-End SQL Server & Power BI Project**

---

## 📌 Overview  
This project transforms raw e-commerce web logs from a cosmetics marketplace into a structured analytical solution using SQL Server and Power BI.

The goal is to understand customer behavior, improve retention, and identify high-value customers through data-driven insights.

The project includes:
- Data cleaning & preprocessing
- Star schema data warehouse design
- SQL-based analytics
- RFM customer segmentation
- Interactive Power BI dashboard

---

## 🎯 Business Problem  
E-commerce businesses often struggle to understand customer behavior beyond basic sales metrics.

This project answers key business questions:

- Where do customers drop off in the purchase journey?
- Which customers generate the most revenue?
- How can we identify and prioritize high-value customers?
- How can customer segmentation improve marketing strategies?

---

## 🛠️ Tech Stack  
- SQL Server (T-SQL)  
- Power BI (DAX, Data Modeling)  
- Data Warehousing (Star Schema)  
- Advanced SQL (CTEs, Window Functions)  
- RFM Analysis  

---

## 🏗️ Data Model  
A Star Schema was designed to optimize analytical performance:

- **Fact_Events** → user interactions (views, cart, purchases)  
- **Dim_Users**  
- **Dim_Products**  
- **Dim_Time**  

This structure enables fast and scalable analytics across millions of event logs.

---

## ⚙️ Key Work Done  

### 1. Data Processing  
- Cleaned and standardized raw event logs  
- Removed duplicates using `ROW_NUMBER()`  
- Converted timestamps and structured event data  

---

### 2. SQL Analytics  
- Revenue and trend analysis using window functions (`LAG`, `NTILE`)  
- Percentile-based customer and product performance analysis  
- Funnel behavior analysis across user events  

---

### 3. Customer Segmentation (RFM)  
Customers were segmented based on:
- Recency  
- Frequency  
- Monetary value  

Resulting in groups such as:
- High-value customers  
- At-risk customers  
- One-time buyers  

---

### 4. Power BI Dashboard  
Built an interactive dashboard featuring:
- Revenue trends (MoM growth)  
- Customer segmentation overview  
- Product & brand performance  
- Conversion funnel analysis  
- KPI tracking  

---

## 📊 Key Insights  
- A small percentage of customers contribute the majority of revenue (Pareto effect)  
- Significant drop-off occurs between product interaction and purchase  
- High-value customers show strong repeat purchase behavior  
- Certain product categories dominate revenue contribution  

---

## 💡 Business Impact  
This analysis enables:
- Identification of high-value customer segments  
- Improved marketing targeting and retention strategies  
- Funnel optimization opportunities  
- Data-driven decision-making for revenue growth  

# 📈 Executive Results

For a complete business insights report, see: [Executive Summary](Docs/EXECUTIVE_SUMMARY.md)

---

---

## 🚀 Conclusion  
This project demonstrates how raw e-commerce event data can be transformed into actionable business insights using SQL and Power BI.

It combines data engineering, analytics, and business intelligence to support strategic decision-making.

---

## 👤 Author  
**Bahaa Mandour**  
Data Analyst | SQL | Power BI | Data Engineering Enthusiast  
