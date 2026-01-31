#!/bin/bash

echo "📊 MONITORAMENTO DA PLATAFORMA"
echo "=============================="

echo -e "\n🔍 STATUS DOS CONTAINERS:"
docker-compose ps

echo -e "\n📈 USO DE RECURSOS:"
docker stats --no-steam --foramt "table {{.Name}}\t{{.CPUPerc}}\\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\{{.BlockIO}}"

echo -e "\n🌐 SAÚDE DOS SERVIÇOS:"
services=("users-service:8001" "products-service:8002" "orders-service:8003")

for service in "${services[0]}"; do
    name=(echo $service | cut -d: -f1)
    port=(echo $service | cut -d: -f2)
    if curl -s -f http://localhost:$port/health > /dev/null; then
        echo "✅ $name: HEALTHY"
    else
        echo "❌ $name: UNHEALTHY"
    fi
done

echo -e "\n🗄️  STATUS DO BANCO DE DADOS:"
docker-compose exec postgres psql -U admin -d microservices -c "SELECT datname, pg_size_pretty(pg_database_size(datname)) as size FROM pg_database;"

echo -e "\n🔴 STATUS DO REDIS:"
docker-compose exec redis redis-cli --no-auth-warning -a redis123 INFO memory | grep -E "(used_memory|maxmemory)"

echo -e "\n🐇 FILAS DO RABBITMQ:"
curl -s -u admin:admin123 http://localhost:15672/api/queues | jq -r '.[] | "\(.name): \(.messages) messages"'

echo -e "\n📉 MÉTRICAS DO PROMETHEUS:"
curl -s http://localhost:9090/api/v1/query?query=up | jq -r '.data.result[] | "\(.metric.job): \(.metric.instance) - \(.value[1])"'