-- Display the number of users based on payment method
SELECT 
    payment_type, 
    COUNT(*) AS total_users -- Count the total number of users for each payment method
FROM order_payments_dataset
GROUP BY payment_type -- Group by payment method
ORDER BY total_users DESC; -- Order by the number of users in descending order

-- Display the total usage of payment methods per year
SELECT
    payment_type, 
    SUM(CASE WHEN year = 2016 THEN total ELSE 0 END) AS "2016", -- Total payment usage in 2016
    SUM(CASE WHEN year = 2017 THEN total ELSE 0 END) AS "2017", -- Total payment usage in 2017
    SUM(CASE WHEN year = 2018 THEN total ELSE 0 END) AS "2018", -- Total payment usage in 2018
    SUM(total) AS sum_payment_type_usage -- Total usage of all payment methods
FROM (
    -- Subquery to calculate the total usage of each payment method by year
    SELECT
        YEAR(od.order_purchase_timestamp) AS year, -- Determine the purchase year
        opd.payment_type, -- Payment method type
        COUNT(opd.payment_type) AS total -- Count the usage of each payment method
    FROM orders_dataset AS od
    JOIN order_payments_dataset AS opd
        ON od.order_id = opd.order_id -- Join orders and payments by order_id
    GROUP BY year, opd.payment_type -- Group by year and payment method
) AS sub
GROUP BY payment_type -- Group the final results by payment method
ORDER BY sum_payment_type_usage DESC; -- Order by the total payment usage in descending order
