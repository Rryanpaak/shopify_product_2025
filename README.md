# Shopify_trend_product_2025

## Project overview
This project analyze 'The shopify trend products 2025' using SQLite, Power BI.
The goal is to identify the category-level performance, compare subcategory structure, highlights revenue, sales volume, asp.
The dashboard focuses on the category overview and dive into sub-category such as 'Eco-Friendly' and 'Digital Goods'.

## Objectives
- Analyze overall category performance in 2025
- Compare each category by units, sales, revenue and asp
- Identify high-asp and high-revenue sub categories.

## Dataset
The Dataset contains Shopify trend products in 2025
- **Dataset**: Shopify Trending Products 2025
- **Author**: zulqarnain Haider
- **Platform**: Kaggle
- **License**: Apache License 2.0
- **Link**: https://www.kaggle.com/datasets/zulqarnain11/shopify-trending-products-2025

### columns
- Category
- Sub-Category
- Estimated total units sold in 2025
- Estimated revenue in 2025
- Trend score

## Tool used
- Excel: Used excel for check mis and error values
- SQlite: Used sqlite for data aggregation and query building
- Power BI: For dashboard development

## Analysis Process
- Imported the dataset into SQLite
- Validated the data structure and the columns
- Aggregated the category-level metrics such as total_sold, total_revenue, asp
- Identified the high-asp category using percentile filtering
- Drill down into selected categories for sub-category analysis
- Built Power BI dashboard pages for category overview and selected sub-categories

## Key metrics
total_sold = Estimated_Total_Units_Sold_in_2025

total_revenue = Estimated_Revenue_in_2025_USD

ASP(Average Selling Price) = total_revenue / total_sold

## Dashboard structure
1. Category overview
   - Show the category-level comparison by total sold, total revenue and asp
2. Eco-Friendly deep dive
   - Show the sub-category positioning, revenue structure, and ASP differenties within Eco-Friendly products
3. Digital Goods deep dive
   - Explore the revenue concentration, ASP positioning and sub-category performance within Digital Goods products

## Key Insights
Soe Categories generate high revenue despite relatively lower amount of sales.
Eco-Friendly products show meaningful variation in sub category revenue and asp
In Digital Goods, revenue was concentrated in a few leading products

## Limitationns
The dataset based on estimated 2025 values, not the actual transactional values

