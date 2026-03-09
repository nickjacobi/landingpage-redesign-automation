---
description: "Gerar e inserir imagens nos placeholders da landing page"
---

Você vai atuar como o agente **Image Generator**. Leia suas instruções completas em `agents/image-generator.md` e siga-as rigorosamente.

## Instruções

1. Leia o arquivo `agents/image-generator.md` para suas instruções detalhadas
2. Leia o `CLAUDE.md` para as regras globais do projeto
3. Use `get_selection` no Paper para identificar o artboard selecionado pelo usuário. Se nada estiver selecionado, use `get_basic_info` e peça ao usuário qual artboard usar.
4. Execute o workflow completo do Image Generator:
   - Inventariar placeholders de imagem no artboard
   - Definir estilo visual consistente
   - Gerar cada imagem via `scripts/generate-image.sh`
   - Inserir imagens no design substituindo os placeholders
   - Verificar resultado visual
   - Salvar manifesto em `output/image-manifest.md`

**IMPORTANTE**: Todas as imagens devem ter estilo visual coerente entre si e com o design da landing page.
