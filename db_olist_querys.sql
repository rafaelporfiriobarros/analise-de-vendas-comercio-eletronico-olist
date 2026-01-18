select * from order_reviews_dataset limit 10;
select * from order_payments_dataset limit 10;
select * from sellers_dataset limit 10; 
select * from order_items_dataset limit 10;
select * from orders_dataset limit 10;
select * from products_dataset limit 10;
select * from customers_dataset limit 10;
select * from geolocation_dataset limit 10;


-- 1. Liste os 5 pedidos mais recentes.

select order_id, order_purchase_timestamp from orders_dataset
order by order_purchase_timestamp desc
limit 5;

-- 2.Quantos pedidos existem na base?

select count(*) as total_de_pedidos from orders_dataset;

-- 3. Quantos pedidos foram entregues?

select count(*) from orders_dataset
where order_status = 'delivered';  

-- 4. Quantos clientes únicos existem?

select count(distinct customer_unique_id)
from customers_dataset;

-- 5. Quantos sellers existem?

select count(*) from sellers_dataset;

-- 6. Quantos produtos existem?

select count(*) from products_dataset;

-- 7. Liste todas as categorias de produtos distintas.

select distinct product_category_name
from products_dataset
order by product_category_name;

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

-- 11. Quantos vendedores existem?

select count(*) as total_vendedores
from sellers_dataset;

-- 12. Quantos produtos existem por categoria?

select product_category_name, count(*) as total_produtos
from products_dataset
group by product_category_name
order by total_produtos desc;


-- 13. Há quantos pedidos por estado do cliente?

select customer_state, count(*) as total_pedidos
from customers_dataset as c 
join orders_dataset as o on c.customer_id = o.customer_id
group by c.customer_state
order by total_pedidos desc;

-- 14. Quais as top 10 cidades com mais clientes ?

select customer_city, count(*) as total_clientes
from customers_dataset
group by customer_city
order by total_clientes desc
limit 10;


-- 15. Quais são os 10 produtos mais vendidos em quantidade ?

select oi.product_id, count(*) as total_vendas,
       p.product_category_name
from order_items_dataset as oi
join products_dataset as p on oi.product_id = p.product_id
group by oi.product_id, p.product_category_name
order by total_vendas desc
limit 10;

-- 16. Quais são os status de pedidos possíveis e quantos existem em cada um?

select order_status, count(*) as quantidade
from orders_dataset
group by order_status
order by quantidade desc;

-- 17. Quais os 10 produtos mais vendidos com nome da categoria, número de vendas e receita total gerada ?

select p.product_category_name as categoria,
       count(oi.order_id) as total_vendas,
       sum(oi.price) as receita_total
from order_items_dataset as oi
join products_dataset as p on oi.product_id = p.product_id
group by p.product_category_name 
order by total_vendas desc
limit 10;

-- 18. Quais são os vendedores com maior faturamento?

select s.seller_id, count(distinct oi.order_id) as total_orders, 
       sum(oi.price) as total_revenue, 
       avg(oi.price) as avg_order_value
from order_items_dataset as oi
join sellers_dataset as s on oi.seller_id = s.seller_id
group by s.seller_id
order by total_revenue desc
limit 10;

-- 19. Qual é a receita total por categoria de produto?

select p.product_category_name,
       sum(oi.price) as receita_total
from order_items_dataset as oi
join products_dataset as p on oi.product_id = p.product_id
group by p.product_category_name
order by receita_total desc;

-- 20. Qual foi o ticket médio (preço médio por pedido)?

select avg(total) as ticket_medio
from(select order_id, sum(price) as total from order_items_dataset group by order_id) as sub;


-- 21. Qual o tempo médio de entrega dos pedidos (dias)?

select avg(date_part('day',
           cast(order_delivered_customer_date as timestamp) - cast(order_purchase_timestamp as timestamp))) as tempo_medio_entrega
from orders_dataset
where order_delivered_customer_date is not null;


-- 22. Qual a quantidade de pedidos por data ? filtrar do maior para o menor. 

select date(order_purchase_timestamp) as day, 
       count(*) as order_count
from orders_dataset
group by day
order by order_count desc;


-- 23. Quantos pedidos foram pagos com cartão ?

select count(*) 
from order_payments_dataset
where payment_type = 'credit_card';

-- 24. Quais são os estados com mais clientes? 

select geolocation_state, count(*) as total
from customers_dataset as c
join geolocation_dataset as g
on c.customer_zip_code_prefix = g.geolocation_zip_code_prefix
group by geolocation_state
order by total desc
limit 5;

-- 25. Há quantas avaliações com nota 5?

select count(*) 
from order_reviews_dataset
where review_score = 5;

-- 26. Qual a nota média geral em avaliações?

select avg(review_score) 
from order_reviews_dataset;

-- 27. Qual a quantidade de sellers com mais pedidos?

select seller_id, count(distinct order_id) as pedidos
from order_items_dataset
group by seller_id
order by pedidos desc
limit 10;

-- 28. Qual o faturamento total ?

select sum(price + freight_value) as faturamento_total
from order_items_dataset as oi
join orders_dataset as o
on oi.order_id = o.order_id
where o.order_status = 'delivered';

-- 29. Qual o faturamento mensal ? 

select date_trunc('month', o.order_purchase_timestamp) as mes, 
       sum(price + freight_value) as faturamento
from orders_dataset as o
join order_items_dataset as oi
on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by mes
order by mes;

-- 30. Qual o ticket médio de todas as vendas? utilizar o with

with pedido as(
    select order_id, sum(price + freight_value) as total
    from order_items_dataset
    group by order_id
)
select avg(total) from pedido;

-- 31. Qual o top de categorias por faturamento?

select p.product_category_name,
       sum(oi.price) as faturamento
from order_items_dataset as oi
join products_dataset as p
on oi.product_id = p.product_id
join orders_dataset as o
on oi.order_id = o.order_id
where o.order_status = 'delivered'
group by p.product_category_name
order by faturamento desc
limit 10;


