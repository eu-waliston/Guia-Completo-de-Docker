# 🚀 MÓDULO 10 — Projeto Prático Completo com Docker

> Chegamos no ponto onde tudo se conecta. Este módulo não é sobre aprender algo novo — é sobre **provar que você sabe**. Aqui o Docker deixa de ser estudo e vira **entrega real**.

---

## 🎯 Objetivo do Módulo

Neste módulo você vai:

* Integrar todos os conceitos aprendidos nos módulos anteriores
* Subir uma **aplicação full-stack real** com múltiplos serviços
* Trabalhar com **ambiente isolado, reproduzível e versionado**
* Simular um cenário próximo ao de produção
* Desenvolver visão de **arquitetura containerizada**

Se antes você aprendia peças, agora você monta o quebra‑cabeça inteiro. 🧩🐳

---

## 10.1 🧱 Visão Geral da Aplicação Full-Stack

A aplicação é composta por **Plataforma de Microserviços**, cada um rodando em seu próprio container, mas todos conversando entre si por meio de redes Docker.

### 📋 Visão Geral do Projeto

**Vamos construir uma plataforma completa de microserviços com:**

    - API Gateway (Traefik)

    - 3 Microserviços (Python, Node.js, Go)

    - Banco de Dados (PostgreSQL + Redis)

    - Fila de Mensagens (RabbitMQ)

    - Monitoramento (Grafana + Prometheus + cAdvisor)

    - Logging Centralizado (ELK Stack)

    - Autenticação (Keycloak)

    - Storage (MinIO - S3 compatible)

### 🏗️ Arquitetura do Sistema
```
┌─────────────────────────────────────────────────────────────┐
│                       API Gateway (Traefik)                 │
│                       porta: 80, 443                        │
└────────────────┬────────────────┬────────────────┬──────────┘
                 │                │                │
    ┌────────────▼────┐  ┌────────▼────────┐  ┌───▼────────────┐
    │   Serviço Users │  │ Serviço Products│  │ Serviço Orders │
    │   (Python)      │  │ (Node.js)       │  │ (Go)           │
    │   porta: 8001   │  │ porta: 8002     │  │ porta: 8003    │
    └────────────┬────┘  └────────┬────────┘  └───┬────────────┘
                 │                │                │
    ┌────────────▼────┐  ┌────────▼────────┐  ┌───▼────────────┐
    │   PostgreSQL    │  │    RabbitMQ     │  │     Redis      │
    │   (Users DB)    │  │   (Messaging)   │  │   (Cache)      │
    └─────────────────┘  └─────────────────┘  └────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    Camada de Observabilidade                │
├─────────────────────────────────────────────────────────────┤
│  Prometheus │ Grafana │ cAdvisor │ ELK Stack │ Jaeger       │
└─────────────────────────────────────────────────────────────┘


```

Essa arquitetura segue o princípio:

> *Um serviço, um container. Uma responsabilidade por vez.*

---



## 🗂️ Estrutura do Projeto

```
microservices-platform/
├── docker-compose.yml
├── .env.example
├── .gitignore
├── README.md
├── scripts/
│   ├── init.sh
│   ├── backup.sh
│   ├── deploy.sh
│   └── monitor.sh
├── gateway/
│   ├── Dockerfile
│   └── traefik.yaml
├── services/
│   ├── users-service/
│   │   ├── Dockerfile
│   │   ├── requirements.txt
│   │   ├── app/
│   │   │   ├── __init__.py
│   │   │   ├── main.py
│   │   │   ├── models.py
│   │   │   ├── schemas.py
│   │   │   └── database.py
│   │   └── alembic/
│   ├── products-service/
│   │   ├── Dockerfile
│   │   ├── package.json
│   │   ├── src/
│   │   │   ├── server.js
│   │   │   ├── models/
│   │   │   └── routes/
│   │   └── tests/
│   └── orders-service/
│       ├── Dockerfile
│       ├── go.mod
│       ├── main.go
│       ├── handlers/
│       └── models/
├── databases/
│   ├── init-scripts/
│   │   ├── 01-init-users.sql
│   │   ├── 02-init-products.sql
│   │   └── 03-init-orders.sql
│   └── backup/
├── messaging/
│   └── rabbitmq/
│       └── definitions.json
├── monitoring/
│   ├── prometheus/
│   │   └── prometheus.yml
│   ├── grafana/
│   │   ├── dashboards/
│   │   └── datasources/
│   └── alerts/
│       └── alertmanager.yml
├── logging/
│   ├── elasticsearch/
│   ├── logstash/
│   │   └── logstash.conf
│   └── kibana/
├── storage/
│   └── minio/
└── auth/
    └── keycloak/
        └── realm-export.json
```

