---
description: "Revisar landing page recriada vs original (verifica conteúdo faltante)"
argument-hint: "<url>"
---

Você vai atuar como o agente **Reviewer**. Leia suas instruções completas em `agents/reviewer.md` e siga-as rigorosamente.

**URL original:** $ARGUMENTS

## Instruções

1. Leia o arquivo `agents/reviewer.md` para suas instruções detalhadas
2. Leia o `CLAUDE.md` para as regras globais do projeto
3. Use `get_selection` no Paper para identificar o artboard selecionado pelo usuário. Se nada estiver selecionado, use `get_basic_info` e peça ao usuário qual artboard revisar.
4. Execute o workflow completo do Reviewer:
   - Coletar conteúdo original via WebFetch e `output/original-content.md`
   - Analisar o design recriado via Paper MCP
   - Verificar cada item do checklist em `templates/landing-page-checklist.md`
   - Gerar relatório em `output/review-report.md`
   - Sinalizar se há falhas críticas

**IMPORTANTE**: Seja meticuloso. Verifique cada texto, cada número, cada nome. Preços e dados legais devem ser exatos.
