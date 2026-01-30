# 🐳 Guia Completo de Docker para Linux — Do Zero ao Avançado

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge\&logo=docker\&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge\&logo=linux\&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

Aprenda Docker do **básico ao avançado** com um guia pensado pra vida real: conceitos sólidos, prática constante, exemplos reais e um **projeto full‑stack completo em produção**. Aqui não tem só teoria — tem mão na massa, erro, ajuste fino e aquele *clique* mental que muda o jogo.

---

## 📚 Índice

* [🎯 Objetivo](#-objetivo)
* [✨ Características](#-características)
* [🚀 Módulos do Curso](#-módulos-do-curso)
* [📋 Pré-requisitos](#-pré-requisitos)
* [⚡ Instalação Rápida](#-instalação-rápida)
* [🔧 Como Usar](#-como-usar)
* [🏗️ Projeto Prático](#️-projeto-prático)
* [🧪 Exercícios](#-exercícios)
* [📁 Estrutura do Repositório](#-estrutura-do-repositório)
* [🎓 Certificação Docker](#-certificação-docker)
* [🚀 Começar Agora](#-começar-agora)

---

## 🎯 Objetivo

Este repositório existe pra te levar **do zero absoluto até ambientes Docker prontos pra produção**, sem pular etapas e sem mistério. Ao final, você será capaz de:

* ✅ Entender profundamente o que são containers Docker
* ✅ Instalar e configurar Docker no Linux com segurança
* ✅ Dominar os comandos essenciais do Docker CLI
* ✅ Criar imagens profissionais com Dockerfiles
* ✅ Orquestrar serviços com Docker Compose e Swarm
* ✅ Aplicar boas práticas de segurança e performance
* ✅ Subir um projeto full‑stack real em produção

---

## ✨ Características

* 📖 **Teoria + Prática** — conceito explicado e aplicado na sequência
* 🐧 **Foco em Linux** — Ubuntu/Debian como base, compatível com outras distros
* 🎯 **Do Básico ao Avançado** — evolução natural, sem atalhos perigosos
* 🔧 **Mentalidade de Produção** — configs reais, não exemplos frágeis
* 🧪 **Exercícios Guiados** — aprende fazendo, errando e ajustando
* 🏗️ **Projeto Completo** — frontend, backend, banco, proxy e monitoramento
* 📚 **Recursos Extras** — troubleshooting, observabilidade e ferramentas

---

## 🚀 Módulos do Curso

### 📘 Módulo 1: Fundamentos e Conceitos

* O que é Docker e containers
* Containers vs Máquinas Virtuais
* Arquitetura do Docker
* Componentes principais

### 🔧 Módulo 2: Instalação e Configuração

* Instalação no Ubuntu/Debian
* Configuração do Docker Daemon
* Usuários, permissões e segurança inicial

### 💻 Módulo 3: Comandos Essenciais

* Docker CLI na prática
* Gerenciamento de containers e imagens
* Execução, logs e inspeção

### 🏗️ Módulo 4: Dockerfiles e Imagens

* Anatomia de um Dockerfile
* Instruções principais (FROM, RUN, COPY…)
* Multi‑stage builds
* Boas práticas profissionais

### 💾 Módulo 5: Gerenciamento de Dados

* Volumes Docker
* Bind mounts
* Estratégias de persistência
* Backup e restauração

### 🌐 Módulo 6: Redes no Docker

* Tipos de rede (bridge, host, overlay)
* Comunicação entre containers
* DNS interno do Docker

### 🎭 Módulo 7: Docker Compose

* docker-compose.yml sem dor
* Ambientes multi‑serviço
* Variáveis de ambiente
* Deploy com Compose

### 🔒 Módulo 8: Segurança e Boas Práticas

* Hardening de containers
* Segurança de imagens
* Limitação de recursos
* Scanning de vulnerabilidades

### ⚙️ Módulo 9: Docker Swarm

* Introdução à orquestração
* Inicialização do Swarm
* Deploy e escalabilidade
* Gerenciamento de nodes

### 🚀 Módulo 10: Projeto Full‑Stack

* Frontend + Backend + Banco
* Configuração de produção
* Monitoramento e logging
* Scripts de deploy

---

## 📋 Pré-requisitos

* 🐧 **SO**: Linux (Ubuntu 20.04+ ou Debian 11+)
* 💾 **RAM**: mínimo 2GB (4GB recomendado)
* 📦 **Disco**: 10GB livres
* 🧠 **Conhecimentos**:

  * Terminal Linux
  * Noções básicas de redes
  * Desenvolvimento (opcional)

---

## ⚡ Instalação Rápida

### 1️⃣ Clone o repositório

```bash
git clone https://github.com/seu-usuario/docker-linux-tutorial.git
cd docker-linux-tutorial
```

### 2️⃣ Instale o Docker (Ubuntu/Debian)

```bash
chmod +x scripts/install-docker.sh
sudo ./scripts/install-docker.sh
```

### 3️⃣ Verifique a instalação

```bash
docker --version
docker run hello-world
```

### 4️⃣ Configure seu usuário (opcional)

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 🔧 Como Usar

### 🌱 Iniciantes

* Comece pelo **Módulo 1** em `docs/modules/`
* Execute todos os exemplos
* Resolva os exercícios

### 🌿 Intermediários

* Vá direto aos módulos de interesse
* Explore `projects/` e `challenges/`

### 🌳 Avançados

* Estude as configs de produção
* Rode o projeto full‑stack
* Contribua com melhorias

---

## 🏗️ Projeto Prático

**Aplicação Full‑Stack — Blog Moderno**

```
📦 projeto-blog/
├── frontend/          # React / Next.js
├── backend/           # Node.js / Express
├── database/          # PostgreSQL + Redis
├── nginx/             # Proxy reverso
├── monitoring/        # Grafana + Prometheus
├── docker-compose.yml
└── .env.example
```

### 🚀 Deploy Rápido

```bash
# Clone o projeto exemplo
git clone https://github.com/seu-usuario/docker-blog-example.git

# Configure variáveis de ambiente
cp .env.example .env

# Suba os serviços
docker-compose up -d
```

Acesse:

* Frontend: [http://localhost:3000](http://localhost:3000)
* Backend API: [http://localhost:8000](http://localhost:8000)
* Adminer: [http://localhost:8080](http://localhost:8080)
* Grafana: [http://localhost:3001](http://localhost:3001)

---

## 🧪 Exercícios

### 🟢 Iniciante

* Containerizar uma app Python simples
* Criar imagem de servidor web estático
* Conectar app + banco

### 🟡 Intermediário

* Ambiente Compose com 3 serviços
* Volume persistente para banco
* Rede customizada

### 🔴 Avançado

* CI/CD com Docker + GitHub Actions
* Docker Swarm com múltiplos nodes
* Monitoramento com Prometheus

---

## 📁 Estrutura do Repositório

```
docker-linux-tutorial/
├── docs/
│   ├── modules/
│   ├── cheatsheets/
│   └── references/
├── examples/
├── projects/
├── scripts/
├── challenges/
├── tools/
├── .dockerignore
├── LICENSE
└── README.md
```

---

## 🎓 Certificação Docker

### Docker Certified Associate (DCA)

Cobertura completa dos domínios:

1. Orchestration (25%)
2. Images & Registry (20%)
3. Installation & Config (15%)
4. Networking (15%)
5. Security (15%)
6. Storage & Volumes (10%)

---

## 🚀 Começar Agora

👉 **Bora dar o primeiro passo?**

📘 [Módulo 1 — Fundamentos do Docker](docs/MODULO_!/01-fundamentos.md)

Porque container bom é container entendido. 🐳🔥
