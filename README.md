# 🛒 E-Commerce Sales Analysis

A complete data analysis project using **Python** and **SQL** to uncover revenue patterns, customer behaviour, and product performance from an e-commerce dataset.

---

## 📌 Project Overview

This project simulates a real-world data analyst task:
- Analyse 50 orders across 5 months (Jan–May 2024)
- Identify top revenue categories and regions
- Segment customers by spending behaviour
- Track monthly revenue trends and growth
- Calculate return rates by category

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|------|---------|
| Python (pandas) | Data loading, cleaning, aggregation |
| Python (matplotlib, seaborn) | Data visualisation |
| SQL (MySQL compatible) | Querying and analysis |
| Jupyter Notebook | Exploratory analysis |
| Git & GitHub | Version control |

---

## 📂 Project Structure

```
sql-ecommerce-analysis/
│
├── ecommerce_data.csv        # Dataset (50 orders, 10 columns)
├── analysis_queries.sql      # 15+ SQL queries (basic to advanced)
├── analysis.py               # Python analysis + dashboard
├── ecommerce_dashboard.png   # Output visualisation
└── README.md                 # Project documentation
```

---

## 📊 Key Insights

- **Electronics** is the top revenue category, contributing over 60% of total sales
- **North region** leads in revenue, followed closely by South
- **Repeat customers** account for 40% of total orders
- **Return rate** is highest in Home & Kitchen and Clothing categories
- Monthly revenue shows a consistent **upward trend** from Jan to May 2024

---

## 🔍 SQL Highlights

- Multi-table aggregations with `GROUP BY` and `HAVING`
- Customer segmentation using `CASE WHEN`
- **Window functions**: `RANK()`, `LAG()`, running totals with `SUM() OVER()`
- Month-over-month growth using CTEs

---

## 📈 Dashboard Preview

![E-Commerce Dashboard](ecommerce_dashboard.png)

---

## 🚀 How to Run

```bash
# Clone the repository
git clone https://github.com/Prasannapoorna/sql-ecommerce-analysis.git

# Install dependencies
pip install pandas matplotlib seaborn

# Run analysis
python analysis.py
```

---

## 👤 Author

**Kuntumuri Sai Prasanna**
- 💼 LinkedIn: [linkedin.com/in/saiprasu2996](https://linkedin.com/in/saiprasu2996)
- 📧 Email: saiprasu2996@gmail.com
- 🌍 Open to Remote Data Analyst roles worldwide
