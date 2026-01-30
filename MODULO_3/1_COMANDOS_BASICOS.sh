# Informações do sistema
docker info
docker version

# Listar containers
docker ps       # containers ativos
docker ps -a    # todos os containers
docker ps -q    # Somente IDs

# Executar container
docker run [opções] imagem [comando]
docker run -it ubuntu bash  # Modo interativo
docker run  -d nginx        # Modo detached
docker run  --name meu-container nginx

# Gerenciar containers
docker  start  nome_container
docker  stop   nome_container
docker  restart nome_container
docker  pause nome_container
docker  unpause nome_container
docker  rm  nome_container  # Remover container
docker  rm -f nome_container # Força remoção

# Logs e monitoramento
docker  logs nome_container
docker  logs -f nome_container  # Seguir logs
docker  stats # Estatisticas em tempo real
docker  top nome_container # Processos do container

# Executar comandos em container em execução
docker exec -it nome_container bash
docker exec nome_container ls -la

# Inspecionar container
docker inspect nome_container
docker inspect --format='{{.NetworkSettings.IPAddress}}' nome_container


