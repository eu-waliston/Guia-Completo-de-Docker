# Deploy da stack
docker stack deploy -c docker-compose.swarm.yml minha-stack

# Listar serviços
docker stack services minha-stack

# Remover stack
docker stack rm minha-stack