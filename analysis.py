# ============================================================
# E-COMMERCE DATA ANALYSIS - PYTHON SCRIPT
# Author: Kuntumuri Sai Prasanna
# Tools: Python, pandas, matplotlib, seaborn
# ============================================================

import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import seaborn as sns

# ── Load Data ────────────────────────────────────────────────
df = pd.read_csv('ecommerce_data.csv', parse_dates=['order_date'])
df['revenue'] = df['quantity'] * df['unit_price']
df['month'] = df['order_date'].dt.to_period('M').astype(str)

delivered = df[df['status'] == 'Delivered'].copy()

print("=" * 50)
print("E-COMMERCE ANALYSIS SUMMARY")
print("=" * 50)
print(f"Total Orders      : {len(df)}")
print(f"Total Revenue     : ₹{delivered['revenue'].sum():,.0f}")
print(f"Avg Order Value   : ₹{delivered['revenue'].mean():,.0f}")
print(f"Unique Customers  : {df['customer_id'].nunique()}")
print(f"Return Rate       : {(df['status']=='Returned').mean()*100:.1f}%")
print("=" * 50)

# ── Plot Setup ───────────────────────────────────────────────
sns.set_theme(style="whitegrid", palette="Blues_d")
fig, axes = plt.subplots(2, 2, figsize=(14, 10))
fig.suptitle("E-Commerce Sales Analysis Dashboard", fontsize=16, fontweight='bold', y=1.01)

# 1. Revenue by Category
cat_rev = delivered.groupby('category')['revenue'].sum().sort_values(ascending=True)
axes[0, 0].barh(cat_rev.index, cat_rev.values, color=sns.color_palette("Blues_d", len(cat_rev)))
axes[0, 0].set_title('Revenue by Category', fontweight='bold')
axes[0, 0].set_xlabel('Revenue (₹)')
axes[0, 0].xaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'₹{x/1000:.0f}K'))

# 2. Monthly Revenue Trend
monthly = delivered.groupby('month')['revenue'].sum()
axes[0, 1].plot(monthly.index, monthly.values, marker='o', color='#1F4E79', linewidth=2.5)
axes[0, 1].fill_between(monthly.index, monthly.values, alpha=0.15, color='#1F4E79')
axes[0, 1].set_title('Monthly Revenue Trend', fontweight='bold')
axes[0, 1].set_xlabel('Month')
axes[0, 1].set_ylabel('Revenue (₹)')
axes[0, 1].yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'₹{x/1000:.0f}K'))
axes[0, 1].tick_params(axis='x', rotation=30)

# 3. Revenue by Region
reg_rev = delivered.groupby('region')['revenue'].sum().sort_values(ascending=False)
colors = sns.color_palette("Blues_d", len(reg_rev))
axes[1, 0].bar(reg_rev.index, reg_rev.values, color=colors)
axes[1, 0].set_title('Revenue by Region', fontweight='bold')
axes[1, 0].set_xlabel('Region')
axes[1, 0].set_ylabel('Revenue (₹)')
axes[1, 0].yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, _: f'₹{x/1000:.0f}K'))

# 4. Return Rate by Category
ret = df.groupby('category').apply(
    lambda x: (x['status'] == 'Returned').sum() / len(x) * 100
).sort_values(ascending=False)
axes[1, 1].bar(ret.index, ret.values, color=sns.color_palette("Reds_d", len(ret)))
axes[1, 1].set_title('Return Rate by Category (%)', fontweight='bold')
axes[1, 1].set_xlabel('Category')
axes[1, 1].set_ylabel('Return Rate (%)')
axes[1, 1].tick_params(axis='x', rotation=20)

plt.tight_layout()
plt.savefig('ecommerce_dashboard.png', dpi=150, bbox_inches='tight')
plt.show()
print("\n✅ Dashboard saved as ecommerce_dashboard.png")

# ── Top Customers ────────────────────────────────────────────
print("\nTop 5 Customers by Revenue:")
top_customers = (delivered.groupby(['customer_id', 'customer_name'])['revenue']
                 .sum().sort_values(ascending=False).head(5))
print(top_customers.to_string())

# ── Customer Segmentation ────────────────────────────────────
cust_rev = delivered.groupby('customer_name')['revenue'].sum()
def segment(val):
    if val >= 50000: return 'Premium'
    elif val >= 20000: return 'Regular'
    return 'Occasional'

cust_segments = cust_rev.apply(segment).value_counts()
print("\nCustomer Segments:")
print(cust_segments.to_string())
