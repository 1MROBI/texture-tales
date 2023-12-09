##Q1 What was the total quantity sold for all products?

SELECT 
	details.product_name,
	SUM(sales.qty) AS sale_counts
FROM sales AS sales
INNER JOIN product_details AS details
	ON sales.prod_id = details.product_id
GROUP BY details.product_name
ORDER BY sale_counts DESC;

##Q2 What is the total generated revenue for all products before discounts?


SELECT 
	SUM(price * qty) AS nodis_revenue
FROM sales AS sales;

##Q3 What was the total discount amount for all products?


SELECT 
	SUM(price * qty * discount)/100 AS total_discount
FROM sales;


##Q4 How many unique transactions were there?


SELECT 
	COUNT(DISTINCT txn_id) AS unique_txn
FROM sales;

##Q5 What are the average unique products purchased in each transaction?

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


##Q6 What is the average discount value per transaction?

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



##Q7 What is the average revenue for member transactions and non-member transactions?

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

## Q8 What are the top 3 products by total revenue before discount?

SELECT pd.product_name, SUM(s.qty*s.price) 'total_revenue'
FROM product_details pd,sales s
WHERE s.prod_id = pd.product_id
GROUP BY pd.product_name
ORDER BY total_revenue DESC LIMIT 3

## Q9 What are the total quantity, revenue and discount for each segment? 

SELECT pd.segment_id,pd.segment_name, SUM(qty) 'total_quantity', SUM(s.qty*s.price) 'total_revenue', ROUND(SUM(s.qty*s.price*s.discount)/100) 'total_discount'
FROM product_details pd, sales s
WHERE s.prod_id = pd.product_id
GROUP BY pd.segment_id,pd.segment_name

## Q10 What is the top selling product for each segment?


SELECT pd.segment_id, pd.segment_name,pd.product_name, pd.product_id ,SUM(s.qty) 'quantity'
FROM product_details pd, sales s
WHERE s.prod_id = pd.product_id
GROUP BY pd.segment_id,pd.product_name,pd.product_name,pd.product_id
ORDER  BY quantity DESC LIMIT 5


## Q11 What are the total quantity, revenue and discount for each category?

SELECT pd.category_id,pd.category_name, SUM(s.qty) 'total_quantity', SUM(s.qty*s.price) 'total_revenue',ROUND(SUM(s.qty*s.price*s.discount)/100) 'total_discount'
FROM product_details pd,sales s
WHERE s.prod_id = pd.product_id
GROUP BY pd.category_id,pd.category_name


## Q12 What is the top selling product for each category?

SELECT pd.category_id,pd.category_name,pd.product_name, pd.product_id,SUM(s.qty) 'product_quantity'
FROM product_details pd,sales s
WHERE s.prod_id = pd.product_id
GROUP BY pd.category_id,pd.category_name,pd.product_name, pd.product_id
ORDER BY product_quantity DESC LIMIT 5





SELECT * FROM product_details
SELECT * FROM product_hierarchy
SELECT * FROM product_prices
SELECT * FROM sales