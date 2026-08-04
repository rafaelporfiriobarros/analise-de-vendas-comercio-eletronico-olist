/* VENDAS */

-- TOP 10 CATEGORIAS COM MAIOR FATURAMENTO

select * from order_items_dataset limit 10;
select * from products_dataset limit 10;

select
	p.product_category_name, 
	ROUND(SUM(oi.price)::NUMERIC,2) AS faturamento
from order_items_dataset as oi
join products_dataset as p
on oi.product_id = p.product_id
group by p.product_category_name
order by faturamento desc
limit 10;

-- BELEZA_SAUDE, RELOGIO_PRESENTES E CAMA_MESA_BANHO 
-- SÃO AS 3 CATEGORIAS COM MAIOR FATURAMENTO.

/* TICKET MÉDIO POR CATEGORIA */


select * from order_items_dataset limit 10;
select * from products_dataset limit 10;

select p.product_category_name, 
       round(avg(oi.price)::numeric,2) as ticket_medio
from order_items_dataset as oi
join products_dataset as p
on oi.product_id = p.product_id
group by p.product_category_name
order by ticket_medio desc;


-- pcs, portateis_casa_forno_e_cafe, e eletrodomesticos_24
-- foram as 3 categorias com maior ticket médio.


/* LOGÍSTICA */

-- CATEGORIAS COM MAIOR CUSTO DE FRETE

select * from order_items_dataset limit 10;
select * from products_dataset limit 10;


select p.product_category_name,
	   round(sum(oi.freight_value)::numeric,2) as frete_total
from order_items_dataset as oi
join products_dataset as p
on oi.product_id = p.product_id
group by p.product_category_name
order by frete_total desc;

-- cama_mesa_banho, beleza_saude, e moveis_decoracao
-- são as 3 categorias com os maiores valores de frete.

/* PESO MÉDIO DOS PRODUTOS POR CATEGORIA */

select * from products_dataset limit 10;

select product_category_name,
       round(avg(product_weight_g)::numeric, 2) as peso_medio
from products_dataset 
group by product_category_name
order by peso_medio desc;


-- moveis_colchao_e_estofado, moveis_escritorio e 
-- moveis_cozinha_area_de_servico_jantar_e_jardim
-- foram as 3 categorias com maior peso médio dos produtos. 


/* TEMPO MÉDIO DE ENTREGA POR ESTADO */

select * from orders_dataset limit 10;
select * from customers_dataset limit 10;


select c.customer_state,
       avg(o.order_delivered_customer_date::timestamp - o.order_purchase_timestamp::timestamp) as tempo_medio
from orders_dataset as o
join customers_dataset as c
on o.customer_id = c.customer_id
where order_status = 'delivered'
group by customer_state
order by tempo_medio desc;

-- RR, AP, E AM FORAM OS ESTADOS COM O MAIOR TEMPO DE ENTREGA. 

/* QUALIDADE */

/* CATEGORIAS COM PIOR AVALIAÇÃO */

select * from products_dataset limit 10;
select * from order_reviews_dataset limit 10;


select p.product_category_name,
       round(avg(r.review_score)::numeric,2) as nota_media
from order_items_dataset as o
join products_dataset as p
on o.product_id = p.product_id
join order_reviews_dataset as r
on o.order_id = r.order_id
group by p.product_category_name
order by nota_media desc;

-- cd_dvds_musicais, fashion_roupa_infanto_juvenil e livros_interesse_geral 
-- possuem as piores avaliações.

/* CLIENTES */

/* ESTADOS QUE MAIS COMPRAM */

select 
customer_state, 
count(*) as pedidos
from customers_dataset as c
join orders_dataset as o
on c.customer_id = o.customer_id
group by customer_state 
order by pedidos desc;

-- SP, RJ e MJ são os estados com o maior número de compras

/* CLIENTES COM MAIOR GASTO */

select o.customer_id, 
       round(sum(payment_value)::numeric, 2) as total_gasto
from orders_dataset as o
join order_payments_dataset as p
on o.order_id = p.order_id
group by customer_id
order by total_gasto desc
limit 20;


-- os clientes:

-- 1617b1357756262bfa56ab541c47bc16, 
-- ec5b2ba62e574342386871631fafd3fc e
-- c6e2731c5b391845f6800c97401a43a9

-- são os clientes com os maiores gastos


/* PAGAMENTOS */ 

/* FORMA DE PAGAMENTO MAIS UTILIZADA */

select
payment_type, 
count(*) as quantidade
from order_payments_dataset
group by payment_type
order by quantidade desc;

-- CARTAO DE CRÉDITO, BOLETO E VOUCHER FORAM AS FORMAS DE PAGAMENTO MAIS UTILIZADAS


/* PARCELAMENTO MÉDIO */

select 
payment_type,
round(avg(payment_installments)::numeric, 2) as parcelas
from order_payments_dataset
group by payment_type;

-- 3,51 é valor médio das parcelas de cartão de crédito

/* VENDEDORES */

/* RANKING DOS VENDEDORES */

select * from order_items_dataset limit 10;

select seller_id, 
round(sum(price)::numeric, 2) as faturamento
from order_items_dataset
group by seller_id
order by faturamento desc;

-- os vendedores: 

-- 4869f7a5dfa277a7dca6462dcf3b52b2,
-- 53243585a1d6dc2643021fd1853d8905 e
-- 4a3ca9315b744ce9f8e9374361493884

-- foram os 3 que mais faturaram.


/* QUANTIDADE DE PEDIDOS POR VENDEDOR */

select seller_id, count(distinct order_id) as pedidos
from order_items_dataset
group by seller_id 
order by pedidos desc;


-- Os vendedores: 

-- 6560211a19b47992c3666cc44a7e94c0
-- 4a3ca9315b744ce9f8e9374361493884
-- cc419e0650a3c5ba77189a1882b7556a

-- foram os que mais conseguiram realizar pedidos

/* INDICADORES EXECUTIVOS */

/* RECEITA POR MẼS */

select
date_trunc('month', order_purchase_timestamp::timestamp ) as mes,
round(sum(payment_value)::numeric, 2) as receita
from orders_dataset as o
join order_payments_dataset as p
on o.order_id = p.order_id
group by mes
order by receita desc;

-- Os meses de novembro de 2017, abril de 2018 e março de 2018
-- foram os meses com as maiores receitas 



/* CRESCIMENTO MENSAL */

with receita as(

	select date_trunc('month', order_purchase_timestamp::timestamp) as mes,
	sum(payment_value) as receita
	from orders_dataset as o
	join order_payments_dataset as p
	on o.order_id = p.order_id
	group by mes
)

select mes, receita, lag(receita) over(order by mes) as receita_anterior, 
       receita - lag(receita) over(order by mes) as crescimento from receita;