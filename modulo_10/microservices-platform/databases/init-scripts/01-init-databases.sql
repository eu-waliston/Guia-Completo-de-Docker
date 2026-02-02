-- Criar bancos de dados para cada serviço
CREATE DATABASE usersdb;
CREATE DATABASE productsdb;
CREATE DATABASE ordersdb;
CREATE DATABASE keycloak;

-- Criar usuário específico para cada serviço (opcional)
CREATE USER users_service WITH PASSWORD 'users123';
CREATE USER products_service WITH PASSWORD 'products123';
CREATE USER orders_service WITH PASSWORD 'orders123';

-- Conceder permissões
GRANT ALL PRIVILEGES ON DATABASE usersdb TO users_service;
GRANT ALL PRIVILEGES ON DATABASE productsdb TO products_service;
GRANT ALL PRIVILEGES ON DATABASE ordersdb TO orders_service;