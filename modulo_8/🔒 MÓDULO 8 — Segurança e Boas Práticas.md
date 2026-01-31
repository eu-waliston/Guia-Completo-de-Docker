## 🔒 MÓDULO 8 — Segurança e Boas Práticas

Aqui o Docker deixa de ser só funcional e passa a ser **confiável**.

### Princípios de segurança

* Menor privilégio possível
* Superfície de ataque reduzida
* Imagens confiáveis

### Conceitos essenciais

* Containers não são 100% isolados
* Imagens podem conter vulnerabilidades
* Segurança começa no Dockerfile

> Segurança não é opcional. É invisível quando funciona e catastrófica quando falha.

### Boas Práticas

1. Use imagens oficiais

2. Escaneie imagens para vulnerabilidades

3. Não use :latest em produção

4. Minimize o número de camadas

5. Use multi-stage builds

6. Não execute como root

7. Use volumes para dados persistentes

8. Configure limites de recursos

9. Use networks isoladas

10. Mantenha secrets fora das imagens