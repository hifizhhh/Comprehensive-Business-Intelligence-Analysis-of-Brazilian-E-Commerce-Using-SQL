-- 1) Create the ecommerce database
CREATE DATABASE IF NOT EXISTS ecommerce;

-- Use the ecommerce database
USE ecommerce;

-- 2) Create table to store customer data
CREATE TABLE customers_dataset (
    customer_id VARCHAR(50), -- Customer ID
    customer_unique_id VARCHAR(50), -- Unique customer ID
    customer_zip_code_prefix VARCHAR(20), -- Customer's zip code prefix
    customer_city VARCHAR(50), -- Customer's city
    customer_state VARCHAR(10) -- Customer's state
);

-- 3) Create table to store geolocation data
CREATE TABLE geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(50), -- Zip code for geolocation
    geolocation_lat DECIMAL(9,6), -- Geolocation latitude
    geolocation_lng DECIMAL(9,6), -- Geolocation longitude
    geolocation_city VARCHAR(50), -- City of the geolocation
    geolocation_state VARCHAR(10) -- State of the geolocation
);

-- 4) Create table to store order item data
CREATE TABLE order_items_dataset (
    order_id VARCHAR(50), -- Order ID
    order_item_id INT, -- Order item ID
    product_id VARCHAR(50), -- Product ID
    seller_id VARCHAR(50), -- Seller ID
    shipping_limit_date TIMESTAMP, -- Shipping limit date
    price DECIMAL(10,2), -- Price of the product
    freight_value DECIMAL(10,2) -- Freight cost
);

-- 5) Create table to store order payment data
CREATE TABLE order_payments_dataset (
    order_id VARCHAR(50), -- Order ID
    payment_sequential INT, -- Payment sequential number
    payment_type VARCHAR(20), -- Type of payment
    payment_installments INT, -- Number of payment installments
    payment_value DECIMAL(10,2) -- Total payment value
);

-- 6) Create table to store order review data
CREATE TABLE order_reviews_dataset (
    review_id VARCHAR(100), -- Review ID
    order_id VARCHAR(50), -- Order ID
    review_score INT, -- Review score
    review_comment_title VARCHAR(50), -- Review comment title
    review_comment_message VARCHAR(1000), -- Review comment message
    review_creation_date TIMESTAMP, -- Review creation date
    review_answer_timestamp TIMESTAMP -- Review answer timestamp
);

-- 7) Create table to store order data
CREATE TABLE orders_dataset (
    order_id VARCHAR(50), -- Order ID
    customer_id VARCHAR(50), -- Customer ID
    order_status VARCHAR(20), -- Order status
    order_purchase_timestamp TIMESTAMP, -- Order purchase timestamp
    order_approved_at TIMESTAMP, -- Order approval timestamp
    order_delivered_carrier_date TIMESTAMP, -- Delivery date by carrier
    order_delivered_customer_date TIMESTAMP, -- Customer received date
    order_estimated_delivery_date TIMESTAMP -- Estimated delivery date
);

-- 8) Create table to store product data
CREATE TABLE products_dataset (
    product_id VARCHAR(50), -- Product ID
    product_category_name VARCHAR(50), -- Product category name
    product_name_length INT, -- Product name length
    product_description_length INT, -- Product description length
    product_photos_qty INT, -- Number of product photos
    product_weight_g DECIMAL(10,2), -- Product weight (grams)
    product_length_cm DECIMAL(10,2), -- Product length (cm)
    product_height_cm DECIMAL(10,2), -- Product height (cm)
    product_width_cm DECIMAL(10,2) -- Product width (cm)
);

-- 9) Create table to store seller data
CREATE TABLE sellers_dataset (
    seller_id VARCHAR(50), -- Seller ID
    seller_zip_code_prefix VARCHAR(20), -- Seller's zip code prefix
    seller_city VARCHAR(50), -- Seller's city
    seller_state VARCHAR(10) -- Seller's state
);

-- 10) Import customer data 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce/olist_customers_dataset.csv'
INTO TABLE customers_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state    
);

-- 11) Import geolocation data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce/olist_geolocation_dataset.csv'
INTO TABLE geolocation_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @geolocation_zip_code_prefix,
    @geolocation_lat,
    @geolocation_lng,
    @geolocation_city,
    @geolocation_state
)
SET
    geolocation_zip_code_prefix = NULLIF(TRIM(@geolocation_zip_code_prefix), ''),
    geolocation_lat = NULLIF(TRIM(@geolocation_lat), ''),
    geolocation_lng = NULLIF(TRIM(@geolocation_lng), ''),
    geolocation_city = NULLIF(TRIM(@geolocation_city), ''),
    geolocation_state = NULLIF(TRIM(@geolocation_state), '');

-- 12) Import order items data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce/olist_order_items_dataset.csv'
INTO TABLE order_items_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @order_id,
    @order_item_id,
    @product_id,
    @seller_id,
    @shipping_limit_date,
    @price,
    @freight_value
)
SET
    order_id = NULLIF(TRIM(@order_id), ''),
    order_item_id = NULLIF(TRIM(@order_item_id), ''),
    product_id = NULLIF(TRIM(@product_id), ''),
    seller_id = NULLIF(TRIM(@seller_id), ''),
    shipping_limit_date = NULLIF(TRIM(@shipping_limit_date), ''),
    price = NULLIF(TRIM(@price), ''),
    freight_value = NULLIF(TRIM(@freight_value), '');

