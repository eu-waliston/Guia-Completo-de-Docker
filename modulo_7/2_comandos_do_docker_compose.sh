# Iniciar serviços
docker-compose up
docker-compose up -d # modo detached
docker-compose up --build # rebuild images

# Parar serviços
docker-compose down
docker-compose down -v # Remover volumes também

# Gerenciar serviços
docker-compose start
docker-compose stop
docker-compose restart

# Visualizar logs
docker-compose logs
docker-compose logs -f # seguir logs
docker-compose logs service_name

# Executar comandos
docker-compose exec service_name bash
docker-compose exec psql -U admin -d mydb

# Listar containers
docker-compose ps

# Remover contaienrs paradas
docker-compose rm
