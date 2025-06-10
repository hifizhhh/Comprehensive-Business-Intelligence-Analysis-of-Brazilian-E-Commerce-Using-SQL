-- 1) Create a table containing the total revenue information for each year
CREATE TABLE total_revenue AS
SELECT
    YEAR(od.order_purchase_timestamp) AS year, -- Determine the year of transaction
    SUM(oid.price + oid.freight_value) AS revenue -- Calculate total revenue based on price and freight value
FROM order_items_dataset AS oid
JOIN orders_dataset AS od
    ON oid.order_id = od.order_id -- Join the order and item data
WHERE od.order_status = 'delivered' -- Only count orders that have been delivered
GROUP BY year
ORDER BY year; -- Sort by year

-- 2) Create a table containing the total canceled orders for each year
CREATE TABLE canceled_order AS
SELECT
    YEAR(order_purchase_timestamp) AS year, -- Determine the year of order cancellation
    COUNT(order_status) AS canceled -- Count the number of canceled orders
FROM orders_dataset
WHERE order_status = 'canceled' -- Filter for only canceled orders
GROUP BY year
ORDER BY year; -- Sort by year

-- 3) Create a table containing the product category with the highest revenue for each year
CREATE TABLE top_product_category AS
SELECT
    year,
    top_category,
    product_revenue
FROM (
    SELECT
        YEAR(od.order_purchase_timestamp) AS year, -- Determine the year of transaction
        pd.product_category_name AS top_category, -- Get the product category name
        SUM(oid.price + oid.freight_value) AS product_revenue, -- Calculate total revenue based on product and freight value
        RANK() OVER (
            PARTITION BY YEAR(od.order_purchase_timestamp) 
            ORDER BY SUM(oid.price + oid.freight_value) DESC -- Rank categories based on highest revenue
        ) AS ranking
    FROM orders_dataset AS od
    JOIN order_items_dataset AS oid
        ON od.order_id = oid.order_id -- Join orders and items
    JOIN products_dataset AS pd
        ON oid.product_id = pd.product_id -- Join items with product data
    WHERE od.order_status = 'delivered' -- Filter for only delivered orders
    GROUP BY YEAR(od.order_purchase_timestamp), pd.product_category_name
) AS sub
WHERE ranking = 1 -- Select the top product category with the highest revenue
ORDER BY year; -- Sort by year

-- 4) Create a table containing the product category with the highest number of canceled orders for each year
CREATE TABLE most_canceled_category AS
SELECT 
    year,
    most_canceled,
    total_canceled
FROM (
    SELECT
        YEAR(od.order_purchase_timestamp) AS year, -- Determine the year of transaction
        pd.product_category_name AS most_canceled, -- Get the product category with the highest cancellations
        COUNT(od.order_id) AS total_canceled, -- Count the total cancellations
        RANK() OVER (
            PARTITION BY YEAR(od.order_purchase_timestamp)
            ORDER BY COUNT(od.order_id) DESC -- Rank categories based on the number of cancellations
        ) AS ranking
    FROM orders_dataset AS od
    JOIN order_items_dataset AS oid
        ON od.order_id = oid.order_id -- Join orders and items
    JOIN products_dataset AS pd
        ON oid.product_id = pd.product_id -- Join items with product data
    WHERE od.order_status = 'canceled' -- Filter for only canceled orders
    GROUP BY YEAR(od.order_purchase_timestamp), pd.product_category_name
) AS sub
WHERE ranking = 1 -- Select the product category with the most cancellations
ORDER BY year; -- Sort by year

-- 5) Display the table combining total revenue, top product, canceled orders, and the most canceled product category
SELECT 
    tr.year, -- Display the year
    tr.revenue AS total_revenue, -- Total revenue for the year
    tpc.top_category AS top_product, -- Name of the top product category
    tpc.product_revenue AS total_revenue_top_product, -- Revenue for the top product category
    co.canceled AS total_canceled, -- Total canceled orders for the year
    mcc.most_canceled AS top_canceled_product, -- Name of the product category with the most cancellations
    mcc.total_canceled AS total_top_canceled_product -- Total cancellations for the most canceled product category
FROM total_revenue AS tr
JOIN top_product_category AS tpc
    ON tr.year = tpc.year -- Join total revenue with top product category by year
JOIN canceled_order AS co
    ON tpc.year = co.year -- Join with canceled orders by year
JOIN most_canceled_category AS mcc
    ON co.year = mcc.year -- Join with the most canceled product category by year
ORDER BY tr.year; -- Sort by year
