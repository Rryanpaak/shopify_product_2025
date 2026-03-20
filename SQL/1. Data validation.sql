queries will be here

## data validation

-- count columns
SELECT
	count(*)
from shopify_trending_2025

-- checking missing values
SELECT
	Product_ID,
	count(*) as cnt
from shopify_trending_2025
group by Product_ID
HAVING count(*) > 1
ORDER by count(*) desc;

SELECT
	sum(case when Product_ID is null or trim(Product_ID) = ' ' then 1 else 0 end) as miss_product_id,
	sum(case when Product_Name is null or trim(Product_Name) = ' ' then 1 else 0 end) as miss_product_name,
	sum(case when Category is null or trim(Category) = ' ' then 1 else 0 end) as miss_category,
	sum(case when Subcategory is null or trim(Subcategory) = ' ' then 1 else 0 end) as miss_sub_category,
	sum(case when Estimated_Revenue_in_2025_USD is null or trim(Estimated_Revenue_in_2025_USD) = ' ' then 1 else 0 end) as miss_revenue,
	sum(case when Estimated_Total_Units_Sold_in_2025 is null or trim(Estimated_Total_Units_Sold_in_2025) = ' ' then 1 else 0 end) as miss_sold,
	sum(case when Price_Range_USD is null or trim(Price_Range_USD) = ' ' then 1 else 0 end) as miss_price_range,
	sum(case when Trend_Score is null or trim(Trend_Score) = ' ' then 1 else 0 end) as miss_score,
	sum(case when Trend_Source is null or trim(Trend_Source) = ' ' then 1 else 0 end) as miss_source,
	sum(case when Notes is null or trim(Notes) = ' ' then 1 else 0 end) as miss_notes
from shopify_trending_2025

## Data analysis

-- mininum, maximum and average trend score
SELECT
	min(Trend_Score) as min_score,
	max(Trend_Score) as max_score,
	round(avg(Trend_Score),2) as average_score
from shopify_trending_2025

-- To count the number of columns each categories
SELECT
	Category,
	count(*) as cnt
from `shopify_trending_2025`
group by Category
order by cnt DESC

-- Average trend score of each categories
SELECT
	Category,
	round(avg(Trend_Score),2) as average_score,
	count(distinct(Product_ID)) as product_cnt
from `shopify_trending_2025`
GROUP by Category
HAVING product_cnt >= 10
order by average_score DESC
limit 10;

-- Figured out the total sales of each category
SELECT
	Category,
	sum(Estimated_Total_Units_Sold_in_2025) as total_sold
from `shopify_trending_2025`
group by Category
order by total_sold DESC
limit 10;

-- Average revenue of each category
SELECT
	Category,
	round(avg(Estimated_Revenue_in_2025_USD),2) as average_revenue
from `shopify_trending_2025`
GROUP by Category
ORDER by average_revenue desc
limit 10;

-- Average trend score of each category
SELECT
	Category,
	round(avg(Trend_Score),2) as avg_trend_score,
	Trend_Source
from shopify_trending_2025
GROUP by Category
ORDER by Trend_Score desc;

## Product-level analysis with Categorie (which units sold the most in 2025)
-- In the previous analysis, 'Beauty & Skincare' ranks #1. So I'd decided to deep dive into which products sales the most
-- The most selling products and revenue within Beauty & Skincare category

SELECT
	Category,
	Subcategory,
	Count(*) as cnt,
	sum(Estimated_Total_Units_Sold_in_2025) as total_sold,
	round(avg(Estimated_Revenue_in_2025_USD),2) as average_revenue
from `shopify_trending_2025`
where Category = 'Beauty & Skincare'
GROUP by Subcategory
order by average_revenue desc;

## On the ASP basis

-- Check the quantity total_sold, total_revenue and asp
SELECT
	Category,
	sum(Estimated_Total_Units_Sold_in_2025) as total_sold,
	sum(Estimated_Revenue_in_2025_USD) as total_revenue,
	round(sum(Estimated_Revenue_in_2025_USD) / SUM(Estimated_Total_Units_Sold_in_2025), 2) as asp
from shopify_trending_2025
GROUP by Category
order by total_sold desc;

-- Check the share of sales market

with cat_quantity as (
	SELECT
		Category,
		sum(Estimated_Total_Units_Sold_in_2025) as sold,
		sum(Estimated_Revenue_in_2025_USD) as revenue
	from shopify_trending_2025
	group by Category
)
SELECT
	*,
	round(1.0 * sold / sum(sold) OVER(), 2) * 100 as share_sold,
	round(1.0 * revenue / sum(revenue) over(),2) * 100 as share_revenue
from cat_quantity
order by share_sold desc;

-- Before deep dive into sub-category, figured out top 20% of asp

with cat_asp as (
	SELECT
		Category,
		sum(Estimated_Revenue_in_2025_USD) as revenue,
		sum(Estimated_Total_Units_Sold_in_2025) as sold,
		round(1.0 * sum(Estimated_Revenue_in_2025_USD) / sum(Estimated_Total_Units_Sold_in_2025),2) as asp
	from shopify_trending_2025
	group by Category
),
scored as (
	SELECT
		*,
		percent_rank() over(order by asp) as percentage
	from cat_asp
)
SELECT
	*
from scored
where percentage >= 0.80
order by asp desc;

-- From this query, I found out 'Eco-Friedly' and 'Digital Goods' account for the top 20%
with cat_asp as (
	SELECT
		Category,
		sum(Estimated_Revenue_in_2025_USD) as revenue,
		sum(Estimated_Total_Units_Sold_in_2025) as sold,
		round(1.0 * sum(Estimated_Revenue_in_2025_USD) / sum(Estimated_Total_Units_Sold_in_2025),2) as asp
	from shopify_trending_2025
	group by Category
),
cat_share as (
	SELECT
		*,
		round(1.0 * revenue / sum(revenue) over(),2) as sh_revenue,
		round(1.0 * sold / sum(sold) over(),2) as sh_sold,
		round(percent_rank() over(order by asp),2) as pr_asp
	from cat_asp
)
SELECT
	*
