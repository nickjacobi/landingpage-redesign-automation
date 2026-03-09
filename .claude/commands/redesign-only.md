---
description: "Redesign de landing page no Paper (só design, sem review nem imagens)"
argument-hint: "<url>"
---

Você vai atuar como o agente **Redesigner**. Leia suas instruções completas em `agents/redesigner.md` e siga-as rigorosamente.

**URL para redesign:** $ARGUMENTS

## Instruções

1. Leia o arquivo `agents/redesigner.md` para suas instruções detalhadas
2. Leia o `CLAUDE.md` para as regras globais do projeto
3. Execute o workflow completo do Redesigner:
   - Extrair conteúdo da URL
   - Salvar em `output/original-content.md`
   - Gerar design brief (use a skill `frontend-design`)
   - Construir a landing page no Paper seção por seção
   - Inserir placeholders de imagem com `layer-name` descritivos
   - Revisar visualmente com screenshots
   - Finalizar e reportar o artboard node ID

**IMPORTANTE**: Construa incrementalmente — 1 grupo visual por chamada `write_html`. Nunca escreva a página inteira de uma vez.