-- 13) Import order payments data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce/olist_order_payments_dataset.csv'
INTO TABLE order_payments_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @order_id,
    @payment_sequential,
    @payment_type,
    @payment_installments,
    @payment_value
)
SET
    order_id = NULLIF(TRIM(@order_id), ''),
    payment_sequential = NULLIF(TRIM(@payment_sequential), ''),
    payment_type = NULLIF(TRIM(@payment_type), ''),
    payment_installments = NULLIF(TRIM(@payment_installments), ''),
    payment_value = NULLIF(TRIM(@payment_value), '');

-- 14) Import order reviews data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @review_id,
    @order_id,
    @review_score,
    @review_comment_title,
    @review_comment_message,
    @review_creation_date,
    @review_answer_timestamp
)
SET
    review_id = NULLIF(TRIM(@review_id), ''),
    order_id = NULLIF(TRIM(@order_id), ''),
    review_score = NULLIF(TRIM(@review_score), ''),
    review_comment_title = NULLIF(TRIM(@review_comment_title), ''),
    review_comment_message = NULLIF(TRIM(@review_comment_message), ''),
    review_creation_date = NULLIF(TRIM(@review_creation_date), ''),
    review_answer_timestamp = NULLIF(TRIM(@review_answer_timestamp), '');

-- 15) Import orders data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE orders_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    customer_id,
    order_status,
    @order_purchase_timestamp,
    @order_approved_at,
    @order_delivered_carrier_date,
    @order_delivered_customer_date,
    @order_estimated_delivery_date
)
SET
    order_purchase_timestamp = NULLIF(TRIM(@order_purchase_timestamp), ''),
    order_approved_at = NULLIF(TRIM(@order_approved_at), ''),
    order_delivered_carrier_date = NULLIF(TRIM(@order_delivered_carrier_date), ''),
    order_delivered_customer_date = NULLIF(TRIM(@order_delivered_customer_date), ''),
    order_estimated_delivery_date = NULLIF(TRIM(@order_estimated_delivery_date), '');

-- 16) Import product data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce/olist_products_dataset.csv'
INTO TABLE products_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @product_id,
    @product_category_name,
    @product_name_length,
    @product_description_length,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm
)
SET
    product_id = NULLIF(TRIM(@product_id), ''),
    product_category_name = NULLIF(TRIM(@product_category_name), ''),
    product_name_length = NULLIF(TRIM(@product_name_length), ''),
    product_description_length = NULLIF(TRIM(@product_description_length), ''),
    product_photos_qty = NULLIF(TRIM(@product_photos_qty), ''),
    product_weight_g = NULLIF(TRIM(@product_weight_g), ''),
    product_length_cm = NULLIF(TRIM(@product_length_cm), ''),
    product_height_cm = NULLIF(TRIM(@product_height_cm), ''),
    product_width_cm = NULLIF(TRIM(@product_width_cm), '');

-- 17) Import seller data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ecommerce/olist_sellers_dataset.csv'
INTO TABLE sellers_dataset
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @seller_id,
    @seller_zip_code_prefix,
    @seller_city,
    @seller_state
)
SET
    seller_id = NULLIF(TRIM(@seller_id), ''),
    seller_zip_code_prefix = NULLIF(TRIM(@seller_zip_code_prefix), ''),
    seller_city = NULLIF(TRIM(@seller_city), ''),
    seller_state = NULLIF(TRIM(@seller_state), '');

-- 18) Add Primary Key to each table
ALTER TABLE customers_dataset ADD CONSTRAINT customers_dataset_pkey PRIMARY KEY (customer_id);
ALTER TABLE sellers_dataset ADD CONSTRAINT sellers_dataset_pkey PRIMARY KEY (seller_id);
ALTER TABLE products_dataset ADD CONSTRAINT products_dataset_pkey PRIMARY KEY (product_id);
ALTER TABLE orders_dataset ADD CONSTRAINT orders_dataset_pkey PRIMARY KEY (order_id);
ALTER TABLE geolocation_dataset ADD CONSTRAINT geolocation_dataset_pkey PRIMARY KEY (geolocation_zip_code_prefix);

-- 19) Add Foreign Keys for relationships between tables
ALTER TABLE orders_dataset
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id) REFERENCES customers_dataset (customer_id);

ALTER TABLE order_payments_dataset
ADD CONSTRAINT fk_payments_order
FOREIGN KEY (order_id) REFERENCES orders_dataset (order_id);

ALTER TABLE order_reviews_dataset
ADD CONSTRAINT fk_reviews_order
FOREIGN KEY (order_id) REFERENCES orders_dataset (order_id);

ALTER TABLE order_items_dataset
ADD CONSTRAINT fk_items_order
FOREIGN KEY (order_id) REFERENCES orders_dataset (order_id);

ALTER TABLE order_items_dataset
ADD CONSTRAINT fk_items_product
FOREIGN KEY (product_id) REFERENCES products_dataset (product_id);

ALTER TABLE order_items_dataset
ADD CONSTRAINT items_sellers
FOREIGN KEY (seller_id) REFERENCES sellers_dataset (seller_id);

ALTER TABLE customers_dataset
ADD CONSTRAINT customers_geolocation
FOREIGN KEY (customer_zip_code_prefix) REFERENCES geolocation_dataset (geolocation_zip_code_prefix);
