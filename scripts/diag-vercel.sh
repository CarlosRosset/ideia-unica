#!/usr/bin/env bash
set -euo pipefail

OUT="./diag_ideia-unica_$(date +%Y%m%d_%H%M%S).txt"

# --- helpers ---
hr(){ printf "\n%s\n" "============================================================"; }
sec(){ hr; printf "## %s\n" "$1"; }
cmd(){
  local title="$1"; shift
  echo
  echo "$ $*"
  ( "$@" ) 2>&1 || echo "[WARN] comando falhou: $*"
}
file_head(){
  local f="$1"
  if [[ -f "$f" ]]; then
    echo
    echo "### FILE: $f"
    echo "-----"
    sed -n '1,220p' "$f" 2>/dev/null || true
    echo "-----"
  fi
}

exec > >(tee "$OUT") 2>&1

echo "DIAGNÓSTICO REPO (Next/Vercel) — ideia-unica"
echo "Data: $(date -Is)"
echo "Diretório: $(pwd)"
echo "Saída: $OUT"

sec "Git / Estado do repositório"
cmd "git status" git status -sb
cmd "git remote -v" git remote -v
cmd "git branch" git branch --show-current
cmd "últimos commits" git --no-pager log -n 12 --oneline --decorate

sec "SO / Node / Package manager / Tooling"
cmd "node -v" node -v
cmd "npm -v" npm -v
cmd "pnpm -v" pnpm -v
cmd "yarn -v" yarn -v
cmd "corepack" corepack --version
cmd "npx -v" npx -v

sec "Arquivos-chave do projeto (visão rápida)"
file_head "package.json"
file_head "package-lock.json"
pnpm_lock="pnpm-lock.yaml"
file_head "$pnpm_lock"
file_head "yarn.lock"
file_head "next.config.js"
file_head "next.config.mjs"
file_head "vercel.json"
file_head ".nvmrc"
file_head ".node-version"
tsconfig="tsconfig.json"
file_head "$tsconfig"
file_head "eslint.config.js"
file_head ".eslintrc.json"
file_head ".eslintrc"
file_head "middleware.ts"
file_head "middleware.js"

sec "Estrutura Next.js detectada"
echo
echo "Dirs:"
ls -la | sed -n '1,220p' || true
echo
echo "Possíveis pastas Next:"
for d in app pages src public; do
  [[ -d "$d" ]] && echo " - $d/ (OK)" || true
done

sec "Dependências críticas (extração direta do package.json)"
if [[ -f package.json ]]; then
  cmd "dependências críticas (grep)" bash -lc '
    node - <<'"'"'NODE'"'"'
const fs = require("fs");
const p = JSON.parse(fs.readFileSync("package.json","utf8"));
const all = {...(p.dependencies||{}), ...(p.devDependencies||{})};
const keys = [
  "next","react","react-dom","@vercel/analytics","@vercel/speed-insights",
  "typescript","eslint","@eslint/js",
  "tailwindcss","postcss","autoprefixer",
  "next-auth","@auth/core",
  "@supabase/supabase-js",
  "zod","axios","swr",
  "dotenv",
];
for (const k of keys) {
  if (all[k]) console.log(`${k}: ${all[k]}`);
}
NODE'
fi

sec "Lockfile: qual gerenciador está valendo"
if [[ -f pnpm-lock.yaml ]]; then echo "lockfile: pnpm-lock.yaml (pnpm)"; fi
if [[ -f yarn.lock ]]; then echo "lockfile: yarn.lock (yarn)"; fi
if [[ -f package-lock.json ]]; then echo "lockfile: package-lock.json (npm)"; fi

sec "Vercel / Build settings (inferência rápida)"
echo
echo "Procura por scripts no package.json:"
if [[ -f package.json ]]; then
  cmd "scripts do package.json" bash -lc '
    node - <<'"'"'NODE'"'"'
const fs=require("fs");
const p=JSON.parse(fs.readFileSync("package.json","utf8"));
console.log(p.scripts||{});
NODE'
fi
echo
echo "Procura por runtime/engine:"
if [[ -f package.json ]]; then
  cmd "engines do package.json" bash -lc '
    node - <<'"'"'NODE'"'"''"'"'
const fs=require("fs");
const p=JSON.parse(fs.readFileSync("package.json","utf8"));
console.log(p.engines||{});
NODE'
fi

sec "Auditoria (sem modificar dependências)"
# IMPORTANT: audit só funciona com npm/pnpm/yarn conforme o lockfile e setup.
# Vamos tentar o que existir e registrar.
if [[ -f package-lock.json ]]; then
  cmd "npm audit (json)" bash -lc 'npm audit --json | head -c 20000; echo; echo "[...] (truncado no terminal, relatório contém até 20k chars)"'
  cmd "npm audit (texto)" npm audit
fi
if [[ -f pnpm-lock.yaml ]]; then
  cmd "pnpm audit" pnpm audit
fi
if [[ -f yarn.lock ]]; then
  cmd "yarn audit" yarn audit
fi

sec "Outdated (o que está defasado) — sem atualizar"
if [[ -f package-lock.json ]]; then
  cmd "npm outdated" npm outdated
fi
if [[ -f pnpm-lock.yaml ]]; then
  cmd "pnpm outdated" pnpm outdated
fi
if [[ -f yarn.lock ]]; then
  cmd "yarn outdated" yarn outdated
fi

sec "Build & Lint (somente se node_modules existir)"
if [[ -d node_modules ]]; then
  echo "node_modules detectado: sim (executando lint/build)"
  # tenta rodar scripts padrão se existirem
  if [[ -f package.json ]]; then
    cmd "npm run -s lint" bash -lc 'npm run -s lint'
    cmd "npm run -s build" bash -lc 'npm run -s build'
  fi
else
  echo "node_modules NÃO detectado: pulando lint/build para evitar instalar deps"
  echo "Se você quiser, rode depois: npm ci && npm run build"
fi

sec "Busca rápida por padrões de risco (SSR/HTML injection)"
echo
echo "Procurando usos de dangerouslySetInnerHTML, eval, new Function:"
cmd "grep patterns" bash -lc '
  rg -n "dangerouslySetInnerHTML|\beval\b|new Function" . 2>/dev/null | head -n 200 || true
'

sec "Resumo final"
echo "Relatório gerado em: $OUT"
echo "Envie aqui o conteúdo das seções:"
echo " - Dependências críticas"
echo " - Auditoria"
echo " - Outdated"
echo " - engines/scripts"
echo "…e eu te digo exatamente o que a Vercel está acusando e qual é o menor ajuste necessário."
