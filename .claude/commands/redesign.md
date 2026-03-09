---
description: "Pipeline completa: redesign + revisão + geração de imagens"
argument-hint: "<url>"
---

Você é o **Orquestrador** da equipe de design. Vai coordenar 3 agentes em sequência para redesign completo de uma landing page.

**URL para redesign:** $ARGUMENTS

## Pipeline

### Fase 1 — Redesign

Leia `agents/redesigner.md` e `CLAUDE.md`. Execute o workflow completo do Redesigner:

1. Extrair conteúdo da URL com `WebFetch` e salvar em `output/original-content.md`
2. Gerar design brief (use a skill `frontend-design`)
3. Validar fontes com `get_font_family_info`
4. Criar artboard 1440px e construir seção por seção com `write_html`
5. Inserir placeholders de imagem com `layer-name` descritivos
6. Revisar com `get_screenshot` a cada 2-3 seções
7. Anotar o **artboard node ID** criado

### Fase 2 — Revisão

Leia `agents/reviewer.md`. Execute o workflow do Reviewer no artboard criado:

1. Re-fetch a URL original para fonte da verdade
2. Ler `output/original-content.md`
3. Analisar o artboard com `get_tree_summary` e `get_screenshot`
4. Verificar cada item do `templates/landing-page-checklist.md`
5. Gerar relatório em `output/review-report.md`

**Se houver FAIL CRÍTICO**: Corrija os itens faltantes no artboard antes de prosseguir. Use `write_html` para adicionar conteúdo faltante e `set_text_content` para corrigir textos.

### Fase 3 — Geração de Imagens

Leia `agents/image-generator.md`. Execute o workflow do Image Generator:

1. Inventariar placeholders via `get_tree_summary`
2. Definir estilo visual consistente
3. Gerar imagens via `scripts/generate-image.sh`
4. Inserir imagens substituindo placeholders
5. Verificar resultado final com `get_screenshot`
6. Salvar manifesto em `output/image-manifest.md`

### Finalização

1. `finish_working_on_nodes` no artboard
2. Apresentar ao usuário:
   - Screenshot final da landing page
   - Resumo das seções criadas
   - Resultado da revisão (PASS/FAIL)
   - Quantas imagens foram geradas e inseridas

## Regras

- Cada fase deve ser completada antes de iniciar a próxima
- Se a revisão encontrar falhas críticas, corrija ANTES de gerar imagens
- Construa incrementalmente — 1 grupo visual por `write_html`
- Use `get_screenshot` frequentemente para verificar qualidade
