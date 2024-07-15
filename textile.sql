use mysql;
select * from sales limit 10;
select * from product_prices;
select * from product_details;
select * from product_hierarchy;

-- 1
select p.product_name,sum(s.qty) as total_qnt from product_details p join sales s on s.prod_id=p.product_id
group by p.product_name order by total_qnt desc;

-- 2
select sum(price*qty) as before_discount from sales;

-- 3
select count(distinct(txn_id)) as unique_trans from sales;

-- 4
SELECT 
	SUM(price * qty * discount)/100 AS total_discount
FROM sales;

-- 5
WITH cte_transaction_products AS (
	SELECT
		txn_id,
		COUNT(DISTINCT prod_id) AS product_count
	FROM sales
	GROUP BY txn_id
)
SELECT
	ROUND(AVG(product_count)) AS avg_unique_products
FROM cte_transaction_products;

-- 6
WITH cte_transaction_discounts AS (
	SELECT
		txn_id,
		SUM(price * qty * discount)/100 AS total_discount
	FROM sales
	GROUP BY txn_id
)
SELECT
	ROUND(AVG(total_discount)) AS avg_unique_products
FROM cte_transaction_discounts;

-- 7
WITH cte_member_revenue AS (
  SELECT
    member,
    txn_id,
    SUM(price * qty) AS revenue
  FROM sales
  GROUP BY 
	member, 
	txn_id
)
SELECT
  member,
  ROUND(AVG(revenue), 2) AS avg_revenue
FROM cte_member_revenue
GROUP BY member;

-- 8
select p.product_name,sum(s.price*s.qty)as revenue from sales s join
product_details p on p.product_id=s.prod_id 
group by p.product_name 
order by revenue desc
limit 3;

-- 9
select p.segment_name,sum(s.qty) as total_qnty,sum(s.price*s.qty) as revenue,
sum(s.price*s.qty*s.discount)/100 as tot_dis from sales s join 
product_details p on p.product_id=s.prod_id
group by p.segment_name;

-- 10
SELECT 
	details.segment_id,
	details.segment_name,
	details.product_id,
	details.product_name,
	SUM(sales.qty) AS product_quantity
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY
	details.segment_id,
	details.segment_name,
	details.product_id,
	details.product_name
ORDER BY product_quantity DESC
LIMIT 5;

-- 11
SELECT 
	details.category_id,
	details.category_name,
	SUM(sales.qty) AS total_quantity,
	SUM(sales.qty * sales.price) AS total_revenue,
	SUM(sales.qty * sales.price * sales.discount)/100 AS total_discount
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY 
	details.category_id,
	details.category_name
ORDER BY total_revenue DESC;

-- 12
SELECT 
	details.category_id,
	details.category_name,
	details.product_id,
	details.product_name,
	SUM(sales.qty) AS product_quantity
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY
	details.category_id,details.category_name,
	details.product_id,
	details.product_name
ORDER BY product_quantity DESC
LIMIT 5;

