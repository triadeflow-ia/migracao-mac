# PENDENTE — Falta o `pacote-secrets` (ler no Windows)

> Claude do **Windows**: o Alex rodou a migração no Mac novo em 2026-06-19. Quase tudo
> foi restaurado, **menos os secrets e os tokens dos MCP**. Tua tarefa é reempacotar e
> subir o que falta. Detalhes abaixo.
>
> **DECISÃO DO ALEX (2026-06-19): caminho A — trazer do Windows.** Reempacota o
> `pacote-secrets/` e sobe pro Drive (passos na seção "O QUE FAZER NO WINDOWS"). Não
> rotaciona/gera chaves novas — as atuais estão em uso nos deploys.
>
> Obs.: parte dos tokens JÁ chegou no Mac via memórias (`cloudflare-*`, `meta-token-path`,
> `sala-secreta*`) e via `Triadeflow-KB/.secrets.env`. O que falta é o bundle estruturado:
> os 10 JSONs de `claude-secrets/`, o `mcp-servers-com-tokens.json` e o `COMANDOS-MCP.md`.

## O que aconteceu no Mac

A migração restaurou com sucesso, a partir dos zips do Drive:

- `~/.claude` (CLAUDE.md, rules, 1234 skills, 41 agents, 53 commands, 7 hooks, settings)
- **473 memórias** + `MEMORY.md`
- `~/Triadeflow-KB` (2061 arquivos / 306 notas)
- `~/.flowhub` (32 itens)
- `~/Projetos` (156 pastas = 113 repos git clonados + 43 projetos locais)
- `node v24.16.0` presente

## O QUE FALTOU (o problema)

O **`pacote-secrets/` NÃO estava dentro de `migracao-mac-MAC.zip`**. O `CLAUDE.md` deste
repo afirma que o zip do cérebro inclui `pacote-secrets`, mas na prática ele só continha
`pacote-config/` (claude, flowhub, memory, Triadeflow-KB). Não havia:

- `pacote-secrets/home/` → `.secrets.env`, `.env`, `.gitconfig`, `.npmrc`
- `pacote-secrets/claude-secrets/` → os 10 JSONs de credencial (GHL, Stevo, Neon, Cloudflare, ElevenLabs...)
- `pacote-secrets/mcp-servers-com-tokens.json` → config dos 9 MCP servers COM as chaves
- `pacote-secrets/COMANDOS-MCP.md` → os comandos `claude mcp add ...`

Consequência: no Mac, os **MCP da nuvem (claude.ai)** já funcionam (Drive, Gmail, Asana,
Notion, n8n, Figma, Canva, Stripe, Vercel, etc.), mas os **MCP locais com token** e os
**secrets de projeto** ficaram de fora. O Passo 3 da migração está bloqueado por isso.

## O QUE FAZER NO WINDOWS

1. Reempacotar **só** o `pacote-secrets/` (os 4 itens acima) num zip novo, ex:
   `migracao-secrets-MAC.zip`.
2. Subir esse zip pra mesma pasta do Drive:
   https://drive.google.com/drive/folders/1anL6m3vo-A6IWPy9MN17ELf7CwzCivJd
3. **Avisar o Alex** que subiu. No Mac, o restante do restore dos secrets é:
   - copiar `pacote-secrets/home/.` → `~/`
   - copiar `pacote-secrets/claude-secrets/.` → `~/.claude/secrets/`
   - rodar os comandos do `COMANDOS-MCP.md` (precisa de `node`, já instalado)

## Observação sobre os downloads (importante)

Os 2 arquivos grandes do Drive (`migracao-mac-MAC.zip` e `migracao-projetos-MAC.zip`)
bateram em **"limite de download excedido"** do Google Drive (404 no download direto).
Resolveu fazendo o Alex baixar pelo navegador logado. Se reusar a pasta, considere subir
**cópias novas** (cota zerada) pra evitar a mesma trava.

---
*Registrado pelo Claude do Mac em 2026-06-19 durante a migração Windows -> Mac.*
