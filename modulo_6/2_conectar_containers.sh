# Crair rede
docker network create app-network

# Executar banco de dados na rede
docekr run -d --name db --networkapp-network -e POSTGRES_PASSWORD=senha postgres

# Executar aplicações na mesma rede
docker run -d --name app --network app-network -e DB_HOST=db -p 3000:3000 minha-app

# Conectar container existente a uma rede
docker network connect app-network nome_container