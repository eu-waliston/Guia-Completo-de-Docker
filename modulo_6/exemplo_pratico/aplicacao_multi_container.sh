# Rede para comunicação interna
docker network create backend

# banco de dados
docker run -d --name redis --network backend redis:alpine

# Aplicação
docker run -d --name app --network backend -p 8080:80 -e REDIS_HOST=redis nginx