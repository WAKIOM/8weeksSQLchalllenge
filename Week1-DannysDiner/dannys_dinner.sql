-- What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, SUM(price) as total_amount
FROM sales as s
INNER JOIN menu
USING(product_id)
GROUP BY s.customer_id
ORDER BY total_amount DESC;

-- How many days has each customer visited the restaurant?
SELECT customer_id, COUNT(DISTINCT order_date) AS days_visited
FROM sales
GROUP BY customer_id
ORDER BY days_visited DESC;

-- What was the first item from the menu purchased by each customer?
SELECT DISTINCT s.customer_id, m.product_name AS first_buy
FROM (
		  SELECT customer_id, MIN(order_date) AS min_order_date
		  FROM sales
		  GROUP BY customer_id
) AS s
JOIN sales AS s2 ON s.customer_id = s2.customer_id AND s.min_order_date = s2.order_date
JOIN menu AS m ON s2.product_id = m.product_id
ORDER BY s.customer_id;

-- What is the most purchased item on the menu and how many times was it purchased by all customers
SELECT s.customer_id, m.product_name, COUNT(*) AS product_count
FROM sales AS s
INNER JOIN menu AS m
    USING(product_id)
WHERE s.product_id IN (
		    SELECT product_id
		    FROM sales
		    GROUP BY product_id
		    ORDER BY COUNT(*) DESC
		    LIMIT 1
)
GROUP BY s.customer_id, m.product_name
ORDER BY product_count DESC;

-- Which item was the most popular for each customer?
SELECT customer_id, product_name AS most_popular_product, purchase_count
FROM (
	SELECT customer_id, product_name, COUNT(*) AS purchase_count,
	RANK() OVER (PARTITION BY customer_id
				ORDER BY COUNT(*) DESC) AS rank
	FROM sales
	INNER JOIN menu USING(product_id)
	GROUP BY customer_id, product_name
	) AS subquery
WHERE rank = 1
ORDER BY customer_id;

-- Which item was purchased first by the customer after they became a member?
SELECT subquery.customer_id, m.product_name AS first_purchase_as_member
FROM (
	SELECT s.customer_id, s.product_id, s.order_date,
		 ROW_NUMBER() OVER (PARTITION BY s.customer_id 
	     ORDER BY s.order_date) AS rn
	FROM sales AS s
	INNER JOIN members AS mem 
	ON s.customer_id = mem.customer_id AND s.order_date >= mem.join_date
	) AS subquery
JOIN menu AS m ON subquery.product_id = m.product_id
WHERE subquery.rn = 1;

-- Which item was purchased just before the customer became a member?
SELECT subquery.customer_id, m.product_name AS last_purchase_before_join
FROM (
  SELECT s.customer_id, s.product_id, s.order_date,
        RANK() OVER (PARTITION BY s.customer_id 
		ORDER BY s.order_date DESC) AS rnk
  FROM sales AS s
  INNER JOIN members AS mem 
  ON s.customer_id = mem.customer_id AND s.order_date < mem.join_date
) AS subquery
JOIN menu AS m ON subquery.product_id = m.product_id
WHERE subquery.rnk = 1;


-- what is the total items and amount spent for each member before they became a member?
SELECT m.customer_id, COUNT(*) AS total_items, SUM(menu.price) AS total_amount
FROM sales AS s
JOIN menu ON s.product_id = menu.product_id
JOIN (
  SELECT customer_id, join_date
  FROM members
) AS m ON s.customer_id = m.customer_id AND s.order_date < m.join_date
GROUP BY m.customer_id;

--if each $1 spent equates to 10 points and sushi has a 2x points multiplier -
-- how many points would each customer have?
SELECT customer_id, SUM(tp.points) as total_points
FROM sales 
JOIN menu
USING (product_id)
JOIN (
	SELECT product_id, 
	CASE WHEN product_id = '1' THEN price * 20
	ELSE price * 10  END AS points
	FROM menu
	)AS tp
USING (product_id)
GROUP BY customer_id
ORDER BY total_points DESC;

--In the first week after a customer joins the program (including their join date) they earn 2x points on all item 
--not just sushi - how many points do customers A and B have at the end of January?
SELECT customer_id, SUM(
CASE 
	WHEN order_date BETWEEN join_date AND join_date + INTERVAL '6 days' THEN price * 20
	WHEN product_name = 'sushi' THEN price * 20
	ELSE price * 10 END) AS points
FROM sales as s
JOIN menu as m 
USING (product_id)
JOIN members as mem
USING (customer_id)
WHERE EXTRACT (MONTH from order_date) = '1'
GROUP BY customer_id