from cat_share
where pr_asp >= 0.80
order by asp desc;

## Deep down into category, 'Eco-Friendly'

-- Make an list of Eco-Friendly
SELECT DISTINCT
	Category,
	Subcategory
from shopify_trending_2025
WHERE Category = 'Eco-Friendly'

-- Top 10 of sales within Eco-Friendly
	
SELECT DISTINCT
	Category,
	Subcategory,
	sum(Estimated_Total_Units_Sold_in_2025) as total_sold,
	sum(Estimated_Revenue_in_2025_USD) as total_revenue
from shopify_trending_2025
where Category = 'Eco-Friendly'
group by Category, Subcategory
ORDER by total_sold desc;

-- Which products take high trend score

SELECT
	Category,
	Subcategory,
	Trend_Score
from shopify_trending_2025
where Category = 'Eco-Friendly'
group by Category, Subcategory
ORDER by Trend_Score desc;

-- Find out the share and asp in Eco-Friendly
with cat_asp as (
	SELECT
		Category,
		Subcategory,
		sum(Estimated_Total_Units_Sold_in_2025) as total_sold,
		sum(Estimated_Revenue_in_2025_USD) as total_revenue,
		round(1.0 * sum(Estimated_Revenue_in_2025_USD) / sum(Estimated_Total_Units_Sold_in_2025),2) as asp
	from shopify_trending_2025
	where Category = 'Eco-Friendly'
	group by Category, Subcategory
)
SELECT
	Category,
	Subcategory,
	round(1.0 * total_sold / sum(total_sold) over(),2) * 100 as share_sold,
	round(1.0 * total_revenue / sum(total_revenue) over(),2) * 100 as share_revenue,
	asp
from cat_asp
order by asp desc;

## Deep down into the category, 'Digital Goods'

-- List of the sub-category in Digital Goods
	
SELECT DISTINCT
	Category,
	Subcategory
from shopify_trending_2025
WHERE Category = 'Digital Goods'

-- Unlike the category 'Eco-Friendly', Figured out the results such as total_sold, total_revenue, asp, share of sales and revenue in one time.
With cat_digi as (
	SELECT
		Category,
		Subcategory,
		sum(Estimated_Total_Units_Sold_in_2025) as total_sold,
		sum(Estimated_Revenue_in_2025_USD) as total_revenue,
		round(1.0 * sum(Estimated_Revenue_in_2025_USD) / sum(Estimated_Total_Units_Sold_in_2025),2) as asp
	from shopify_trending_2025
	where Category = 'Digital Goods'
	GROUP by Category, Subcategory
),
share_cat as (
	SELECT
		Category,
		Subcategory,
		total_sold,
		round(1.0 * total_sold / sum(total_sold) over(),2) as share_sold,
		total_revenue,
		round(1.0 * total_revenue / sum(total_revenue) over(),2) as share_revenue,
		asp
	from cat_digi
)
SELECT
	Category,
	Subcategory,
	total_sold,
	share_sold,
	total_revenue,
	share_revenue,
	asp
from share_cat
order by total_sold desc;
		
-- Find out the opportunity by figuring out the percentage of total_revenue and asp
With sub_cat as (
	SELECT
		Category,
		Subcategory,
		sum(Estimated_Total_Units_Sold_in_2025) as total_sold,
		sum(Estimated_Revenue_in_2025_USD) as total_revenue,
		round(1.0 * sum(Estimated_Revenue_in_2025_USD) / sum(Estimated_Total_Units_Sold_in_2025),2) as asp
	from shopify_trending_2025
	where Category = 'Eco-Friendly'
	group by Category, Subcategory
),
cat_share as (
	SELECT
		s.*,
		round(1.0 * total_sold / sum(total_sold)over(),2) as share_sold,
		round(1.0 * total_revenue / sum(total_revenue) over(),2) as share_revenue
	from sub_cat s
),
cat_rank as (
	SELECT
		c.*,
		percent_rank () over(PARTITION by Category ORDER by share_revenue) as per_revenue,
		percent_rank () over(PARTITION by Category ORDER by asp) as per_asp
	from cat_share c
)
SELECT
	Category,
	Subcategory,
	total_sold,
	share_sold,
	total_revenue,
	share_revenue,
	asp,
	per_revenue,
	per_asp,
	case
		when per_revenue >= 0.50 and per_asp >= 0.80 then 'High Share + High ASP'
		when per_revenue >= 0.50 and per_asp < 0.80 then 'High Share + Low ASP'
		when per_revenue < 0.50 and per_asp >= 0.80 then 'Low Share + High ASP'
		ELSE 'LOW Share + Low ASP'
	end as quadrant
from cat_rank
order by quadrant, per_revenue desc, asp desc;


## Made the views for Power BI

drop view if exists vw_sub_base;

create view vw_sub_digital_goods_base as
with sub_base as (
SELECT
	Category,
	Subcategory,
	sum(Estimated_Total_Units_Sold_in_2025) as total_sold,
	sum(Estimated_Revenue_in_2025_USD) as total_revenue
from shopify_trending_2025
where Category = 'Digital Goods'
group by Category, Subcategory
)
SELECT
	Category,
	Subcategory,
	total_sold,
	total_revenue,
	round(1.0 * total_revenue / total_sold ,2) as asp
from sub_base
order by asp desc;
