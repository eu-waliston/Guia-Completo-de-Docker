# 📚 Comandos Úteis

```
# Inicializar plataforma completa
./scripts/init.sh

# Deploy em produção
./scripts/deploy.sh production

# Backup de dados
./scripts/backup.sh

# Monitoramento
./scripts/monitor.sh

# Logs específicos
docker-compose logs -f users-service
docker-compose logs -f --tail=100

# Acessar banco de dados
docker-compose exec postgres psql -U admin -d microservices

# Executar migrações
docker-compose exec users-service alembic upgrade head

# Testar endpoints
curl http://localhost/api/users/health
curl http://localhost/api/products/health
curl http://localhost/api/orders/health

# Escalar serviço
docker-compose up -d --scale users-service=3

# Limpar tudo
docker-compose down -v
docker system prune -a

```
