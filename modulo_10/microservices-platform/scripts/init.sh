#!/bin/bash

set -e

echo "🚀 inicializando prataforma de micriserviços..."

# Carregar variavéis de ambiente
if [ -f .env]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "⚠️  Arquivo .env não encontrado. Usando .env.example"
    cp .env.example .env
    export $(cat .env | grep -v '^#' | xargs)
fi

#* Criar diretórios necessários
echo "📁 Criando estrutura de diretórios..."
mkdir -p databases/backup
mkdir -p storage/uploads
mkdir -p monitoring/grafana/dashboards
mkdir -p monitoring/grafana/datasources
mkdir -p logging/logstash

# configurar permissões
echo "🔧 Configurando permissões..."
chmod +x scripts/*.sh

# Inicializar banco de dados
echo "🗄️  Inicializando bancos de dados..."
docker-composer up -d postgres

echo "⏳ Aguardando PostgreSQL ficar disponível..."
sleep 10

# Executar scripts SQL de inicialização

for sql_file in database/init-scripts/*.sql; do
    echo "Executando: $sql_file"
    docker-compose exec -T postgres psql -U $DB_USER -d postgres -f /docker-entrypoint-initdb.d/$(basename $sql_file)
done

# Construir e iniciar serviços
echo "🏗️  Construindo imagens..."
docker-compose build

echo "🚀 Iniciando todos os serviços..."
docker-compose up -d


echo "⏳ Aguardando serviços inicializarem..."
sleep 15

# Verificar saúde dos serviços
echo "🏥 Verificando saúde dos serviços..."
docker-compose ps

echo "📊 Acessos:"
echo "Traefik Dashboard:    http://localhost:"
echo "Grafana:              http://localhost:"
echo "Kibana:               http://localhost:"
echo "RabbitMQ Manager:     http://localhost:"
echo "MinIO Console:        http://localhost:"
echo "KEycloak:             http://localhost:"

echo "✅ Plataforma inicializada com sucesso!"