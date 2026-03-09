# Landing Page Redesign AI Agents

Uma equipe de 3 agentes de IA que recebe a URL de qualquer landing page e a recria do zero no [Paper](https://paper.design) com design profissional, conteúdo completo e imagens geradas por IA.

```
/redesign <url>  →  Redesigner  →  Reviewer  →  Image Generator  →  Landing page pronta
```

**O que cada agente faz:**

| Agente | Função |
|--------|--------|
| **Redesigner** | Extrai todo o conteúdo da URL e recria a landing page no Paper com design elegante e moderno |
| **Reviewer** | Compara a recriação com a original e gera um relatório garantindo que nenhum conteúdo ficou de fora |
| **Image Generator** | Identifica onde imagens são necessárias, gera via IA (Flux Pro) e insere no design |

---

## Pre-requisitos

Antes de começar, você precisa ter instalado:

### 1. Claude Code (CLI)

O Claude Code é a CLI oficial da Anthropic para o Claude. É o motor que roda os agentes.

```bash
npm install -g @anthropic-ai/claude-code
```

> Requer Node.js 18+. Se não tiver o Node, instale em https://nodejs.org (versão LTS).

Depois de instalar, faça login:

```bash
claude login
```

Siga as instruções para autenticar com sua conta Anthropic. Você precisa de uma assinatura Claude Pro, Team ou Enterprise, OU créditos de API configurados.

**Documentação completa:** https://docs.anthropic.com/en/docs/claude-code

### 2. Paper (app de design)

Paper é a ferramenta de design onde as landing pages serão criadas. É gratuito.

1. Baixe o Paper em https://paper.design
2. Instale e abra o app
3. Crie uma conta (gratuita)
4. Crie um novo documento vazio (ou abra um existente)

**Importante:** O Paper precisa estar aberto e rodando enquanto os agentes trabalham. Ele se comunica com o Claude Code via MCP (Model Context Protocol).

### 3. Paper MCP Plugin no Claude Code

O Claude Code precisa do plugin do Paper para controlar o app. Dentro do Paper:

1. Abra o Paper e crie ou abra um documento
2. Vá em **Settings** (engrenagem no canto) → **Plugins** → **Claude Code**
3. Ative o plugin — ele vai mostrar um snippet para adicionar ao config do Claude Code
4. Adicione a configuração do MCP do Paper no seu Claude Code. Abra o terminal e rode:

```bash
claude mcp add paper --transport http http://127.0.0.1:29979/mcp
```

> O endereço `http://127.0.0.1:29979/mcp` é o padrão do Paper. Se o seu for diferente, use o que aparecer nas configurações do Paper.

Para verificar se funcionou:

```bash
claude mcp list
```

Deve mostrar `paper` na lista de servidores MCP.

### 4. Conta no fal.ai (para geração de imagens)

O agente de imagens usa o [fal.ai](https://fal.ai) com o modelo Flux Pro v1.1 Ultra para gerar imagens.

1. Acesse https://fal.ai e crie uma conta
2. Vá em https://fal.ai/dashboard/keys
3. Clique em **Create Key**
4. Copie a key gerada (começa com `fal-`)

> **Custo:** Cada imagem custa ~$0.06. Uma landing page típica usa 3-5 imagens = ~$0.30 por redesign.

---

## Instalação

### Passo 1: Clonar o repositório

```bash
git clone https://github.com/SEU-USUARIO/designer-team.git
cd designer-team
```

Ou baixe o ZIP e extraia numa pasta de sua preferência.

### Passo 2: Configurar a API key do fal.ai

Abra o arquivo `.env` na raiz do projeto e substitua o placeholder pela sua key:

```env
FAL_KEY=fal-SUA_KEY_AQUI
```

> **Nunca compartilhe sua key.** O arquivo `.env` já está no `.gitignore` e não será commitado.

### Passo 3: Tornar o script executável (Mac/Linux)

```bash
chmod +x scripts/generate-image.sh
```

> No Windows com Git Bash isso já funciona automaticamente.

### Passo 4: Verificar dependências

Rode estes comandos para confirmar que tudo está instalado:

```bash
# Node.js (precisa ser v14+)
node --version

# curl
curl --version

# Claude Code
claude --version
```

Se algum não funcionar, volte na seção de pré-requisitos.

### Passo 5: Abrir o projeto no Claude Code

```bash
cd designer-team
claude
```

O Claude Code vai ler o `CLAUDE.md` automaticamente e entender o contexto do projeto.

> **Importante:** O Paper precisa estar aberto com um documento antes de rodar qualquer comando.

---

## Como Usar

### Pipeline completa (recomendado)

Dentro do Claude Code, rode:

```
/redesign https://exemplo.com/landing-page
```

Isso vai:
1. Extrair todo o conteúdo da URL
2. Criar uma landing page nova no Paper com design profissional
3. Revisar se todo o conteúdo da original está presente
4. Gerar imagens com IA e inserir no design
5. Mostrar o resultado final

### Agentes individuais

Você também pode rodar cada agente separadamente:

```
/redesign-only https://exemplo.com/landing-page
```
Só recria o design no Paper, sem review nem imagens.

```
/review-design https://exemplo.com/landing-page
```
Só revisa um artboard já criado vs a página original. Selecione o artboard no Paper antes de rodar.

```
/generate-images
```
Só gera e insere imagens nos placeholders de um artboard existente. Selecione o artboard no Paper antes de rodar.

---

## Estrutura do Projeto

```
designer-team/
├── CLAUDE.md                           # Instruções globais para o Claude Code
├── .env                                # Sua API key do fal.ai (não commitado)
├── .gitignore                          # Ignora outputs e .env
│
├── .claude/
│   ├── settings.local.json             # Permissões dos tools do Claude Code
│   └── commands/                       # Slash commands (entrada dos agentes)
│       ├── redesign.md                 # /redesign — pipeline completa
│       ├── redesign-only.md            # /redesign-only — só design
│       ├── review-design.md            # /review-design — só revisão
│       └── generate-images.md          # /generate-images — só imagens
│
├── agents/                             # Definições dos 3 agentes
│   ├── redesigner.md                   # Agent 1: extrai conteúdo + recria no Paper
│   ├── reviewer.md                     # Agent 2: verifica conteúdo completo
│   └── image-generator.md             # Agent 3: gera e insere imagens
│
├── templates/
│   └── landing-page-checklist.md       # Checklist usado pelo Reviewer
│
├── scripts/
│   └── generate-image.sh              # Script que chama a API do fal.ai
│
└── output/                            # Gerado automaticamente (não commitado)
    ├── original-content.md            # Conteúdo extraído da landing page
    ├── review-report.md               # Relatório de revisão
    ├── image-manifest.md              # Lista de imagens geradas
    └── images/                        # Imagens geradas pelo Flux Pro
```

---

## Como Funciona (por dentro)

### 1. Redesigner

Quando você roda `/redesign <url>`:

1. O agente usa `WebFetch` para acessar a URL e extrair **todo** o conteúdo: textos, headlines, CTAs, preços, depoimentos, FAQ, footer, etc.
2. Salva o conteúdo estruturado em `output/original-content.md`
3. Gera um **design brief** com paleta de cores, tipografia e direção visual
4. Cria um artboard de 1440px no Paper
5. Constrói a landing page **seção por seção** (uma chamada por grupo visual):
   - Navegação → Hero → Social Proof → Benefícios → Módulos → Garantia → Preços → Depoimentos → Sobre → FAQ → CTA Final → Footer
6. Onde imagens são necessárias, insere **placeholders** com nomes descritivos (ex: "Hero Image - mãe com bebê dormindo")
7. Verifica o resultado com screenshots a cada 2-3 seções

### 2. Reviewer

Depois do redesign:

1. Busca novamente o conteúdo da URL original (fonte da verdade)
2. Lê o conteúdo extraído em `output/original-content.md`
3. Analisa a estrutura do design no Paper
4. Verifica cada item do `templates/landing-page-checklist.md`:
   - Todas as headlines presentes?
   - Todos os CTAs?
   - Preços exatos?
   - Depoimentos com nomes corretos?
   - FAQ completo?
   - Dados legais do footer?
5. Gera relatório PASS/FAIL em `output/review-report.md`
6. Se faltar conteúdo crítico, sinaliza para correção antes de prosseguir

### 3. Image Generator

Depois da revisão:

1. Varre o artboard procurando placeholders de imagem (pelo `layer-name`)
2. Define um **estilo visual consistente** para todas as imagens
3. Cria prompts detalhados para cada imagem, incluindo:
   - Estilo visual, paleta de cores, composição
   - Instrução explícita de "no text" (sem texto nas imagens)
4. Gera cada imagem via fal.ai Flux Pro v1.1 Ultra (~$0.06/imagem)
5. Insere as imagens no Paper substituindo os placeholders
6. Salva um manifesto com todos os prompts usados em `output/image-manifest.md`

---

## Personalização

### Trocar o modelo de geração de imagens

O script `scripts/generate-image.sh` usa Flux Pro v1.1 Ultra por padrão. Para usar outro modelo do fal.ai:

1. Abra `scripts/generate-image.sh`
2. Troque a URL `https://fal.run/fal-ai/flux-pro/v1.1-ultra` pelo endpoint do modelo desejado
3. Atualize o `agents/image-generator.md` com a nova referência

Modelos disponíveis em: https://fal.ai/models

### Alterar o checklist de revisão

Edite `templates/landing-page-checklist.md` para adicionar ou remover itens de verificação conforme o tipo de landing page que você mais trabalha.

### Ajustar o estilo de design

As regras de design estão em dois lugares:
- `CLAUDE.md` — regras globais (paleta, tipografia, espaçamento)
- `agents/redesigner.md` — regras específicas do redesign

Edite esses arquivos para mudar a direção visual padrão.

---

## Solução de Problemas

### "FAL_KEY não encontrada"

Verifique se o arquivo `.env` existe na raiz do projeto e contém sua key:
```env
FAL_KEY=fal-xxxxxxxxxxxxx
```

### "Paper MCP não conectado"

1. Certifique-se que o Paper está aberto com um documento
2. Verifique a conexão MCP:
   ```bash
   claude mcp list
   ```
3. Se `paper` não aparecer, adicione novamente:
   ```bash
   claude mcp add paper --transport http http://127.0.0.1:29979/mcp
   ```

### "Slash command não encontrado"

Os comandos `/redesign`, `/review-design` e `/generate-images` só funcionam quando o Claude Code é aberto **dentro da pasta do projeto**:
```bash
cd designer-team
claude
```

### "Imagens não aparecem no Paper"

O agente usa URLs remotas do fal.ai para inserir imagens. Se as imagens não carregam:
- Verifique sua conexão com a internet
- As URLs do fal.ai expiram após algumas horas — regere se necessário

### "O design ficou cortado / overflow"

Se o conteúdo ultrapassar o artboard, o agente deve ajustar com `height: fit-content`. Se isso não aconteceu automaticamente, selecione o artboard no Paper e ajuste manualmente.

---

## Custos Estimados

| Recurso | Custo |
|---------|-------|
| Claude Code (Claude Pro) | $20/mês (inclui uso generoso) |
| Claude Code (API) | ~$0.50-2.00 por redesign (varia com tamanho da página) |
| Paper | Gratuito |
| fal.ai (imagens) | ~$0.06/imagem (~$0.30 por landing page) |

---

## Requisitos de Sistema

| Requisito | Mínimo |
|-----------|--------|
| Node.js | v18+ |
| curl | Qualquer versão recente |
| Git Bash (Windows) | Incluído com Git for Windows |
| Sistema Operacional | Windows 10+, macOS 12+, Linux |
| Internet | Necessária (APIs externas) |

---

## Licença

MIT — Use, modifique e distribua livremente.
