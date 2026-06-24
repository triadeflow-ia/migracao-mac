# RESOLVIDO — o pacote-secrets estava no zip o tempo todo

> **Status (2026-06-19): RESOLVIDO no Mac. Nada a fazer no Windows.**

O `pacote-secrets/` **estava sim dentro do `migracao-mac-MAC.zip`** (junto do `pacote-config`),
exatamente como o `CLAUDE.md` deste repo avisa. O que tinha acontecido: o `unzip` abortou num
arquivo de nome acentuado da KB (`Triadeflow-KB/Sem título 1.base`, erro "write error")
**antes** de chegar no `pacote-secrets`, então ele não foi extraído na primeira passada e
pareceu ausente.

Correção aplicada no Mac: re-extrair só `pacote-secrets/*` do zip e seguir o passo de secrets
do `restaurar-no-mac.command` manualmente:

- 9 JSONs de credencial -> `~/.claude/secrets/`
- `home/.env`, `.secrets.env`, `.npmrc` -> `~/` (o `.gitconfig` do Windows foi IGNORADO
  de propósito: tinha `helper = manager-core` e caminhos `C:\` que quebrariam o git do Mac)
- os 10 MCP locais religados via `COMANDOS-MCP.md` (`claude mcp add`). Ajustes feitos:
  - sintaxe `-e KEY=val` (não `--env`) e o nome do server ANTES do `-e`
  - Stripe: pacote novo usa `STRIPE_SECRET_KEY` e removeu o flag `--tools=all`

## Lição pra próxima migração
No empacotador do Windows, evitar nomes de arquivo com caracteres especiais
(os `Sem título*.base/.canvas` do Obsidian) OU extrair no Mac com `ditto -x -k`, que lida
melhor com encoding e não aborta a extração no meio.
