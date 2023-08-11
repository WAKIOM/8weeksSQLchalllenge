-- What are the standard ingredients for each pizza
SELECT pn.pizza_name,
       GROUP_CONCAT(pt.topping_name SEPARATOR ', ') AS standard_ingredients
  FROM pizza_recipes AS pr
       JOIN pizza_toppings pt ON FIND_IN_SET(pt.topping_id, REPLACE(pr.toppings, ' ', '')) > 0
       JOIN pizza_names AS pn USING(pizza_id)
GROUP BY pn.pizza_name;
/* 
Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers */
WITH cte1 AS
(SELECT co.order_id,
    pn.pizza_name,
    CONCAT('Exclude ', GROUP_CONCAT(DISTINCT pt_exc.topping_name ORDER BY pt_exc.topping_id SEPARATOR ', ')) 
 AS Exclusions,
    CONCAT('Extra ', GROUP_CONCAT(DISTINCT pt_extras.topping_name ORDER BY pt_extras.topping_id SEPARATOR ', '))
 AS Extras
FROM customer_orders co
LEFT JOIN pizza_names pn ON co.pizza_id = pn.pizza_id
LEFT JOIN pizza_toppings pt_exc ON FIND_IN_SET(pt_exc.topping_id, REPLACE(co.exclusions, ' ', '')) > 0
LEFT JOIN pizza_toppings pt_extras ON FIND_IN_SET(pt_extras.topping_id, REPLACE(co.extras, ' ', '')) > 0
GROUP BY co.order_id, pn.pizza_name, co.exclusions, co.extras)

SELECT order_id, CONCAT_WS(' - ', pizza_name, Exclusions, Extras) AS order_details
FROM cte1;
