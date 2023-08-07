-- Replace blank values and 'null' values in the exclusions and extras columns
-- with actual NULL values
UPDATE customer_orders
SET exclusions = NULL
WHERE exclusions IN ('null', '');

UPDATE customer_orders
SET extras = NULL
WHERE extras IN ('null', '');
-- update runner_orders table
-- replace 'null' with NULL
UPDATE runner_orders
SET cancellation = NULL
WHERE cancellation IN ('null', '');

-- remove non numeric characters from duration
UPDATE runner_orders
SET duration = REGEXP_REPLACE(duration, '[^0-9]', '')
WHERE duration <> 'null';
-- replace 'null' with NULL
UPDATE runner_orders
SET duration = NULL
WHERE duration = '';
-- remove non numeric characters from distance
UPDATE runner_orders
SET distance = REPLACE(distance, 'km', '')
WHERE distance LIKE '%km%';

-- replace 'null' with NULL
UPDATE runner_orders
SET distance = NULL
WHERE distance = 'null';
-- replace 'null' with NULL in pickup_time
UPDATE runner_orders
SET pickup_time = NULL
WHERE pickup_time = 'null';
