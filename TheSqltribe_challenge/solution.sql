/*
Using the tables below, write an SQL query to 
display the group sales by different age groups of customers. 
Below 30, Between 30 to 39, and 40 and above.
I created the tables, you will find the code in the tables file
*/
SELECT 
	CASE WHEN age < 30 THEN 'Below 30'
	WHEN age BETWEEN 30 AND 39 THEN '30 - 39'
    ELSE '40 and above' 
    END AS ageGroup, SUM(sale_amount) AS total_sales
FROM customers 
JOIN sales
USING(customer_id)
GROUP BY 1
ORDER BY total_sales DESC;
