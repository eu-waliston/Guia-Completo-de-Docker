# Construir imagem
docker build -t minha-imagem:1.0
docker buidl -f Dockerfile.dev -t minha-imagem:dev .

# Build com argumentos
docker build --build-arg NODE_ENV=development -t minha-imagem .

# Liatar histórico de builds
docker history nome_imagem

# Multi-stage build (avançado)