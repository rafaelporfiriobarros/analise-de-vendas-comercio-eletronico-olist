# Conjunto de Dados Públicos de E-Commerce Brasileiro da Olist

## 📊 100.000 Pedidos com informações de produtos, clientes e avaliações

![Badge](https://img.shields.io/badge/Dataset-E--Commerce-orange) ![Badge](https://img.shields.io/badge/Records-100k-brightgreen) ![Badge](https://img.shields.io/badge/Period-2016--2018-blue)

## Download
[Link para Download do Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Sobre o Dataset
**Conjunto de Dados Públicos de E-Commerce Brasileiro da Olist**  
Bem-vindo! Este é um conjunto de dados público de e-commerce brasileiro com pedidos realizados na Olist Store. O dataset contém informações de 100 mil pedidos entre 2016 e 2018 realizados em diversos marketplaces do Brasil. Seus recursos permitem analisar um pedido sob múltiplas perspectivas: status do pedido, preço, desempenho de pagamento e frete, localização do cliente, atributos do produto e avaliações escritas pelos clientes. Também disponibilizamos um dataset de geolocalização que relaciona CEPs brasileiros com coordenadas de latitude/longitude.

Estes são dados comerciais reais, que foram anonimizados, com referências a empresas e parceiros substituídas por nomes das grandes casas de Game of Thrones.


## Contexto
Este dataset foi gentilmente fornecido pela Olist, a maior loja de departamentos nos marketplaces brasileiros. A Olist conecta pequenos negócios de todo o Brasil a canais de venda sem complicações e com um único contrato. Esses comerciantes podem vender seus produtos através da Olist Store e enviá-los diretamente aos clientes usando parceiros logísticos da Olist. Saiba mais em: [www.olist.com](https://www.olist.com)

Após a compra na Olist Store, o vendedor é notificado para preparar o pedido. Quando o cliente recebe o produto ou na data estimada de entrega, ele recebe uma pesquisa de satisfação por e-mail onde pode avaliar a experiência de compra e deixar comentários.

## Observação
- Um pedido pode conter múltiplos itens
- Cada item pode ser enviado por um vendedor diferente
- Todos os textos identificando lojas e parceiros foram substituídos por nomes das grandes casas de Game of Thrones

## Estrutura do Dataset
O conjunto contém vários arquivos CSV relacionados entre si:
- `olist_customers_dataset.csv` - Dados dos clientes
- `olist_orders_dataset.csv` - Informações dos pedidos
- `olist_order_items_dataset.csv` - Itens de cada pedido
- `olist_products_dataset.csv` - Dados dos produtos
- E outros arquivos complementares

## Perguntas de Negócio

**1. Liste os 5 pedidos mais recentes.**

```sql
select order_id, order_purchase_timestamp from orders_dataset
order by order_purchase_timestamp desc
limit 5;
```

**R: OS PEDIDOS MAIS RECENTES SÃO DE 17/10/2018, 16/10/2018, 03/10/2018, 01/10/2018 E 29/09/2018.**

**2.Quantos pedidos existem na base?**

```sql
select count(*) as total_de_pedidos from orders_dataset;
```

**R: EXISTEM 99.441 PEDIDOS REGISTRADOS NA BASE.**

**3. Quantos pedidos foram entregues?**

```sql
select count(*) from orders_dataset
where order_status = 'delivered'; 
```

**R: FORAM ENTREGUES 96.478 PEDIDOS.**

**4. Quantos clientes únicos existem?**

```sql
select count(distinct customer_unique_id)
from customers_dataset;
```

**R: EXISTEM 96.096 CLIENTES ÚNICOS.**

**5. Quantos sellers existem?**

```sql
select count(*) from sellers_dataset;
```

**R: EXISTEM 3.095 SELLERS.** 

**6. Quantos produtos existem?**

```sql
select count(*) from products_dataset;
```

**R: EXISTEM 32.951 PRODUTOS.**

**7. Liste todas as categorias de produtos distintas.**

```sql
select distinct product_category_name
from products_dataset
order by product_category_name;
```

**R: AS 5 PRIMEIRAS CATEGORIAS SÃO: "agro_industria_e_comercio", "alimentos", "alimentos_bebidas", "artes", "artes_e_artesanato".** 

**8. Quantos pedidos foram cancelados?**

```sql
select count(*) from orders_dataset
where order_status = 'canceled';
```

**R: FORAM CANCELADOS 625 PEDIDOS.**

**9. Qual o valor médio de frete (freight_value)?**

```sql
select avg(freight_value) from order_items_dataset;
```

**R: O VALOR MÉDIO DE FRETE É DE R$ 19.99.**

**10. Liste os 10 pedidos com o maior valor de frete.**

```sql
select order_id, freight_value
from order_items_dataset
order by freight_value desc
limit 10;
```

**R: OS 5 PRIMEIROS PEDIDOS COM O MAIOR VALOR DE FRETE SÃO:**

- 77e1550db865202c56b19ddc6dc4d53: 409.68
- 76d1555fb53a89b0ef4d529e527a0f6: 375.28
- fde74c28a3d5d618c00f26d51baafa0: 375.28
- f49bd16053df810384e793386312674: 339.59
- 64a7e199467906c0727394df82d1a6a: 338.3

**11. Quantos vendedores existem?**

```sql
select count(*) as total_vendedores
from sellers_dataset;
```

**R: EXISTEM 3.095 VENDEDORES.**

**12. Quantos produtos existem por categoria?**

```sql
select product_category_name, count(*) as total_produtos
from products_dataset
group by product_category_name
order by total_produtos desc;
```

**R: OS 5 PRIMEIROS PRODUTOS SÃO:**

- cama_mesa_banho:3029
- esporte_lazer:2867
- moveis_decoracao:2657
- beleza_saude:2444
- utilidades_domesticas:2335

**13. Há quantos pedidos por estado do cliente?**

```sql
select customer_state, count(*) as total_pedidos
from customers_dataset as c 
join orders_dataset as o on c.customer_id = o.customer_id
group by c.customer_state
order by total_pedidos desc;
```

**R: OS 5 PRIMEIROS PEDIDOS SÃO:**

- SP: 41746
- RJ: 12852
- MG: 11635
- RS: 5466
- PR: 5045

**14. Quais as top 10 cidades com mais clientes ?**

```sql
select customer_city, count(*) as total_clientes
from customers_dataset
group by customer_city
order by total_clientes desc
limit 10;
```

**R: AS 5 PRIMEIRAS CIDADES SÃO:**

- sao paulo: 15540
- rio de janeiro: 6882
- belo horizonte: 2773
- brasilia: 2131
- curitiba: 1521


**15. Quais são os 10 produtos mais vendidos em quantidade ?**

```sql
select oi.product_id, count(*) as total_vendas,
       p.product_category_name
from order_items_dataset as oi
join products_dataset as p on oi.product_id = p.product_id
group by oi.product_id, p.product_category_name
order by total_vendas desc
limit 10;
```

**R: OS 5 PRIMEIROS SÃO:**

- aca2eb7d00ea1a7b8ebd4e68314663af: 527 - moveis_decoracao 
- 99a4788cb24856965c36a24e339b6058: 488 - cama_mesa_banho 
- 422879e10f46682990de24d770e7f83d: 484 - ferramentas_jardim
- 389d119b48cf3043d311335e499d9c6b: 392 - ferramentas_jardim 
- 368c6c730842d78016ad823897a372db: 388 - ferramentas_jardim 

**16. Quais são os status de pedidos possíveis e quantos existem em cada um?**

```sql
select order_status, count(*) as quantidade
from orders_dataset
group by order_status
order by quantidade desc;
```

**R: EXISTEM AS SEGUINTES QUANTIDADES DE PEDIDOS POSSÍVEIS:**

- delivered: 96478
- shipped: 1107
- canceled: 625
- unavailable: 609
- invoiced: 314
- processing: 301
- created: 5
- approved: 2


**17. Quais os 10 produtos mais vendidos com nome da categoria, número de vendas e receita total gerada ?**

```sql
select p.product_category_name as categoria,
       count(oi.order_id) as total_vendas,
       sum(oi.price) as receita_total
from order_items_dataset as oi
join products_dataset as p on oi.product_id = p.product_id
group by p.product_category_name 
order by total_vendas desc
limit 10;
```

**R: OS 10 PRODUTOS MAIS VENDIDOS SÃO:**

- cama_mesa_banho: 11115 - 1036988.6800000712
- beleza_saude: 9670 - 1258681.3399999682
- esporte_lazer: 8641 - 988048.9700000401
- moveis_decoracao: 833 - 729762.4900000411
- informatica_acessorios: 7827 - 911954.3200000388
- utilidades_domesticas: 6964 - 632248.6600000213
- relogios_presentes: 5991 - 1205005.6799999995
- telefonia: 4545 - 323667.529999989
- ferramentas_jardim: 4347 - 485256.46000001475
- automotivo: 4235 - 592720.1100000107
