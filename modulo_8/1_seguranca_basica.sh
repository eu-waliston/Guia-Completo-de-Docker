# Executar como usuário não-root
docker run -u 1000:1000 minha-imagem

# Remover privilégios
docker run --cap-drop=ALL --cap-add=NET_BIND_SERVICE nginx

# Read-only filesystem
docker ru --ready-only alpine

# Security scanning
docker scan minha-imagem

# Atualizar imagens regularmente
docker pull nome_imagem:latest