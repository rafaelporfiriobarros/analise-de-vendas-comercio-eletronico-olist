select * from order_reviews_dataset limit 10;
select * from order_payments_dataset limit 10;
select * from sellers_dataset limit 10; 
select * from order_items_dataset limit 10;
select * from orders_dataset limit 10;
select * from products_dataset limit 10;
select * from customers_dataset limit 10;
select * from geolocation_dataset limit 10;


-- 1. Liste os 10 pedidos mais recentes.

select * from orders_dataset
order by order_purchase_timestamp desc
limit 10;

-- 2.Quantos pedidos existem na base?

select count(*) from orders_dataset;

-- 3. Quantos pedidos foram entregues?

select * from orders_dataset limit 10;

select count(*) from orders_dataset
where order_status = 'delivered';  

-- 4. Quantos clientes únicos existem?

select count(distinct customer_unique_id)
from customers_dataset;

-- 5. Quantos sellers existem?

SELECT COUNT(*) FROM orders_dataset;

-- 6. Quantos produtos existem?

select count(*) from products_dataset;

-- 7. Liste todas as categorias de produtos distintas.

select distinct product_category_name
from products_dataset;

-- 8. Quantos pedidos foram cancelados?

select count(*) from orders_dataset
where order_status = 'canceled';

-- 9. Qual o valor médio de frete (freight_value)?

select avg(freight_value) from order_items_dataset;

-- 10. Liste os 10 pedidos com o maior valor de frete.

select order_id, freight_value
from order_items_dataset
order by freight_value desc
limit 10;

-- Quantos vendedores existem?

SELECT COUNT(*) AS total_vendedores
FROM sellers_dataset;

-- Quais são todas as categorias dos produtos?
SELECT DISTINCT product_category_name
FROM products_dataset
ORDER BY product_category_name

-- Quantos produtos existem por categoria?

SELECT product_category_name, COUNT(*) AS total_produtos
FROM products_dataset
GROUP BY product_category_name
ORDER BY total_produtos DESC;


-- Quantos clientes únicos existem no dataset ?

SELECT COUNT(DISTINCT customer_unique_id) AS total_clientes_unicos
FROM customers_dataset;

-- Qual o número total de pedidos ?

SELECT COUNT(*) AS total_pedidos
FROM orders_dataset;

-- Há quantos pedidos por estado do cliente?

SELECT c.customer_state, COUNT(*) AS total_pedidos
FROM orders_dataset AS o
JOIN customers_dataset AS c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_pedidos DESC;

-- Quais as top 10 cidades com mais clientes ?

SELECT customer_city, COUNT(*) AS total_clientes
FROM customers_dataset
GROUP BY customer_city
ORDER BY total_clientes DESC
LIMIT 10;


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




	





