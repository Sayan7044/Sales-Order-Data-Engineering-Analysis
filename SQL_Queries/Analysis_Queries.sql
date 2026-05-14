-- Table 1
SELECT * FROM cleaned_customers

-- Table 2
SELECT * FROM cleaned_order_details

-- Table 3
SELECT * FROM cleaned_orders

-- Table 4
SELECT * FROM cleaned_products
-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------
-- Top 5 Customers
SELECT c.name, SUM(od.sales) AS revenue
FROM cleaned_customers c JOIN cleaned_orders o
ON c.customer_id = o.customer_id JOIN cleaned_order_details od
ON o.order_id = od.order_id
GROUP BY c.name
ORDER BY SUM(od.sales) DESC
LIMIT 5

-- Region-wise Sales
SELECT c.region, SUM(od.sales) AS revenue
FROM cleaned_customers c JOIN cleaned_orders o
ON c.customer_id = o.customer_id JOIN cleaned_order_details od
ON o.order_id = od.order_id
GROUP BY c.region
ORDER BY SUM(od.sales) DESC

-- Loss-making Products
SELECT p.product_id, od.profit AS loss
FROM cleaned_products p JOIN cleaned_order_details od
ON p.product_id = od.product_id
WHERE od.profit<0
ORDER BY od.profit DESC
LIMIT 5


-- Top 5 Best seller product & revenue made
SELECT p.product_id , SUM(od.quantity) AS total_qty_sold, SUM(od.sales) AS revenue
FROM cleaned_products p JOIN cleaned_order_details od
ON p.product_id = od.product_id
GROUP BY p.product_id
ORDER BY SUM(od.quantity) DESC
LIMIT 5 

-- Region wise delivery days
SELECT region, SUM(delivery_days) AS total_delivery_days
FROM (	
	SELECT c.region, o.order_date, o.ship_date, (o.ship_date-o.order_date) AS delivery_days
	FROM cleaned_customers c JOIN cleaned_orders o
	ON c.customer_id = o.customer_id
	) tt
GROUP BY region
ORDER BY SUM(delivery_days) DESC

-- Monthly Sales Trend
SELECT EXTRACT(month FROM o.order_date) AS order_month, SUM(od.sales) AS monthly_revenue
FROM cleaned_orders o JOIN cleaned_order_details od
ON o.order_id = od.order_id
GROUP BY EXTRACT(month FROM o.order_date)

-- Number of repeat customers
SELECT c.customer_id, COUNT(o.order_id) AS order_count
FROM cleaned_customers c JOIN cleaned_orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) > 1
ORDER BY COUNT(o.order_id) DESC

-- Average Order Value (AOV)
SELECT SUM(od.sales)/COUNT(DISTINCT o.order_id) AS AOV
FROM cleaned_orders o JOIN cleaned_order_details od
ON o.order_id = od.order_id

-- Profit Margin by Category
SELECT p.category, SUM(od.profit)/SUM(od.sales)*100 AS profit_margin
FROM cleaned_products p JOIN cleaned_order_details od
ON p.product_id = od.product_id
GROUP BY p.category
ORDER BY SUM(od.profit)/SUM(od.sales)*100 DESC

-- New VS Repeat Customer
SELECT customer_id,
       COUNT(order_id) AS total_orders,
       CASE 
           WHEN COUNT(order_id) > 1 THEN 'Repeat'
           ELSE 'New'
       END AS customer_type
FROM cleaned_orders
GROUP BY customer_id;

-- Customer Segmentation (High vs Low Value)
SELECT c.customer_id,
       SUM(od.sales) AS total_spent,
       CASE 
           WHEN SUM(od.sales) > 5000 THEN 'High Value'
           ELSE 'Low Value'
       END AS segment
FROM cleaned_customers c
JOIN cleaned_orders o ON c.customer_id = o.customer_id
JOIN cleaned_order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id;


















































































