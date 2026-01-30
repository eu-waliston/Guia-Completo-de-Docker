# Buscar imagens
docker search ubunut
docker search nginx --filter "is-oficial=true"

# Baixar imagens
docker pull ubuntu:20.04
docker pull nginx:alpine

# Listar iamgens
docker images
docker image ls

# remover imagens
docker rmi nome_imagem

# shellcheck disable=SC2046
docker rmi $(docker images -q) #remover todas

# Limpar recursos não utilizados
docker system prune -a