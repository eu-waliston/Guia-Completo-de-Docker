# Banco de dados com volume persistente
docker run -d --name postgres-db -v postgres_data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=senha123 -p 5432:5432 postgres:14

# Aplicação com configuração externa
mkdir config
echo "DEBUG=true" > config/.env

docker run -d --name minha-app -v $(pwd)/config:/app/config -v $(pwd)/logs:/app/logs minha-imagem

