-- How many runners signed up for each 1 week? (i.e. week starts 2021-01-01)
-- passing 1 as an argument to specify week to start on monday
SELECT WEEK(registration_date, 1) AS reg_week, COUNT(*) AS num_runners_registered
FROM runners
GROUP BY reg_week;
-- What was the average time in minutes it took for each runner to
-- arrive at the Pizza Runner HQ to pickup the order?
SELECT AVG(MINUTE(timediff(pickup_time, order_time))) avg_order_to_pickup_time
FROM runner_orders
INNER JOIN  customer_orders
USING(order_id)
WHERE cancellation IS NULL;
-- Is there any relationship between the number of pizzas and how long the order takes to prepare?
SELECT order_id, count(*) as num_pizzas, AVG(MINUTE(timediff(pickup_time, order_time))) avg_order_prep_time
FROM runner_orders AS r
INNER JOIN  customer_orders AS c
USING(order_id)
WHERE cancellation IS NULL
GROUP BY order_id
ORDER BY num_pizzas DESC;
-- What was the average distance travelled for each customer?
SELECT AVG(distance) AS avg_distance_in_KMs
FROM runner_orders
WHERE cancellation IS NULL;
-- What was the difference between the longest and shortest delivery times for all orders?
SELECT MAX(duration) - MIN(duration)
FROM runner_orders;
-- What was the average speed for each runner for each delivery
-- and do you notice any trend for these values?;
SELECT order_id, runner_id, ROUND(AVG(distance/(duration / 60))) AS speed_kmh
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY order_id, runner_id
ORDER BY runner_id, speed_kmh DESC;

