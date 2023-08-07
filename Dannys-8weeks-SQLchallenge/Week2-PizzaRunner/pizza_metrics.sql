-- How many pizzas were ordered?
SELECT COUNT(*) AS num_pizzas_ordered
FROM customer_orders;
-- How many unique customer orders were made?
SELECT COUNT(*) AS total_unique_orders
FROM (
    SELECT DISTINCT customer_id, pizza_id, exclusions, extras
    FROM customer_orders
) AS unique_pizza_orders;
-- How many successful orders were delivered by each runner?
-- Successful deliveries mean no cancellation.
SELECT runner_id, COUNT(*) AS orders_by_runner
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;
-- How many of each type of pizza was delivered?
-- JOIN all tables and get order_id where the order was not cancelled
SELECT p.pizza_name, COUNT(*) AS total_pizzas_delivered
FROM customer_orders AS c
LEFT JOIN pizza_names AS p
USING(pizza_id)
LEFT JOIN runner_orders AS r
USING(order_id)
WHERE r.cancellation IS NULL
GROUP BY p.pizza_name;
-- How many Vegetarian and Meatlovers were ordered by each customer?
-- JOIN all tables and get order_id where the order was not cancelled
SELECT c.customer_id, p.pizza_name, COUNT(*) AS total_pizzas_ordered
FROM customer_orders AS c
LEFT JOIN pizza_names AS p
USING(pizza_id)
LEFT JOIN runner_orders AS r
USING(order_id)
WHERE r.cancellation IS NULL
GROUP BY c.customer_id, p.pizza_name;
-- What was the maximum number of pizzas delivered in a single order?
-- JOIN all tables and get order_id where the order was not cancelled
WITH orders AS
(SELECT r.order_id, COUNT(*) AS total_pizzas_delivered
FROM customer_orders AS c
LEFT JOIN pizza_names AS p
USING(pizza_id)
LEFT JOIN runner_orders AS r
USING(order_id)
WHERE r.cancellation IS NULL
GROUP BY r.order_id)
SELECT MAX(total_pizzas_delivered)
FROM orders;
-- For each customer, how many delivered pizzas had at least 1 change
-- JOIN all tables and get order_id where the order was not cancelled
SELECT c.customer_id, COUNT(*) AS total_pizzas_delivered
FROM customer_orders AS c
LEFT JOIN pizza_names AS p
USING(pizza_id)
LEFT JOIN runner_orders AS r
USING(order_id)
WHERE r.cancellation IS NULL
AND (exclusions IS NOT NULL
OR extras IS NOT NULL)
GROUP BY c.customer_id;
-- For each customer, how many delivered pizzas had had no changes?
-- JOIN all tables and get order_id where the order was not cancelled
SELECT c.customer_id, COUNT(*) AS total_pizzas_delivered
FROM customer_orders AS c
LEFT JOIN pizza_names AS p
USING(pizza_id)
LEFT JOIN runner_orders AS r
USING(order_id)
WHERE r.cancellation IS NULL
AND (exclusions IS NULL
AND extras IS NULL)
GROUP BY c.customer_id;
-- How many pizzas were delivered that had both exclusions and extras?
-- JOIN all tables and get order_id where the order was not cancelled
SELECT COUNT(*) AS total_pizzas_delivered
FROM customer_orders AS c
LEFT JOIN pizza_names AS p
USING(pizza_id)
LEFT JOIN runner_orders AS r
USING(order_id)
WHERE r.cancellation IS NULL
AND (exclusions IS NOT NULL
AND extras IS NOT NULL)
GROUP BY c.customer_id;
-- What was the total volume of pizzas ordered for each hour of the day?
-- JOIN customer_orders with runner_orders and get order_id where the order was not cancelled
-- extract hour from order time
SELECT EXTRACT(HOUR FROM order_time) AS hour_of_day, COUNT(*) AS total_pizzas_ordered
FROM customer_orders 
LEFT JOIN runner_orders
USING(order_id)
WHERE cancellation IS NULL
GROUP BY hour_of_day
ORDER BY total_pizzas_ordered DESC;
-- What was the volume of orders for each day of the week?
-- JOIN customer_orders with runner_orders and get order_id where the order was not cancelled
-- extract Day of the week from order time
SELECT  DAYOFWEEK(order_time) AS DOW, COUNT(*) AS total_pizzas_ordered
FROM customer_orders 
LEFT JOIN runner_orders
USING(order_id)
WHERE cancellation IS NULL
GROUP BY DOW
ORDER BY total_pizzas_ordered DESC;
