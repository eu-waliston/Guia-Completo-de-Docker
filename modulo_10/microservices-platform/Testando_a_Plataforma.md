# 🧪 Testando a Plataforma

```
# 1. Verifique todos os serviços:

# Verifique se todos os serviços estão rodando
docker-compose ps

# Acesse os dashboards:
# - Traefik: http://localhost:8080
# - Grafana: http://localhost:3000
# - Kibana: http://localhost:5601

# 2. Teste os endpoints da API:

# Health checks
curl http://localhost/api/users/health
curl http://localhost/api/products/health
curl http://localhost/api/orders/health

# Criar usuário
curl -X POST http://localhost/api/users/register \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password123"}'

# Listar produtos
curl http://localhost/api/products


# 3. Monitoramento:

# Ver métricas no Prometheus
open http://localhost:9090

# Ver dashboards no Grafana
open http://localhost:3000

# Ver logs no Kibana
open http://localhost:5601

```
# 🔍 Troubleshooting

```
# Problemas comuns e soluções:

# 1. Portas em uso:

sudo lsof -i :80
sudo kill -9 <PID>

# 2. Limpeza completa:

docker-compose down -v
docker system prune -a -f
docker volume prune -f

# 3. Ver logs de erro:

docker-compose logs --tail=50
docker-compose logs <service-name> --tail=100 -f

# 4. Recuperar backup:

./scripts/restore.sh backups/backup_20240101_120000.tar.gz


# Testar todos os serviços
curl http://localhost/api/users/health
curl http://localhost/api/products/health
curl http://localhost/api/orders/health

# Criar usuário de teste
curl -X POST http://localhost/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "Test123!"}'

```
