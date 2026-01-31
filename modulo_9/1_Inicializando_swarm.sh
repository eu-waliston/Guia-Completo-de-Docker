# Inicializar swarm
docekr swarm init

# Adiciona workers
docker swarm join-token worker

# Liata nodes
docker nodes ls

# Deploy de serviço
docker service create --name web --replicas 3 -p 80:80 nginx

# Esclar serviço
docker service scale web=5

# Atualzia serviço
docker service update --image nginx:alpine web

# Remover serviço
docker service rm web

# Drain node (manutenção)
docker node update --availability drain node-name