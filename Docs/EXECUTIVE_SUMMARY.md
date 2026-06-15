# 📈 Executive Results Report

Data-driven findings extracted directly from advanced T-SQL analytics executed against the warehouse layer.

---

# 🌐 High-Level Commercial KPIs

The cosmetics marketplace processed hundreds of thousands of purchase events while generating strong revenue growth.

| KPI | Value |
|------|--------|
| Total Revenue Generated | $2.79M |
| Total Purchase Events | 578,568 |
| Purchasing Customers | 65,703 |
| Products Sold | 34,195 |
| Average Selling Price | $4.83 |

### Key Insight

The marketplace generated approximately **$2.79 million** in revenue across more than **578 thousand purchase events**, supported by over **65 thousand purchasing customers** and a broad product assortment.

---

# 📦 Product Price Distribution Analysis

Statistical analysis reveals a marketplace heavily dominated by affordable cosmetic products.

| Statistical Metric | Value |
|-------------------|--------|
| Minimum Price | $0.05 |
| Maximum Price | $311.38 |
| Average Price | $4.83 |
| Median Price | $3.00 |

### Key Insight

The noticeable gap between the average price ($4.83) and the median price ($3.00) indicates a right-skewed distribution.

Most transactions occur within low-price ranges, while a smaller number of premium products increase the overall average selling price.

---

# 📅 Revenue Growth & Seasonality Trends

Month-over-Month analysis using SQL window functions (`LAG()`) reveals strong marketplace growth.

| Month | Revenue |
|---------|---------|
| October 2019 | $1,221,385 |
| November 2019 | $1,571,068 |
| MoM Growth | 28.6% |

### Growth Highlights

- Revenue increased by nearly **$350K** within one month.
- November revenue exceeded October revenue by **28.6%**.
- Customer demand strengthened significantly over the observed period.

### Key Insight

The marketplace demonstrated rapid short-term growth, indicating increasing customer activity and healthy revenue momentum.

---

# 🎯 Customer Segmentation (RFM Analysis)

Customers were segmented based on Recency, Frequency, and Monetary value.

| Segment | Customers | Share of Customers |
|-----------|-----------:|------------------:|
| Loyal Customers | 17,018 | 25.9% |
| At-Risk Customers | 13,286 | 20.2% |
| New Customers | 7,695 | 11.7% |
| Champions | 7,564 | 11.5% |
| Lost Customers | 7,260 | 11.0% |

### Key Insight

Loyal customers represent the largest customer segment, accounting for nearly **26%** of purchasing users.

Meanwhile, over **20%** of customers are classified as At-Risk, highlighting opportunities for retention campaigns and personalized marketing strategies.

---

# 🔄 E-Commerce Funnel Analysis

Customer behavior was analyzed throughout the purchasing journey.

```text
View → Cart → Purchase
```

| Funnel Stage | Events |
|--------------|---------:|
| Product Views | 1,708,070 |
| Add-to-Cart Events | 440,728 |
| Purchases | 65,703 |

### Conversion Metrics

| Metric | Rate |
|---------|------:|
| Cart Rate (View → Cart) | 25.8% |
| Purchase Rate (Cart → Purchase) | 14.91% |
| Overall Conversion Rate (View → Purchase) | 3.85% |

### Key Insight

While approximately one-quarter of product views progress to the cart stage, only **3.85%** of browsing sessions ultimately convert into purchases.

The largest customer drop-off occurs after adding products to the cart, suggesting opportunities to optimize checkout experience and reduce purchase abandonment.

---

# 🏷 Top Brands by Revenue

Several brands emerged as key contributors to marketplace revenue.

| Brand | Revenue |
|---------|---------:|
| Runail | $148,325 |
| Grattol | $106,918 |
| Irisk | $92,495 |
| Uno | $86,342 |
| Strong | $67,868 |

### Key Insight

**Runail** generated the highest revenue among all brands, followed by **Grattol** and **Irisk**, indicating strong customer preference and brand loyalty within the professional cosmetics segment.

---

# 🛒 Purchase Frequency Analysis

| Metric | Value |
|---------|------:|
| Purchase Frequency | 0.04 |

### Key Insight

Customer purchasing behavior suggests relatively infrequent repeat purchases, emphasizing the importance of retention initiatives and customer lifetime value optimization.

---

# 🎯 Executive Conclusions

## Revenue & Growth

- Generated approximately **$2.79M** in revenue.
- Achieved **28.6% Month-over-Month growth**.
- Demonstrated strong short-term revenue momentum.

## Customer Behavior

- Loyal customers represent the largest customer segment.
- More than **20%** of customers are at risk of churn.
- Repeat purchasing opportunities remain largely untapped.

## Commercial Operations

- Revenue is primarily driven by affordable products sold at scale.
- A small number of higher-priced products elevate average prices.

## Conversion Performance

- Product browsing activity is strong.
- Significant customer drop-off occurs between cart and purchase stages.
- Overall conversion rate remains relatively low at **3.85%**, presenting opportunities for checkout optimization.

## Brand Performance

- Runail, Grattol, and Irisk are the leading revenue-generating brands.
- High-performing brands provide valuable targets for future marketing investments.

## Business Intelligence Impact

This analytical solution enables stakeholders to monitor growth, understand customer behavior, identify conversion bottlenecks, and support data-driven commercial and marketing decisions.
