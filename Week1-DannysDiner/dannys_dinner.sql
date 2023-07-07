/*What is the total amount each customer spent at the restaurant?*/
SELECT s.customer_id, SUM(price) as total_amount
FROM sales as s
INNER JOIN menu
USING(product_id)
GROUP BY s.customer_id
ORDER BY total_amount DESC;

