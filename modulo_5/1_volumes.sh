# Cria Volume
docker volume create meu-volume

# Listar volumers
docker volume ls

# Inspecionar volume
docker volume inspect meu-volume

# Remover volume
docker volume rm meu-volume

# User volume
docker run -d --name mysql-container -v meu-volume:/var/mysqç -e MYSQL_ROOT_PASSWORD=senha mysql:8.0

# Volume bind (mapear diretório local )
docker run -d --name nginx-local -v $(pwd)/html/share/nginx/html -p 80:80 nginx

