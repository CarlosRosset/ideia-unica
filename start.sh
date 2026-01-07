#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if ! command -v npm >/dev/null 2>&1; then
  echo "Erro: npm não encontrado. Instale Node.js 24+ (npm incluso)." >&2
  exit 1
fi

if [ ! -d "node_modules" ]; then
  echo "Instalando dependências (npm ci)..."
  npm ci
fi

PORT="${PORT:-3000}"
echo "Iniciando em modo dev na porta ${PORT}..."
npm run dev -- --port "${PORT}"
