# 🧠 MÓDULO 1 — Fundamentos e Conceitos do Docker

> Antes de sair rodando containers como um mago do terminal, a gente precisa alinhar a mente. Docker não é só ferramenta — é **mudança de mentalidade**. Este módulo constrói a base que vai sustentar tudo o que vem depois.

---

## 🎯 Objetivo do Módulo

Ao final deste módulo, você vai:

* Entender **o que é Docker de verdade** (sem buzzword vazia)
* Saber **por que containers existem** e qual problema eles resolvem
* Diferenciar claramente **containers vs máquinas virtuais**
* Conhecer a **arquitetura do Docker** e seus principais componentes
* Começar a pensar em aplicações de forma **container-first**

Se isso aqui ficar sólido, o resto flui. Promessa. 🌊

---

## 1.1 🐳 O que é Docker?

Docker é uma **plataforma de containerização** que permite empacotar uma aplicação **junto com tudo o que ela precisa para rodar** — código, dependências, bibliotecas e configurações — e executar isso de forma **consistente em qualquer ambiente**.

Em termos humanos:

> *“Funciona na minha máquina” deixa de ser desculpa.*

Com Docker:

* O ambiente de desenvolvimento
* O ambiente de teste
* O ambiente de produção

…todos falam a **mesma língua**.

### ✨ O problema que o Docker resolve

Antes do Docker, o cenário era mais ou menos assim:

* App funciona no notebook do dev
* Quebra no servidor de homologação
* Explode em produção

Motivos comuns:

* Versão diferente de dependência
* Configuração do SO diferente
* Serviços externos inconsistentes

Docker resolve isso isolando a aplicação em **containers padronizados e reproduzíveis**.

---

## 1.2 📦 O que é um Container?

Um **container** é uma unidade leve e isolada que executa uma aplicação utilizando o **kernel do sistema operacional hospedeiro**, mas mantendo:

* Sistema de arquivos isolado
* Processos isolados
* Rede isolada
* Recursos controlados (CPU, memória, I/O)

Containers **não virtualizam hardware**. Eles compartilham o kernel, o que os torna:

* ⚡ Muito mais rápidos
* 🪶 Mais leves
* 📈 Extremamente escaláveis

> Pense em containers como apartamentos dentro do mesmo prédio (SO).
> Máquinas virtuais são prédios separados.

---

## 1.3 🆚 Containers vs Máquinas Virtuais

Visualmente, a diferença fica clara:

```
Máquina Virtual:                 Container:
+----------------------+        +----------------------+
|       App A          |        |        App A         |
|       App B          |        +----------------------+
+----------------------+        |        Docker        |
|   Sistema Operacional|        +----------------------+
+----------------------+        |   Sistema Operacional|
|      Hipervisor      |        +----------------------+
+----------------------+        |        Hardware      |
|       Hardware       |        +----------------------+
+----------------------+
```

### 🔍 Principais diferenças

| Característica | Máquinas Virtuais  | Containers        |
| -------------- | ------------------ | ----------------- |
| Inicialização  | Lenta (minutos)    | Rápida (segundos) |
| Uso de memória | Alto               | Baixo             |
| Isolamento     | Total (SO próprio) | Processo / Kernel |
| Portabilidade  | Média              | Altíssima         |
| Escalabilidade | Limitada           | Excelente         |

Docker não substitui VMs — eles **se complementam**. Mas para aplicações modernas, containers são o caminho natural.

---

## 1.4 🏗️ Arquitetura do Docker

Docker segue uma arquitetura **cliente-servidor**:

* O usuário interage com o **Docker Client**
* O Client conversa com o **Docker Daemon**
* O Daemon gerencia imagens, containers, redes e volumes

Tudo isso acontece de forma transparente pra você — mas entender esse fluxo evita muita dor de cabeça.

---

## 1.5 🧩 Componentes Fundamentais do Docker

### 🔧 Docker Daemon (`dockerd`)

* Serviço em background
* Responsável por criar, executar e gerenciar containers
* Gerencia imagens, volumes, redes e logs

Sem o daemon rodando, **nada acontece**.

---

### 💻 Docker Client

* Interface de linha de comando (`docker`)
* É o que você usa no terminal
* Envia comandos para o Docker Daemon

Exemplo mental:

> Você fala → Client traduz → Daemon executa

---

### 📦 Docker Images (Imagens)

Imagens são **templates imutáveis** usados para criar containers.

Características:

* Somente leitura
* Versionadas
* Reutilizáveis
* Construídas em camadas (layers)

Uma imagem é como uma **receita**.
O container é o **prato pronto**.

---

### ▶️ Containers

Containers são **instâncias em execução de uma imagem**.

Eles podem:

* Ser iniciados
* Parados
* Reiniciados
* Removidos

Tudo isso em segundos.

Importante:

> Container não é descartável por ser inútil — é descartável porque é **reproduzível**.

---

### 🗂️ Docker Registry

Registries são repositórios de imagens.

O mais famoso:

* **Docker Hub** (público)

Mas você também pode usar:

* Registries privados
* GitHub Container Registry
* GitLab Registry
* Harbor

É assim que imagens viajam pelo mundo.

---

### 📝 Dockerfile

O Dockerfile é um **arquivo de instruções** que define como uma imagem será construída.

Ele descreve:

* Imagem base
* Dependências
* Configurações
* Comando de execução

Dockerfile é código.
E código precisa de padrão, clareza e boas práticas.

---

## 1.6 🧠 Conceitos-Chave que Você Precisa Guardar

* Docker **não virtualiza hardware**
* Containers compartilham o kernel do host
* Imagens são imutáveis
* Containers são efêmeros
* Persistência exige volumes
* Automação é regra, não exceção

Se isso fizer sentido agora, você está oficialmente no caminho certo. 🚀

---

## 🚀 Próximo Passo

👉 **Módulo 2 — Instalação e Configuração do Docker no Linux**

Agora que a mente entendeu, é hora de preparar a máquina. ⚙️🐧
