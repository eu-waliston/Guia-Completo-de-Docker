FROM ubuntu:latest

LABEL maintainer="me-email@exemplo.com"
LABEL version="1.0"
LABEL description="Minha imagem customizada"

# Variaveis de ambiente
ENV APP_HOME=/app NODE_ENV=production

#Diretorio de trabalho
WORKDIR $APP_HOME

#copiar arquivos
COPY package.json .
COPY src/ ./src/

# Instalar dependências
RUN apt update && apt install -y python3 nodejs npm && rm -rf /var/lib/apt/list/*

RUN npm install

# Export porttas
EXPOSE 3000

# Comando de inicializaçaõ
CMD ["npm", "start"]

# Entrypoint alternativo
# ENTRYPOINT ["npm"]
# CMD ["start"]
