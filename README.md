# Olist E-Commerce Business Analysis using SQL

## Project Overview

This project analyzes the Olist Brazilian E-Commerce dataset using MySQL to identify business trends, customer behavior, sales performance, delivery efficiency, and product performance.

The objective is to transform raw e-commerce data into meaningful business insights using SQL queries.

## Tools & Technologies

- MySQL 8.0.46
- MySQL Workbench
- SQL

## Dataset

The project uses the Olist Brazilian E-Commerce dataset, containing information about orders, customers, products, sellers, order items, and payments.

## Tables Used

1. `olist_orders_dataset`
2. `olist_order_items_dataset`
3. `olist_order_payments_dataset`
4. `olist_customers_dataset`
5. `olist_products_dataset`
6. `olist_sellers_dataset`

## Business Analysis Performed

A total of 15 business analyses were performed:

1. Order Status Distribution
2. Payment Method Analysis
3. Top Product Categories by Revenue
4. Top Customers by Spending
5. Average Order Value (AOV)
6. Monthly Revenue Analysis
7. State-wise Sales Analysis
8. Repeat Customer Analysis
9. Late Delivery Analysis
10. Order Cancellation Analysis
11. Top Selling Products
12. Seller Performance Analysis
13. Freight Cost Analysis by Customer State
14. Month-over-Month Revenue Growth
15. Product Category Ranking

## Key Business Insights

- Approximately 97.02% of orders were successfully delivered.
- Credit cards accounted for approximately 77.8% of total payment value.
- Beauty & Health was the highest-revenue product category, generating R$1,258,681.34.
- The average order value was R$160.99.
- São Paulo generated the highest state-wise revenue, approximately R$5.99 million.
- The repeat customer rate was approximately 3.12%.
- Approximately 6.77% of delivered orders were late.
- The overall order cancellation rate was approximately 0.63%.
- November 2017 recorded the highest monthly revenue of approximately R$1.19 million.
- The largest month-over-month revenue increase occurred in November 2017, with growth of approximately 53.25%.

## SQL Concepts Used

- SELECT, WHERE, GROUP BY, ORDER BY
- Aggregate functions: COUNT(), SUM(), AVG()
- JOIN operations
- Subqueries
- Common Table Expressions (CTEs)
- CASE WHEN statements
- Date and time functions
- Window functions: LAG(), RANK()
- NULL handling
- Data aggregation and business calculations

## Project Structure

```text
ecommerce-business-analysis/
│
├── dataset/
│   └── olist_dataset/
│
├── sql/
│   ├── 01_database_setup.sql
│   └── 02_business_analysis.sql
│
├── insights/
│   └── Analysis insight files
│
└── README.md
```

## How to Run the Project

1. Install MySQL Server and MySQL Workbench.
2. Download and extract the Olist dataset.
3. Import the required CSV files into MySQL.
4. Open `01_database_setup.sql` and execute it.
5. Open `02_business_analysis.sql` and execute the analysis queries.
6. Review the query outputs to understand the business insights.

## Important Notes

- Revenue calculations using order payments are based on payment values.
- Product category, individual product, and seller revenue calculations use item prices and exclude freight.
- Delivery delays are calculated by comparing calendar dates.
- The dataset covers a historical period; incomplete months should be interpreted carefully.
- Repeat customer analysis is limited to the available dataset period.

## Conclusion

This project demonstrates practical SQL skills through real-world e-commerce business analysis. It uses relational joins, aggregations, CTEs, subqueries, and window functions to answer business questions and generate actionable insights.

---

**Project Type:** Data Analytics Portfolio Project  
**Database:** MySQL  
**Domain:** E-Commerce Analytics