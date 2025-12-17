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

-- Quais são os 10 produtos mais vendidos em quantidade ?

SELECT oi.product_id,
       COUNT(*) AS total_vendas,
	   p.product_category_name
FROM order_items_dataset AS oi
JOIN products_dataset AS p ON oi.product_id = p.product_id
GROUP BY oi.product_id, p.product_category_name
ORDER BY total_vendas DESC
LIMIT 10;

-- Quais são os status de pedidos possíveis e quantos existem em cada um?

SELECT order_status, COUNT(*) AS quantidade
FROM orders_dataset
GROUP BY order_status
ORDER BY quantidade DESC;

-- Quais os 10 produtos mais vendidos com nome da categoria, número de vendas e receita total gerada ?

SELECT p.product_category_name AS categoria,
       COUNT(oi.order_id) AS total_vendas,
	   SUM(oi.price) AS receita_total
FROM order_items_dataset AS oi
JOIN products_dataset AS p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_vendas DESC
LIMIT 10;

-- Quais são os vendedores com maior faturamento?

SELECT 
    s.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price) AS total_revenue,
    AVG(oi.price) AS avg_order_value
FROM order_items_dataset AS oi
JOIN sellers_dataset AS s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Qual é a receita total por categoria de produto?

SELECT p.product_category_name, 
	   SUM(oi.price) AS receita_total
FROM order_items_dataset AS oi
JOIN products_dataset AS p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY receita_total DESC;

-- Qual foi o ticket médio (preço médio por pedido)?

SELECT AVG(total) AS ticket_medio
FROM(SELECT order_id, SUM(price) AS total FROM order_items_dataset GROUP BY order_id)sub;


-- Qual o tempo médio de entrega dos pedidos (dias)?
SELECT 
    AVG(DATE_PART('day', 
        CAST(order_delivered_customer_date AS timestamp) - 
        CAST(order_purchase_timestamp AS timestamp)
    )) AS tempo_medio_entrega
FROM 
	orders_dataset
WHERE 
    order_delivered_customer_date IS NOT NULL;







