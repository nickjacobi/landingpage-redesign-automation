# Designer Team

Equipe de 3 agentes de IA para redesign de landing pages no Paper.

## Pipeline

```
/redesign <url>  →  Redesigner  →  Reviewer  →  Image Generator  →  Resultado
```

**Agentes:**
- `agents/redesigner.md` — Extrai conteúdo da URL e recria no Paper com design superior
- `agents/reviewer.md` — Compara recriação vs original, garante que nada falta
- `agents/image-generator.md` — Gera imagens via fal.ai Flux e insere nos placeholders

## Protocolo de Coordenação

Os agentes passam dados entre si via:
1. **Artboard node ID** — identificador do artboard criado no Paper
2. **Arquivos em `output/`**:
   - `output/original-content.md` — conteúdo extraído da landing page original
   - `output/review-report.md` — relatório de revisão do Agent 2
   - `output/image-manifest.md` — manifesto de imagens geradas pelo Agent 3
   - `output/images/` — imagens geradas

## Regras do Paper MCP

- Sempre criar artboard com `create_artboard` antes de adicionar conteúdo
- Artboard desktop: **1440px** de largura, height `fit-content`
- `write_html`: escrever **1 grupo visual por chamada** (header, card, row, button group)
- `get_screenshot`: tirar screenshot a cada **2-3 modificações** para revisar qualidade
- `get_font_family_info`: validar fontes **antes** de usar pela primeira vez
- `finish_working_on_nodes`: chamar ao terminar o trabalho no artboard
- Usar `display: flex` para layout (nunca grid, inline ou tables)
- Usar apenas inline styles
- Usar `layer-name` em elementos para identificação semântica

## Padrão de Design

- Usar a skill `frontend-design` para gerar o brief de design
- Google Fonts expressivas (nunca usar fontes genéricas como Arial, Roboto padrão)
- Tipografia editorial: contraste forte entre display e body
- Paleta de cores com neutrals + 1 cor de destaque intencional
- Minimalismo: menos elementos, mais refinados
- Espaçamento generoso e intencional
- Light mode por padrão

## Protocolo de Imagens

O Redesigner cria **placeholders** para onde imagens devem ir:
- Elementos `div` com cor sólida de fundo
- `layer-name` descritivo do conteúdo da imagem (ex: `layer-name="Hero Image - mãe abraçando bebê dormindo"`)
- O Image Generator encontra esses placeholders via `get_tree_summary` e substitui por imagens reais

## Geração de Imagens — fal.ai Flux Pro v1.1 Ultra

- **Endpoint:** `https://fal.run/fal-ai/flux-pro/v1.1-ultra`
- **Auth:** Header `Authorization: Key $FAL_KEY` (key no `.env`)
- **Script helper:** `scripts/generate-image.sh` (requer `curl` + `node` v14+)
- **Custo:** ~$0.06 por imagem
- **Formato:** JPEG por padrão (menor tamanho, ~600KB vs ~4MB PNG)
- **Tamanhos:** `landscape_16_9`, `landscape_4_3`, `square_hd`, `portrait_4_3`, `portrait_16_9`
- Imagens salvas em `output/images/`
- **Inserção no Paper:** Usar a URL remota retornada pela API do fal.ai diretamente no `<img src>` do `write_html`. URLs locais via `localhost:29979/media/` podem causar timeout com imagens grandes.

### Problemas conhecidos e soluções

- **`python3` não disponível no Windows**: O script usa `node` para JSON encoding e parsing. NÃO usar `python3`.
- **Imagens PNG muito grandes (4-5MB)**: Sempre gerar como JPEG (~600KB). PNGs causam timeout no Paper.
- **Timeout ao inserir imagens no Paper via URL local**: Usar a URL remota do fal.ai (`https://v3b.fal.media/...`) diretamente no `write_html` com `<img src="URL_REMOTA">`.
- **`backgroundImage` CSS não renderiza no Paper**: NÃO usar `update_styles` com `backgroundImage`. Usar `write_html` com `<img>` tag para inserir imagens.

## Comandos Disponíveis

| Comando | Descrição |
|---------|-----------|
| `/redesign <url>` | Pipeline completa (redesign + review + images) |
| `/redesign-only <url>` | Só o redesign no Paper |
| `/review-design <url>` | Só a revisão de conteúdo |
| `/generate-images` | Só a geração e inserção de imagens |
