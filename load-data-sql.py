import pandas as pd
from sqlalchemy import create_engine
import os

# Configurações do banco de dados (PostgreSQL)
DB_USER = "postgres"
DB_PASSWORD = "123"
DB_HOST = "localhost"
DB_PORT = "5432"
DB_NAME = "olist_commerce"

# String de conexão (PostgreSQL)
engine = create_engine(f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

# Pasta onde estão os arquivos CSV
DATA_DIR = "data/"

# Dicionário atualizado com mapeamento de tabelas e arquivos CSV
# (Removido o prefixo 'dist_' para corresponder ao script SQL corrigido)
tables = {
    "geolocation_dataset": "olist_geolocation_dataset.csv",
    "customers_dataset": "olist_customers_dataset.csv",
    "products_dataset": "olist_products_dataset.csv",
    "sellers_dataset": "olist_sellers_dataset.csv",
    "orders_dataset": "olist_orders_dataset.csv",
    "order_items_dataset": "olist_order_items_dataset.csv",
    "order_payments_dataset": "olist_order_payments_dataset.csv",
    "order_reviews_dataset": "olist_order_reviews_dataset.csv"
}

# Loop para carregar todos os arquivos
for table_name, csv_file in tables.items():
    try:
        file_path = os.path.join(DATA_DIR, csv_file)
        df = pd.read_csv(file_path)
        
        # Remove espaços extras nos nomes das colunas
        df.columns = df.columns.str.strip()
        
        # Pré-processamento específico para cada tabela
        if table_name == "orders_dataset":
            # Corrigindo possíveis erros de digitação nos nomes das colunas
            df.columns = df.columns.str.replace('delivered_carrier_date', 'delivered_carrier_date')
            df.columns = df.columns.str.replace('delivered_customer_date', 'delivered_customer_date')
            df.columns = df.columns.str.replace('estimated_delivery_date', 'estimated_delivery_date')
        
        # Envia para o banco de dados (substitui a tabela se já existir)
        df.to_sql(table_name, engine, if_exists="replace", index=False)
        print(f"***** {table_name} carregado com sucesso! ***** ")
    
    except Exception as e:
        print(f"***** Erro ao carregar {table_name}: {e} ***** ")

print("***** Todos os dados foram importados! ***** ")