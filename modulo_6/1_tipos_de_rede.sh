# Listar redes
docker network ls

# Criar rede personalizada
docker network create minha-rede

#Inspecionar rede
docker network inspect minha-rede

# Tipos de rede:
# - bridge (padrão)
# - host (usa rede do host)
# - none (sem rede)
# - overlay (para swarm)