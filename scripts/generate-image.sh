#!/bin/bash
# generate-image.sh — Gera imagem via fal.ai Flux Pro v1.1 Ultra
# Uso: ./scripts/generate-image.sh "prompt" "image_size" "filename"
# Exemplo: ./scripts/generate-image.sh "A serene bedroom with soft lighting" "landscape_16_9" "hero-image"
#
# Requer: curl, node (v14+)
# Formato de saída: JPEG (menor que PNG, melhor para inserção no Paper)

set -e

PROMPT="$1"
IMAGE_SIZE="${2:-landscape_16_9}"
FILENAME="${3:-generated-image}"
OUTPUT_FORMAT="${4:-jpeg}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="$PROJECT_DIR/output/images"

# Carregar API key do .env
ENV_FILE="$PROJECT_DIR/.env"
if [ -f "$ENV_FILE" ]; then
  export $(grep -v '^#' "$ENV_FILE" | xargs)
fi

if [ -z "$FAL_KEY" ]; then
  echo "ERRO: FAL_KEY não encontrada. Configure no arquivo .env" >&2
  exit 1
fi

if [ -z "$PROMPT" ]; then
  echo "ERRO: Prompt é obrigatório" >&2
  echo "Uso: $0 \"prompt\" \"image_size\" \"filename\" [jpeg|png]" >&2
  exit 1
fi

# Criar diretório de saída se não existir
mkdir -p "$OUTPUT_DIR"

# Usar node para JSON-encode o prompt (compatível com Windows)
JSON_PROMPT=$(node -e "process.stdout.write(JSON.stringify(process.argv[1]))" "$PROMPT")

echo "Gerando imagem: $FILENAME ($IMAGE_SIZE, $OUTPUT_FORMAT)..." >&2

# Chamar API do fal.ai e baixar imagem usando node
OUTPUT_PATH="$OUTPUT_DIR/${FILENAME}.${OUTPUT_FORMAT}"

curl -s -X POST "https://fal.run/fal-ai/flux-pro/v1.1-ultra" \
  -H "Authorization: Key $FAL_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"prompt\": $JSON_PROMPT,
    \"image_size\": \"$IMAGE_SIZE\",
    \"output_format\": \"$OUTPUT_FORMAT\",
    \"num_images\": 1,
    \"guidance_scale\": 3.5,
    \"num_inference_steps\": 28
  }" | node -e "
const fs = require('fs');
const https = require('https');
const http = require('http');
let data = '';
process.stdin.on('data', chunk => data += chunk);
process.stdin.on('end', () => {
  try {
    const response = JSON.parse(data);
    if (!response.images || !response.images[0] || !response.images[0].url) {
      console.error('ERRO: Resposta inesperada da API:', data);
      process.exit(1);
    }
    const url = response.images[0].url;
    const mod = url.startsWith('https') ? https : http;
    mod.get(url, res => {
      const chunks = [];
      res.on('data', c => chunks.push(c));
      res.on('end', () => {
        const outputPath = process.argv[1];
        fs.writeFileSync(outputPath, Buffer.concat(chunks));
        const sizeKB = Math.round(Buffer.concat(chunks).length / 1024);
        console.error('Imagem salva: ' + outputPath + ' (' + sizeKB + 'KB)');
        console.log(outputPath);
      });
    }).on('error', err => {
      console.error('ERRO ao baixar imagem:', err.message);
      process.exit(1);
    });
  } catch (e) {
    console.error('ERRO ao processar resposta:', e.message);
    console.error('Resposta:', data);
    process.exit(1);
  }
});
" "$OUTPUT_PATH"