## Script para criar as pastas [ so copiar e colar no terminal]

```
mkdir -p microservices-platform/{scripts,gateway,services/{users-service/{app,alembic},products-service/{src/{models,routes},tests},orders-service/{handlers,models}},databases/{init-scripts,backup},messaging/rabbitmq,monitoring/{prometheus,grafana/{dashboards,datasources},alerts},logging/{elasticsearch,logstash,kibana},storage/minio,auth/keycloak} && \
touch microservices-platform/{docker-compose.yml,.env.example,.gitignore,README.md} && \
touch microservices-platform/scripts/{init.sh,backup.sh,deploy.sh,monitor.sh} && \
touch microservices-platform/gateway/{Dockerfile,traefik.yaml} && \
touch microservices-platform/services/users-service/{Dockerfile,requirements.txt} && \
touch microservices-platform/services/users-service/app/{__init__.py,main.py,models.py,schemas.py,database.py} && \
touch microservices-platform/services/products-service/{Dockerfile,package.json} && \
touch microservices-platform/services/products-service/src/server.js && \
touch microservices-platform/services/orders-service/{Dockerfile,go.mod,main.go} && \
touch microservices-platform/databases/init-scripts/{01-init-users.sql,02-init-products.sql,03-init-orders.sql} && \
touch microservices-platform/messaging/rabbitmq/definitions.json && \
touch microservices-platform/monitoring/prometheus/prometheus.yml && \
touch microservices-platform/monitoring/alerts/alertmanager.yml && \
touch microservices-platform/logging/logstash/logstash.conf && \
touch microservices-platform/auth/keycloak/realm-export.json

```

Cada pasta representa um **serviço independente**, com seu próprio ciclo de vida e responsabilidades bem definidas.

---

## ⚙️ docker-compose.yml — O Cérebro da Stack

O `docker-compose.yml` é o arquivo que descreve **como todos os serviços coexistem**.

Ele define:

* Quais serviços existem
* Como eles são construídos
* Como se comunicam
* Quais portas são expostas
* Quais variáveis de ambiente utilizam

> Compose não executa containers isolados.
> Ele executa **um ecossistema inteiro**.

---

## 🎨 Frontend — Interface do Usuário

O frontend é responsável pela **experiência do usuário**.

### Papel do container de frontend

* Build da aplicação
* Servir arquivos estáticos
* Consumir a API do backend

### Conceitos aplicados

* Build isolado via Dockerfile
* Ambiente previsível
* Comunicação via rede Docker

> O frontend não precisa saber onde o backend roda.
> Ele só precisa saber **o nome do serviço**.

---

## 🧠 Backend — API e Regra de Negócio

O backend é o coração da aplicação.

### Responsabilidades

* Processar requisições
* Aplicar regras de negócio
* Retornar dados ao frontend

### Conceitos Docker aplicados

* Container stateless
* Variáveis de ambiente para configuração
* Escalabilidade horizontal

> Backend bem containerizado escala fácil e falha com dignidade.

---

## 🌐 Nginx — Proxy Reverso

O Nginx atua como **porta de entrada da aplicação**.

### Funções principais

* Redirecionar requisições
* Centralizar acesso
* Servir como camada de abstração

### Benefícios

* Separação clara de responsabilidades
* Facilidade para SSL e cache
* Arquitetura mais próxima da produção real

> Em produção, raramente clientes falam direto com containers.
> Eles falam com um proxy.

---

## 🔐 Arquivo `.env` — Configuração sem Acoplamento

O arquivo `.env` concentra **configurações sensíveis e variáveis de ambiente**.

### Por que isso importa?

* Evita hardcode
* Facilita troca de ambiente
* Mantém segurança

> Código não muda entre ambientes.
> Configuração muda.

---

## 🧠 Conceitos-Chave Consolidados neste Módulo

Neste projeto você pratica, na vida real:

* Containers efêmeros
* Imagens imutáveis
* Persistência controlada
* Redes internas Docker
* Orquestração com Compose
* Separação de responsabilidades

Este módulo não ensina apenas Docker.
Ele ensina **arquitetura moderna de aplicações**.

---

## 🏁 Encerramento

Se você chegou até aqui, você não é mais iniciante.

Você:

* Entende Docker
* Constrói imagens
* Orquestra serviços
* Pensa em produção

Docker agora é ferramenta — não obstáculo.

🐳🔥 **Missão cumprida.**
