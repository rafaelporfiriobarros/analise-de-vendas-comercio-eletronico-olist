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

```sql
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


