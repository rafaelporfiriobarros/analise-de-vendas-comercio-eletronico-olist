# Análise de Dados com PostgreSQL - Olist E-commerce

Projeto de análise exploratória utilizando **PostgreSQL** e o dataset público da **Olist**, disponível no Kaggle.

O objetivo é praticar consultas SQL voltadas para **Engenharia de Dados** e **Analytics**, explorando métricas de vendas, logística, clientes e desempenho operacional.

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)
![SQL](https://img.shields.io/badge/SQL-Analytics-success)
![Dataset](https://img.shields.io/badge/Olist-Kaggle-orange)

---

# Sobre o Dataset

O dataset contém aproximadamente **100 mil pedidos** realizados entre **2016 e 2018** em marketplaces brasileiros.

As informações incluem:

- Pedidos
- Clientes
- Produtos
- Vendedores
- Pagamentos
- Avaliações
- Geolocalização

Dataset original:

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

---

# Tecnologias

- PostgreSQL
- SQL
- DBeaver
- Git
- GitHub

---

# Modelo de Dados

| Tabela | Descrição |
|---------|-----------|
| orders_dataset | Pedidos |
| customers_dataset | Clientes |
| order_items_dataset | Itens dos pedidos |
| products_dataset | Produtos |
| sellers_dataset | Vendedores |
| order_payments_dataset | Pagamentos |
| order_reviews_dataset | Avaliações |
| geolocation_dataset | Geolocalização |

---

# Relacionamentos

```
Customers
     │
     ▼
Orders
 ├────────► Payments
 ├────────► Reviews
 └────────► Order Items
               │
        ┌──────┴──────┐
        ▼             ▼
    Products      Sellers
```

---

# Objetivo

Este projeto faz parte dos meus estudos em:

- PostgreSQL
- SQL
- Engenharia de Dados
- Data Analytics

O foco é desenvolver consultas SQL utilizadas em cenários reais de análise de dados e e-commerce.


# Perguntas de Negócio

**QUAL O TOP 10 DAS CATEGORIAS COM MAIOR FATURAMENTO**

```sql
select
	p.product_category_name, 
	ROUND(SUM(oi.price)::NUMERIC,2) AS faturamento
from order_items_dataset as oi
join products_dataset as p
on oi.product_id = p.product_id
group by p.product_category_name
order by faturamento desc
limit 10;
```

R: As top 10 categorias com maior faturamento foram:

- beleza_saude
- relogios_presentes
- cama_mesa_banho
- esporte_lazer
- informatica_acessorios
- moveis_decoracao
- cool_stuff
- utilidades_domesticas
- automotivo
- ferramentas_jardim


**QUAL O TOP 10 DO TICKET MÉDIO POR CATEGORIA**

```sql
select p.product_category_name, 
       round(avg(oi.price)::numeric,2) as ticket_medio
from order_items_dataset as oi
join products_dataset as p
on oi.product_id = p.product_id
group by p.product_category_name
order by ticket_medio desc;
```

R: O top 10 do ticket médio por categoria são: 

- pcs: 1098.34
- portateis_casa_forno_e_cafe: 624.29
- eletrodomesticos_2: 476.12
- agro_industria_e_comercio: 342.12
- instrumentos_musicais: 281.62
- eletroportateis: 280.78
- portateis_cozinha_e_preparadores_de_alimentos: 264.57
- telefonia_fixa: 225.69
- construcao_ferramentas_seguranca: 208.99
- relogios_presentes: 201.14

**QUAL O TOP 10 DAS CATEGORIAS COM MAIOR CUSTO DE FRETE**

```sql
elect p.product_category_name,
	   round(sum(oi.freight_value)::numeric,2) as frete_total
from order_items_dataset as oi
join products_dataset as p
on oi.product_id = p.product_id
group by p.product_category_name
order by frete_total desc;
```
R: O top das categorias com maior custo de frete são:

- cama_mesa_banho: 204693.04
- beleza_saude: 182566.73
- moveis_decoracao: 172749.30
- esporte_lazer: 168607.51
- informatica_acessorios: 147318.08
- utilidades_domesticas: 146149.11
- relogios_presentes: 100535.93
- ferramentas_jardim: 98962.75
- automotivo: 92664.21
- cool_stuff: 84039.10

**QUAL O TOP 10 DO PESO MÉDIO DOS PRODUTOS POR CATEGORIA**

```sql
select * from products_dataset limit 10;

select product_category_name,
       round(avg(product_weight_g)::numeric, 2) as peso_medio
from products_dataset 
group by product_category_name
order by peso_medio desc;
```

R: O top 10 do peso médio dos produtos por categoria são: 

- moveis_colchao_e_estofado: 13190.00
- moveis_escritorio: 12740.87
- moveis_cozinha_area_de_servico_jantar_e_jardim: 11598.56
- moveis_quarto: 9997.22
- eletrodomesticos_2: 9913.33
- moveis_sala: 8934.85
- pcs: 7995.33
- industria_comercio_e_negocios: 5929.19
- agro_industria_e_comercio: 5263.41
- climatizacao: 4459.96

**QUAL O TOP 10 DAS CATEGORIAS COM PIOR AVALIAÇÃO**

```sql
select p.product_category_name,
       round(avg(r.review_score)::numeric,2) as nota_media
from order_items_dataset as o
join products_dataset as p
on o.product_id = p.product_id
join order_reviews_dataset as r
on o.order_id = r.order_id
group by p.product_category_name
order by nota_media desc;
```

R: O top 10 das categorias com pior avaliação são: 

- cds_dvds_musicais: 4.64
- fashion_roupa_infanto_juvenil: 4.50
- livros_interesse_geral: 4.45
- construcao_ferramentas_ferramentas: 4.44
- flores: 4.42
- livros_importados: 4.40
- livros_tecnicos: 4.37
- malas_acessorios: 4.32
- alimentos_bebidas: 4.32
- portateis_casa_forno_e_cafe: 4.30

**QUAL O TOP 10 DO TEMPO MÉDIO DE ENTREGA POR ESTADO**

```sql
select c.customer_state,
       avg(o.order_delivered_customer_date::timestamp - o.order_purchase_timestamp::timestamp) as tempo_medio
from orders_dataset as o
join customers_dataset as c
on o.customer_id = c.customer_id
where order_status = 'delivered'
group by customer_state
order by tempo_medio desc;
```

R: O top 10 do tempo médio de entrega por estado são:

- RR: 28 days 33:18:03.97561
- AP: 26 days 28:26:29.850746
- AM: 25 days 34:13:25.613793
- AL: 24 days 13:03:09.103275
- PA: 23 days 18:33:00.021142
- MA: 21 days 13:45:05.167364
- SE: 21 days 12:28:29.707463
- CE: 20 days 30:23:52.394058
- AC: 20 days 24:51:25.6
- PB: 19 days 34:14:32.72147

**QUAL O TOP 10 DOS ESTADOS QUE MAIS COMPRARAM**

```sql
select 
customer_state, 
count(*) as pedidos
from customers_dataset as c
join orders_dataset as o
on c.customer_id = o.customer_id
group by customer_state 
order by pedidos desc;
```

R: O top 10 dos estados que mais compraram foram: 

- SP: 41746
- RJ: 12852
- MG: 11635
- RS: 5466
- PR: 5045
- SC: 3637
- BA: 3380
- DF: 2140
- ES: 2033
- GO: 2020

**TOP 10 DOS CLIENTES COM MAIOR GASTO**

```sql
select o.customer_id, 
       round(sum(payment_value)::numeric, 2) as total_gasto
from orders_dataset as o
join order_payments_dataset as p
on o.order_id = p.order_id
group by customer_id
order by total_gasto desc
limit 20;
```

R: O top 10 dos clientes com maior gasto foram: 

- 1617b1357756262bfa56ab541c47bc16: 13664.08
- ec5b2ba62e574342386871631fafd3fc: 7274.88
- c6e2731c5b391845f6800c97401a43a9: 6929.31
- f48d464a0baaea338cb25f816991ab1f: 6922.21
- 3fd6777bbce08a352fddd04e4a7cc8f6: 6726.66
- 05455dfa7cd02f13d132aa7a6a9729c6: 6081.54
- df55c14d1476a9a3467f131269c2477f: 4950.34
- e0a2412720e9ea4f26c1ac985f6a7358: 4809.44
- 24bbf5fd2f2e1b359ee7de94defc4a15: 4764.34
- 3d979689f636322c62418b6346b1c6d2: 4681.78

**QUAL FOI A FORMA DE PAGAMENTO MAIS UTILIZADA**

```sql
select
payment_type, 
count(*) as quantidade
from order_payments_dataset
group by payment_type
order by quantidade desc;
```
R: As formas de pagamento mais utilizadas foram: 

- credit_card: 76795
- boleto: 19784
- voucher: 5775
- debit_card: 1529
- not_defined: 3

**QUAL FOI A MÉDIA DOS PARCELAMENTOS**

```sql
select 
payment_type,
round(avg(payment_installments)::numeric, 2) as parcelas
from order_payments_dataset
group by payment_type;
```

R: A média dos parcelamentos foi de:

- not_defined: 1.00
- boleto: 1.00
- debit_card: 1.00
- voucher: 1.00
- credit_card: 3.51

**QUAL FOI O TOP 10 DO RANKING DOS VENDEDORES**

```sql
select seller_id, 
round(sum(price)::numeric, 2) as faturamento
from order_items_dataset
group by seller_id
order by faturamento desc;
```

R: O top 10 do ranking dos vendedores foram:

- 4869f7a5dfa277a7dca6462dcf3b52b2: 229472.63
- 53243585a1d6dc2643021fd1853d8905: 222776.05
- 4a3ca9315b744ce9f8e9374361493884: 200472.92
- fa1c13f2614d7b5c4749cbc52fecda94: 194042.03
- 7c67e1448b00f6e969d365cea6b010ab: 187923.89
- 7e93a43ef30c4f03f38b393420bc753a: 176431.87
- da8622b14eb17ae2831f4ac5b9dab84a: 160236.57
- 7a67c85e85bb2ce8582c35f2203ad736: 141745.53
- 1025f0e2d44d7041d6cf58b6550e0bfa: 138968.55
- 955fee9216a65b617aa5c0531780ce60: 135171.70


**QUAL O TOP 10 DA QUANTIDADE DE PEDIDOS POR VENDEDOR**

```sql
select seller_id, count(distinct order_id) as pedidos
from order_items_dataset
group by seller_id 
order by pedidos desc;
```

R: O top 10 da quantidade de pedidos por vendedor foram:

- 6560211a19b47992c3666cc44a7e94c0: 1854
- 4a3ca9315b744ce9f8e9374361493884: 1806
- cc419e0650a3c5ba77189a1882b7556a: 1706
- 1f50f920176fa81dab994f9023523100: 1404
- da8622b14eb17ae2831f4ac5b9dab84a: 1314
- 955fee9216a65b617aa5c0531780ce60: 1287
- 7a67c85e85bb2ce8582c35f2203ad736: 1160
- ea8482cd71df3c1969d7b9473ff13abc: 1146
- 4869f7a5dfa277a7dca6462dcf3b52b2: 1132
- 3d871de0142ce09b7081e2b9d1733cb1: 1080

**QUAL O TOP 10 DA RECEITA POR MÊS**

```sql
select
date_trunc('month', order_purchase_timestamp::timestamp ) as mes,
round(sum(payment_value)::numeric, 2) as receita
from orders_dataset as o
join order_payments_dataset as p
on o.order_id = p.order_id
group by mes
order by receita desc;
```

R: O top 10 da receita por mês foi:

- 2017-11-01 00:00:00.000: 1194882.80
- 2018-04-01 00:00:00.000: 1160785.48
- 2018-03-01 00:00:00.000: 1159652.12
- 2018-05-01 00:00:00.000: 1153982.15
- 2018-01-01 00:00:00.000: 1115004.18
- 2018-07-01 00:00:00.000: 1066540.75
- 2018-06-01 00:00:00.000: 1023880.50
- 2018-08-01 00:00:00.000: 1022425.32
- 2018-02-01 00:00:00.000: 992463.34


**COMO FOI O CRESCIMENTO MENSAL EM TODO O PERÍODO**

```sql
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
```

R: O crescimento mensal em todo o período foi: 

| Mês | Receita (R$) | Receita Anterior (R$) | Crescimento (R$) |
|:-----|-------------:|----------------------:|-----------------:|
| 2016-09 | 252,24 | - | - |
| 2016-10 | 59.090,48 | 252,24 | 58.838,24 |
| 2016-12 | 19,62 | 59.090,48 | -59.070,86 |
| 2017-01 | 138.488,04 | 19,62 | 138.468,42 |
| 2017-02 | 291.908,01 | 138.488,04 | 153.419,97 |
| 2017-03 | 449.863,60 | 291.908,01 | 157.955,59 |
| 2017-04 | 417.788,03 | 449.863,60 | -32.075,57 |
| 2017-05 | 592.918,82 | 417.788,03 | 175.130,79 |
| 2017-06 | 511.276,38 | 592.918,82 | -81.642,44 |
| 2017-07 | 592.382,92 | 511.276,38 | 81.106,54 |
| 2017-08 | 674.396,32 | 592.382,92 | 82.013,40 |
| 2017-09 | 727.762,45 | 674.396,32 | 53.366,13 |
| 2017-10 | 779.677,88 | 727.762,45 | 51.915,43 |
| 2017-11 | 1.194.882,80 | 779.677,88 | 415.204,92 |
| 2017-12 | 878.401,48 | 1.194.882,80 | -316.481,32 |
| 2018-01 | 1.115.004,18 | 878.401,48 | 236.602,70 |
| 2018-02 | 992.463,34 | 1.115.004,18 | -122.540,84 |
| 2018-03 | 1.159.652,12 | 992.463,34 | 167.188,78 |
| 2018-04 | 1.160.785,48 | 1.159.652,12 | 1.133,36 |
| 2018-05 | 1.153.982,15 | 1.160.785,48 | -6.803,33 |
| 2018-06 | 1.023.880,50 | 1.153.982,15 | -130.101,65 |
| 2018-07 | 1.066.540,75 | 1.023.880,50 | 42.660,25 |
| 2018-08 | 1.022.425,32 | 1.066.540,75 | -44.115,43 |
| 2018-09 | 4.439,54 | 1.022.425,32 | -1.017.985,78 |
| 2018-10 | 589,67 | 4.439,54 | -3.849,87 |
