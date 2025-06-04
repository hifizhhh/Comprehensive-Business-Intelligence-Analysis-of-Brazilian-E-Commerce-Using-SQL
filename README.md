# 💰 **Comprehensive Business Intelligence Analysis of Brazilian E-Commerce Using SQL**

![PostgreSQL](https://img.shields.io/badge/database-PostgreSQL-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/project-complete-brightgreen)

---

## Table of Contents

1. [Project Overview](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#-project-overview)
2. [Data Preparation](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#-data-preparation)

   - [Database Construction & ERD](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#database-construction--erd)

3. [Data Analysis](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#-data-analysis)

   - [Customer Activity Growth](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#customer-activity-growth)
   - [Product Category Performance](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#product-category-performance)
   - [Payment Method Trends](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#payment-method-trends)

4. [Conclusion](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#-conclusion)
5. [Tools & Environment](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#-tools--environment)
6. [Business Implications](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#-business-implications)
7. [Reproducibility Guide](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#-reproducibility-guide)
8. [Quick Access](https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL?tab=readme-ov-file#-quick-access)

---

## 📂 **Project Overview**

### Background

Evaluating business performance is crucial for every organization, as it provides insights into the effectiveness of business strategies and operational processes. This analysis project focuses on assessing the performance of an e-commerce company based on key metrics including customer growth, product category performance, and payment trends using historical data spanning three years.

### Project Goals

This project aims to derive actionable insights through analytical and visual interpretations of the following:

1. **Customer Activity Growth per Year**
2. **Product Category Quality per Year**
3. **Payment Type Usage per Year**

---

## 📂 **Data Preparation**

The dataset originates from a Brazilian e-commerce platform, encompassing 99,441 orders between 2016 and 2018. It includes attributes such as order status, customer and seller location, item details, payment types, and customer reviews.

### Database Construction & ERD

The following steps were carried out:

1. Creating a new PostgreSQL workspace and defining table schemas using `CREATE TABLE`.
2. Importing CSV files into the respective tables.
3. Setting primary and foreign key constraints to establish table relationships.
4. Generating the Entity Relationship Diagram (ERD) using pgAdmin's ERD tool.

<details>
  <summary>Click to view SQL Queries</summary>

```sql
-- 1) Membuat database melalui klik kanan Databases > Create > Database.. dengan nama ecommerce_miniproject

-- 2) Membuat tabel menggunakan statement CREATE TABLE dengan mengikuti penamaan kolom di csv dan memastikan tipe datanya sesuai.
CREATE TABLE customers_dataset (
	customer_id varchar,
	customer_unique_id varchar,
	customer_zip_code_prefix varchar,
	customer_city varchar,
	customer_state varchar
);
CREATE TABLE sellers_dataset (
	seller_id varchar,
	seller_zip_code_prefix varchar,
	seller_city varchar,
	seller_state varchar
);
CREATE TABLE geolocation_dataset (
	geolocation_zip_code_prefix varchar,
	geolocation_lat decimal,
	geolocation_lng decimal,
	geolocation_city varchar,
	geolocation_state varchar
);
CREATE TABLE product_dataset (
	product_id varchar,
	product_category_name varchar,
	product_name_lenght int,
	product_description_lenght int,
	product_photos_qty int,
	product_weight_g decimal,
	product_length_cm decimal,
	product_height_cm decimal,
	product_width_cm decimal
);
CREATE TABLE orders_dataset (
	order_id varchar,
	customer_id varchar,
	order_status varchar,
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp
);
CREATE TABLE order_items_dataset (
	order_id varchar,
	order_item_id int,
	product_id varchar,
	seller_id varchar,
	shipping_limit_date timestamp,
	price decimal,
	fright_value decimal
);
CREATE TABLE order_payments_dataset (
	order_id varchar,
	payment_sequential int,
	payment_type varchar,
	payment_installments int,
	payment_value decimal
);
CREATE TABLE order_reviews_dataset (
	review_id varchar,
	order_id varchar,
	review_score int,
	review_comment_title varchar,
	review_comment_message varchar,
	review_creation_date timestamp,
	review_answer_timestamp timestamp
);

-- 3) Mengimpor file csv ke dalam masing-masing tabel yang telah dibuat dengan klik kanan pada nama tabel > Import/Export Data..

-- 4) Menentukan Primary Key dan Foreign Key untuk membuat relasi antar tabelnya,
--    Sebelumnya, memastikan Primary Key memiliki nilai unik dan tipe data sesuai antara Primary Key dan Foreign Key pada dataset.
-- PRIMARY KEY
ALTER TABLE customers_dataset ADD CONSTRAINT customers_dataset_pkey ADD PRIMARY KEY(customer_id);
ALTER TABLE sellers_dataset ADD CONSTRAINT sellers_dataset_pkey ADD PRIMARY KEY(seller_id);
ALTER TABLE product_dataset ADD CONSTRAINT product_dataset_pkey ADD PRIMARY KEY(product_id);
ALTER TABLE orders_dataset ADD CONSTRAINT orders_dataset_pkey ADD PRIMARY KEY(order_id);

-- FOREIGN KEY
ALTER TABLE orders_dataset ADD FOREIGN KEY (customer_id) REFERENCES customers_dataset;
ALTER TABLE order_payments_dataset ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;
ALTER TABLE order_reviews_dataset ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;
ALTER TABLE order_items_dataset ADD FOREIGN KEY (order_id) REFERENCES orders_dataset;
ALTER TABLE order_items_dataset ADD FOREIGN KEY (product_id) REFERENCES product_dataset;
ALTER TABLE order_items_dataset ADD FOREIGN KEY (seller_id) REFERENCES sellers_dataset;

-- 5) Membuat ERD dengan cara klik kanan pada database ecommerce_miniproject > Gererate ERD..
```

</details>

![ERD](asset/gambar_1_ERD.png)

---

## 📂 **Data Analysis**

### Customer Activity Growth

<details>
  <summary>Click to view SQL Queries</summary>

```sql
--1 Menampilkan rata-rata jumlah customer aktif bulanan (monthly active user) untuk setiap tahun
SELECT year, FLOOR(AVG(customer_total)) AS avg_mau
FROM (
	SELECT
		date_part('year', od.order_purchase_timestamp) AS year,
		date_part('month', od.order_purchase_timestamp) AS month,
		COUNT(DISTINCT cd.customer_unique_id) AS customer_total
	FROM orders_dataset AS od
	JOIN customers_dataset AS cd
		ON cd.customer_id = od.customer_id
	GROUP BY 1, 2
	) AS sub
GROUP BY 1
ORDER BY 1
;

--2 Menampilkan jumlah customer baru pada masing-masing tahun
SELECT year, COUNT(customer_unique_id) AS total_new_customer
FROM (
	SELECT
		Min(date_part('year', od.order_purchase_timestamp)) AS year,
		cd.customer_unique_id
	FROM orders_dataset AS od
	JOIN customers_dataset AS cd
		ON cd.customer_id = od.customer_id
	GROUP BY 2
	) AS sub
GROUP BY 1
ORDER BY 1
;

--3 Menampilkan jumlah customer repeat order pada masing-masing tahun
SELECT year, count(customer_unique_id) AS total_customer_repeat
FROM (
	SELECT
		date_part('year', od.order_purchase_timestamp) AS year,
		cd.customer_unique_id,
		COUNT(od.order_id) AS total_order
	FROM orders_dataset AS od
	JOIN customers_dataset AS cd
		ON cd.customer_id = od.customer_id
	GROUP BY 1, 2
	HAVING count(2) > 1
	) AS sub
GROUP BY 1
ORDER BY 1
;

--4 Menampilkan rata-rata jumlah order yang dilakukan customer untuk masing-masing tahun
SELECT year, ROUND(AVG(freq), 3) AS avg_frequency
FROM (
	SELECT
		date_part('year', od.order_purchase_timestamp) AS year,
		cd.customer_unique_id,
		COUNT(order_id) AS freq
	FROM orders_dataset AS od
	JOIN customers_dataset AS cd
		ON cd.customer_id = od.customer_id
	GROUP BY 1, 2
	) AS sub
GROUP BY 1
ORDER BY 1
;

--5 Menggabungkan ketiga metrik yang telah berhasil ditampilkan menjadi satu tampilan tabel
WITH cte_mau AS (
	SELECT year, FLOOR(AVG(customer_total)) AS avg_mau
	FROM (
		SELECT
			date_part('year', od.order_purchase_timestamp) AS year,
			date_part('month', od.order_purchase_timestamp) AS month,
			COUNT(DISTINCT cd.customer_unique_id) AS customer_total
		FROM orders_dataset AS od
		JOIN customers_dataset AS cd
			ON cd.customer_id = od.customer_id
		GROUP BY 1, 2
		) AS sub
	GROUP BY 1
),

cte_new_cust AS (
	SELECT year, COUNT(customer_unique_id) AS total_new_customer
	FROM (
		SELECT
			Min(date_part('year', od.order_purchase_timestamp)) AS year,
			cd.customer_unique_id
		FROM orders_dataset AS od
		JOIN customers_dataset AS cd
			ON cd.customer_id = od.customer_id
		GROUP BY 2
		) AS sub
	GROUP BY 1
),

cte_repeat_order AS (
	SELECT year, count(customer_unique_id) AS total_customer_repeat
	FROM (
		SELECT
			date_part('year', od.order_purchase_timestamp) AS year,
			cd.customer_unique_id,
			COUNT(od.order_id) AS total_order
		FROM orders_dataset AS od
		JOIN customers_dataset AS cd
			ON cd.customer_id = od.customer_id
		GROUP BY 1, 2
		HAVING count(2) > 1
		) AS sub
	GROUP BY 1
),

cte_frequency AS (
	SELECT year, ROUND(AVG(freq), 3) AS avg_frequency
	FROM (
		SELECT
			date_part('year', od.order_purchase_timestamp) AS year,
			cd.customer_unique_id,
			COUNT(order_id) AS freq
		FROM orders_dataset AS od
		JOIN customers_dataset AS cd
			ON cd.customer_id = od.customer_id
		GROUP BY 1, 2
		) AS sub
	GROUP BY 1
)

SELECT
	mau.year AS year,
	avg_mau,
	total_new_customer,
	total_customer_repeat,
	avg_frequency
FROM
	cte_mau AS mau
	JOIN cte_new_cust AS nc
		ON mau.year = nc.year
	JOIN cte_repeat_order AS ro
		ON nc.year = ro.year
	JOIN cte_frequency AS f
		ON ro.year = f.year
GROUP BY 1, 2, 3, 4, 5
ORDER BY 1;
```

</details>

Key findings:

- Significant increase in MAU and new customers, especially between 2016 and 2017.
- Repeat orders peaked in 2017 and slightly declined in 2018.
- Most users only placed one order per year, indicating low customer retention.

![MAU & New Customers](asset/gambar_2_mau_x_newcust.png)
![Repeat Orders](asset/gambar_3_repeat%20order.png)
![Order Frequency](asset/gambar_4_freq_order.png)

---

### Product Category Performance

<details>
  <summary>Click to view SQL Queries</summary>

```sql
 --1) Membuat tabel yang berisi informasi pendapatan/revenue perusahaan total untuk masing-masing tahun
CREATE TABLE total_revenue AS
	SELECT
		date_part('year', od.order_purchase_timestamp) AS year,
		SUM(oid.price + oid.fright_value) AS revenue
	FROM order_items_dataset AS oid
	JOIN orders_dataset AS od
		ON oid.order_id = od.order_id
	WHERE od.order_status like 'delivered'
	GROUP BY 1
	ORDER BY 1;

--2) Membuat tabel yang berisi informasi jumlah cancel order total untuk masing-masing tahun
CREATE TABLE canceled_order AS
	SELECT
		date_part('year', order_purchase_timestamp) AS year,
		COUNT(order_status) AS canceled
	FROM orders_dataset
	WHERE order_status like 'canceled'
	GROUP BY 1
	ORDER BY 1;

--3) Membuat tabel yang berisi nama kategori produk yang memberikan pendapatan total tertinggi untuk masing-masing tahun
CREATE TABLE top_product_category AS
	SELECT
		year,
		top_category,
		product_revenue
	FROM (
		SELECT
			date_part('year', shipping_limit_date) AS year,
			pd.product_category_name AS top_category,
			SUM(oid.price + oid.fright_value) AS product_revenue,
			RANK() OVER (PARTITION BY date_part('year', shipping_limit_date)
					 ORDER BY SUM(oid.price + oid.fright_value) DESC) AS ranking
		FROM orders_dataset AS od
		JOIN order_items_dataset AS oid
			ON od.order_id = oid.order_id
		JOIN product_dataset AS pd
			ON oid.product_id = pd.product_id
		WHERE od.order_status like 'delivered'
		GROUP BY 1, 2
		ORDER BY 1
		) AS sub
	WHERE ranking = 1;

--4) Membuat tabel yang berisi nama kategori produk yang memiliki jumlah cancel order terbanyak untuk masing-masing tahun
CREATE TABLE most_canceled_category AS
	SELECT
		year,
		most_canceled,
		total_canceled
	FROM (
		SELECT
			date_part('year', shipping_limit_date) AS year,
			pd.product_category_name AS most_canceled,
			COUNT(od.order_id) AS total_canceled,
			RANK() OVER (PARTITION BY date_part('year', shipping_limit_date)
					 ORDER BY COUNT(od.order_id) DESC) AS ranking
		FROM orders_dataset AS od
		JOIN order_items_dataset AS oid
			ON od.order_id = oid.order_id
		JOIN product_dataset AS pd
			ON oid.product_id = pd.product_id
		WHERE od.order_status like 'canceled'
		GROUP BY 1, 2
		ORDER BY 1
		) AS sub
	WHERE ranking = 1;

-- Tambahan - Menghapus anomali data tahun
DELETE FROM top_product_category WHERE year = 2020;
DELETE FROM most_canceled_category WHERE year = 2020;

-- Menampilkan tabel yang dibutuhkan
SELECT
	tr.year,
	tr.revenue AS total_revenue,
	tpc.top_category AS top_product,
	tpc.product_revenue AS total_revenue_top_product,
	co.canceled total_canceled,
	mcc.most_canceled top_canceled_product,
	mcc.total_canceled total_top_canceled_product
FROM total_revenue AS tr
JOIN top_product_category AS tpc
	ON tr.year = tpc.year
JOIN canceled_order AS co
	ON tpc.year = co.year
JOIN most_canceled_category AS mcc
	ON co.year = mcc.year
GROUP BY 1, 2, 3, 4, 5, 6, 7;
```

</details>

Highlights:

- Revenue increased consistently over the years.
- Leading product categories changed each year.
- `Health_beauty` was the top revenue and most canceled category in 2018, reflecting both popularity and volatility.

![Revenue](asset/gambar_5_total_revenue.png)
![Top Product Revenue](asset/gambar_6_top.png)
![Cancellations](asset/gambar_7_cenceled.png)

---

### Payment Method Trends

<details>
  <summary>Click to view SQL Queries</summary>

```sql
-- 1) Menampilkan jumlah penggunaan masing-masing tipe pembayaran secara all time diurutkan dari yang terfavorit
SELECT payment_type, COUNT(1)
FROM order_payments_dataset
GROUP BY 1
ORDER BY 2 DESC;

-- 2)Menampilkan detail informasi jumlah penggunaan masing-masing tipe pembayaran untuk setiap tahun
SELECT
	payment_type,
	SUM(CASE WHEN year = 2016 THEN total ELSE 0 END) AS "2016",
	SUM(CASE WHEN year = 2017 THEN total ELSE 0 END) AS "2017",
	SUM(CASE WHEN year = 2018 THEN total ELSE 0 END) AS "2018",
	SUM(total) AS sum_payment_type_usage
FROM (
	SELECT
		date_part('year', od.order_purchase_timestamp) as year,
		opd.payment_type,
		COUNT(opd.payment_type) AS total
	FROM orders_dataset AS od
	JOIN order_payments_dataset AS opd
		ON od.order_id = opd.order_id
	GROUP BY 1, 2
	) AS sub
GROUP BY 1
ORDER BY 2 DESC;
```

</details>

Key takeaways:

- Credit cards dominated across all years.
- Debit card usage grew significantly in 2018, likely due to promotional strategies.
- Voucher usage spiked in 2017 and declined afterward.

![Payment Methods](asset/gambar_8_tipe_pembayaran.png)

---

## 📂 **Conclusion**

- **Customer Growth**: The number of active and new users increased annually, though most customers did not place repeat orders. Strategies such as loyalty programs and targeted promotions could help improve retention.
- **Product Category Performance**: While revenue rose, top-performing categories varied, emphasizing the need for trend analysis. The dual nature of `health_beauty` in 2018 suggests high demand but also delivery/expectation mismatches.
- **Payment Preferences**: Credit cards remain the most preferred payment method, with emerging growth in debit cards, suggesting that payment promotions may influence consumer behavior.

---

## 📂 **Tools & Environment**

- **PostgreSQL v14** via **pgAdmin 4**
- **Microsoft Excel 2019** for plotting and visualization
- **System**: Windows 10 64-bit, 8GB RAM

---

## 📂 **Business Implications**

- Leverage strong growth in new customer acquisition by improving onboarding and engagement campaigns.
- Closely monitor top-performing categories for fulfillment issues, especially high-return items like `health_beauty`.
- Expand promotional efforts toward underutilized payment channels like debit or digital wallets to diversify options and boost conversion.

---

## 🚀 **Reproducibility Guide**

1. Clone this repository: `git clone https://github.com/hifizhhh/Comprehensive-Business-Intelligence-Analysis-of-Brazilian-E-Commerce-Using-SQL`
2. Open pgAdmin and create a new database named `ecommerce_miniproject`
3. Use the provided `CREATE TABLE` SQL scripts to set up schema
4. Import each CSV file into its corresponding table
5. Run each SQL analysis query per stage (see query blocks above)
6. Visualize the exported tables in Excel to replicate the graphs

---

## 🔗 **Quick Access**

- 📁 [SQL Scripts Folder](./sql_query/)
- 📊 [Analysis Charts (Excel)](./asset/)
- 📸 [Entity Relationship Diagram](./asset/gambar_1_ERD.png)
