# Guia rápido – Diagnóstico e atualização de sites (Next/Vercel)

Carta de mim para mim: checklist reutilizável em qualquer repositório (Next.js /
Vercel / Node).

## 0) Pré-requisitos

- Node + npm instalados; nvm disponível para trocar versões.
- Acesso ao repositório Git e ao projeto Vercel.
- Ambiente com `.env.local` (ou equivalente) se necessário.

## 1) Diagnóstico rápido (script)

- No repositório do projeto, salvar/atualizar `scripts/diag-vercel.sh`.
- Tornar executável: `chmod +x scripts/diag-vercel.sh`.
- Executar no diretório do app:
  ```bash
  ./scripts/diag-vercel.sh
  ```
- Revisar o relatório gerado (`diag_al-*.txt`) nas seções:
  - Git status (mudanças locais / branch / divergência do remoto)
  - Dependências críticas (next/react/tailwind/etc.)
  - Auditoria (`npm audit`)
  - Outdated (`npm outdated`)
  - Scripts/engines (dev/build/start/lint + engine node)
  - Lint/Build (se executados)

## 2) Versão de Node

- Verificar nvm instalado e versões:
  ```bash
  command -v nvm && nvm --version && nvm ls
  ```
- Ajustar default se necessário (ex.: usar LTS alvo):
  ```bash
  nvm install 24.11.1
  nvm use 24.11.1
  nvm alias default 24.11.1
  ```
- No projeto, alinhar engines (se for política do time): adicionar em
  `package.json`:
  ```json
  "engines": { "node": "24.x" }
  ```
  (ou outra versão alvo). Lembrar que isso “fail-fast” quando a Vercel subir de
  versão.

## 3) Dependências

- Rodar `npm install` (ou `npm ci` se lockfile estável).
- Atualizar patches/minors relevantes reportados no `npm outdated`
  (Next/React/Tailwind/ESLint/etc.).
- Após updates: `npm run lint` e `npm run build`.
- Garantir `npm audit` sem vulnerabilidades (ou registrar exceções se
  necessário).

## 4) Assets e público

- Garantir que pastas `public/` e contratos LLM (`public/llm/**`) estão
  versionados quando necessário (ex.: PDFs, llm.txt, AGENTS.md).
- Evitar `.nvmrc` se o time preferir configurar via shell; caso contrário, pin
  explícito.

## 5) Commit e push

- `git status` → revisar mudanças.
- `git add .` (ou selecionar arquivos conforme policy).
- Commits em Conventional Commits (ex.:
  `chore(site): update deps and sync public assets` ou
  `chore(site): set engines node 24.x`).
- `git push origin <branch>` (geralmente `main`/`master`).

## 6) Vercel

- Confirmar projeto ligado ao branch correto.
- Se houver engines declarados, Vercel seguirá; caso não, Vercel pode mudar
  versão quando o default mudar.
- Verificar logs de deploy após o push; se falhar, checar engines/lockfile.

## 7) Fluxo resumido para cada repositório

1. Rodar `./scripts/diag-vercel.sh` → ler relatório.
2. Ajustar Node (nvm use/alias) e, se necessário, engines no `package.json`.
3. Atualizar deps (patch/minor), `npm run lint`, `npm run build`, `npm audit`.
4. Garantir assets/contratos públicos versionados conforme policy.
5. Commit + push (Conventional Commits).
6. Conferir deploy na Vercel.

## 8) Notas finais

- Engines travam versão (bom para previsibilidade); se quiser absorver upgrades
  automáticos, não defina engines e monitore o default da Vercel.
- Se Vercel atualizar major (ex.: 24→25), ajustar `engines` e testar local com
  nvm antes do push.
