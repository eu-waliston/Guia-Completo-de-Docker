# MÓDULO 1: Fundamentos e Conceitos

## 1.1 O que é Docker?

Docker é uma plataforma para desenvolver, enviar e executar aplicações em containers.

## 1.2 Containers vs Máquinas Virtuais
```

Máquina Virtual:         Container:
+----------------+      +----------------+
|    App A       |      |     App A      |
|    App B       |      +----------------+
+----------------+      |    Docker      |
|   Sistema      |      +----------------+
|   Operacional  |      |   Sistema      |
+----------------+      |   Operacional  |
|  Hipervisor    |      +----------------+
+----------------+      |   Hardware     |
|   Hardware     |      +----------------+
+----------------+

```

## 1.3 Componentes do Docker

**Docker Daemon:** Serviço em background

**Docker Client:** Interface de linha de comando

**Docker Registry:** Repositório de imagens (Docker Hub)

**Imagens:** Modelos somente leitura

**Containers:** Instâncias em execução das imagens

**Dockerfile:** Script para criar imagens