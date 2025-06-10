-- 1) Display the average number of monthly active users for each year
SELECT 
    year, 
    FLOOR(AVG(customer_total)) AS avg_mau -- Calculate the average number of monthly active users
FROM (
    SELECT 
        YEAR(od.order_purchase_timestamp) AS year, -- Determine the transaction year
        MONTH(od.order_purchase_timestamp) AS month, -- Determine the transaction month
        COUNT(DISTINCT cd.customer_unique_id) AS customer_total -- Count the unique customers per month
    FROM orders_dataset AS od
    JOIN customers_dataset AS cd
        ON cd.customer_id = od.customer_id -- Join the orders data with the customer data
    GROUP BY year, month -- Group by year and month
) AS sub
GROUP BY year -- Group the final results by year
ORDER BY year; -- Order by year

-- 2) Display the number of new customers for each year
SELECT 
    year, 
    COUNT(customer_unique_id) AS total_new_customer -- Count the number of new customers
FROM (
    SELECT
        MIN(YEAR(od.order_purchase_timestamp)) AS year, -- Determine the first year a customer made a purchase
        cd.customer_unique_id -- Unique customer ID
    FROM orders_dataset AS od
    JOIN customers_dataset AS cd
        ON cd.customer_id = od.customer_id -- Join the orders data with the customer data
    GROUP BY cd.customer_unique_id -- Group by customer ID
) AS sub
GROUP BY year -- Group the final results by year
ORDER BY year; -- Order by year

-- 3) Display the number of repeat order customers for each year
SELECT 
    year, 
    COUNT(customer_unique_id) AS total_customer_repeat -- Count the customers who made more than one purchase
FROM (
    SELECT
        YEAR(od.order_purchase_timestamp) AS year, -- Determine the transaction year
        cd.customer_unique_id, -- Unique customer ID
        COUNT(od.order_id) AS total_order -- Count the total orders made by each customer
    FROM orders_dataset AS od
    JOIN customers_dataset AS cd
        ON cd.customer_id = od.customer_id -- Join the orders data with the customer data
    GROUP BY year, cd.customer_unique_id -- Group by year and customer ID
    HAVING COUNT(od.order_id) > 1 -- Only include customers who made more than one purchase
) AS sub
GROUP BY year -- Group the final results by year
ORDER BY year; -- Order by year

-- 4) Display the average number of orders made by customers for each year
SELECT 
    year, 
    ROUND(AVG(freq), 3) AS avg_frequency -- Calculate the average number of orders per customer
FROM (
    SELECT
        YEAR(od.order_purchase_timestamp) AS year, -- Determine the transaction year
        cd.customer_unique_id, -- Unique customer ID
        COUNT(od.order_id) AS freq -- Count the number of orders per customer
    FROM orders_dataset AS od
    JOIN customers_dataset AS cd
        ON cd.customer_id = od.customer_id -- Join the orders data with the customer data
    GROUP BY year, cd.customer_unique_id -- Group by year and customer ID
) AS sub
GROUP BY year -- Group the final results by year
ORDER BY year; -- Order by year

-- 5) Combine all the metrics above into one table view
WITH cte_mau AS (
    SELECT 
        year, 
        FLOOR(AVG(customer_total)) AS avg_mau -- Calculate the average number of monthly active users
    FROM (
        SELECT 
            YEAR(od.order_purchase_timestamp) AS year, -- Determine the transaction year
            MONTH(od.order_purchase_timestamp) AS month, -- Determine the transaction month
            COUNT(DISTINCT cd.customer_unique_id) AS customer_total -- Count the unique customers per month
        FROM orders_dataset AS od
        JOIN customers_dataset AS cd
            ON cd.customer_id = od.customer_id -- Join the orders data with the customer data
        GROUP BY year, month -- Group by year and month
    ) AS sub
    GROUP BY year -- Group the final results by year
),
cte_new_cust AS (
    SELECT 
        year, 
        COUNT(customer_unique_id) AS total_new_customer -- Count the number of new customers
    FROM (
        SELECT
            MIN(YEAR(od.order_purchase_timestamp)) AS year, -- Determine the first year a customer made a purchase
            cd.customer_unique_id -- Unique customer ID
        FROM orders_dataset AS od
        JOIN customers_dataset AS cd
            ON cd.customer_id = od.customer_id -- Join the orders data with the customer data
        GROUP BY cd.customer_unique_id -- Group by customer ID
    ) AS sub
    GROUP BY year -- Group the final results by year
),
cte_repeat_order AS (
    SELECT 
        year, 
        COUNT(customer_unique_id) AS total_customer_repeat -- Count the customers who made more than one purchase
    FROM (
        SELECT
            YEAR(od.order_purchase_timestamp) AS year, -- Determine the transaction year
            cd.customer_unique_id, -- Unique customer ID
            COUNT(od.order_id) AS total_order -- Count the total orders made by each customer
        FROM orders_dataset AS od
        JOIN customers_dataset AS cd
            ON cd.customer_id = od.customer_id -- Join the orders data with the customer data
        GROUP BY year, cd.customer_unique_id -- Group by year and customer ID
        HAVING COUNT(od.order_id) > 1 -- Only include customers who made more than one purchase
    ) AS sub
    GROUP BY year -- Group the final results by year
),
cte_frequency AS (
    SELECT 
        year, 
        ROUND(AVG(freq), 3) AS avg_frequency -- Calculate the average number of orders per customer
    FROM (
        SELECT
            YEAR(od.order_purchase_timestamp) AS year, -- Determine the transaction year
            cd.customer_unique_id, -- Unique customer ID
            COUNT(od.order_id) AS freq -- Count the number of orders per customer
        FROM orders_dataset AS od
        JOIN customers_dataset AS cd
            ON cd.customer_id = od.customer_id -- Join the orders data with the customer data
        GROUP BY year, cd.customer_unique_id -- Group by year and customer ID
    ) AS sub
    GROUP BY year -- Group the final results by year
)

-- Display the combined results from all the metrics
SELECT
    mau.year AS year, -- Display the year
    avg_mau, -- Average number of monthly active users
    total_new_customer, -- Total number of new customers
    total_customer_repeat, -- Total number of repeat order customers
    avg_frequency -- Average number of orders per customer
FROM 
    cte_mau AS mau
JOIN cte_new_cust AS nc ON mau.year = nc.year -- Join MAU data with new customers by year
JOIN cte_repeat_order AS ro ON nc.year = ro.year -- Join with repeat order customers
JOIN cte_frequency AS f ON ro.year = f.year -- Join with the average frequency of orders
GROUP BY 1, 2, 3, 4, 5 -- Group the results by year and metrics
ORDER BY 1; -- Order by year
