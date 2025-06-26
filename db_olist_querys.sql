-- Remove todas as tabelas se existirem (em ordem reversa de dependência)
DROP TABLE IF EXISTS order_reviews_dataset CASCADE;
DROP TABLE IF EXISTS order_payments_dataset CASCADE;
DROP TABLE IF EXISTS order_items_dataset CASCADE;
DROP TABLE IF EXISTS orders_dataset CASCADE;
DROP TABLE IF EXISTS sellers_dataset CASCADE;
DROP TABLE IF EXISTS products_dataset CASCADE;
DROP TABLE IF EXISTS customers_dataset CASCADE;
DROP TABLE IF EXISTS geolocation_dataset CASCADE;

-- Tabela geolocation_dataset (Geolocalização)
CREATE TABLE geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(10) PRIMARY KEY,
    geolocation_lat DECIMAL(10, 8),
    geolocation_lng DECIMAL(11, 8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(2)
);

-- Tabela customers_dataset (Clientes)
CREATE TABLE customers_dataset (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(2),
    FOREIGN KEY (customer_zip_code_prefix) REFERENCES geolocation_dataset(geolocation_zip_code_prefix)
);

-- Tabela products_dataset (Produtos)
CREATE TABLE products_dataset (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);

-- Tabela sellers_dataset (Vendedores)
CREATE TABLE sellers_dataset (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(10),
    seller_city VARCHAR(100),
    seller_state VARCHAR(2),
    FOREIGN KEY (seller_zip_code_prefix) REFERENCES geolocation_dataset(geolocation_zip_code_prefix)
);

-- Tabela orders_dataset (Pedidos)
CREATE TABLE orders_dataset (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers_dataset(customer_id)
);

-- Tabela order_items_dataset (Itens dos Pedidos)
CREATE TABLE order_items_dataset (
    order_id VARCHAR(50),
    order_item_id INTEGER,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date TIMESTAMP,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2),
    PRIMARY KEY (order_id, order_item_id),
    FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id),
    FOREIGN KEY (product_id) REFERENCES products_dataset(product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers_dataset(seller_id)
);

-- Tabela order_payments_dataset (Pagamentos)
CREATE TABLE order_payments_dataset (
    order_id VARCHAR(50),
    payment_sequential INTEGER,
    payment_type VARCHAR(20),
    payment_installments INTEGER,
    payment_value DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id)
);

-- Tabela order_reviews_dataset (Avaliações)
CREATE TABLE order_reviews_dataset (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INTEGER,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders_dataset(order_id)
);

select * from order_reviews_dataset limit 10;
select * from order_payments_dataset limit 10;
select * from sellers_dataset limit 10; 
select * from order_items_dataset limit 10;
select * from orders_dataset limit 10;
select * from products_dataset limit 10;
select * from customers_dataset limit 10;
select * from geolocation_dataset limit 10;


-- Quantos clientes únicos existem no dataset ?

SELECT COUNT(DISTINCT customer_unique_id) AS total_clientes_unicos
FROM customers_dataset;

-- Qual o número total de pedidos ?

SELECT COUNT(*) AS total_pedidos
FROM orders_dataset;

-- Quais são os status de pedidos possíveis e quantos existem de cada?

SELECT order_status, COUNT(*) AS quantidade
FROM orders_dataset
GROUP BY order_status
ORDER BY quantidade DESC;



















