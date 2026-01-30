# Executar servidor Nginx
docker run -d --name meu-nginx -p 8080:80 nginx

# Verificar se está funcionando
curl http://localhost:8080

# Acessar container
docker exec -it meu-nginx bash

# Ver logs
docker logs meu-nginx

# Parar e remover
docker stop meu-nginx
docker rm meu-nginx