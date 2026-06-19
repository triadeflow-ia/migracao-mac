# migracao-mac

Passo a passo pra restaurar o ambiente Claude Code do Alex: **PC Windows → Mac novo**.

Este repo é só texto (instruções). Os arquivos pesados (3 zips + 1 script) estão no Google
Drive — o Alex baixa eles manualmente, e o Claude do Mac usa o [`CLAUDE.md`](./CLAUDE.md)
pra saber exatamente o que fazer com cada um.

## Como usar no Mac

1. **Baixe os 4 arquivos** da sua pasta do Google Drive e salve em `~/Downloads`:
   - `migracao-mac-MAC.zip` (72 MB) — o cérebro
   - `migracao-projetos-MAC.zip` (57 MB)
   - `migracao-projetos-locais-MAC.zip` (38 MB)
   - `clonar-projetos-no-mac.sh`

   (O link do Drive não fica neste repo de propósito — os zips têm tokens, e o repo é público.)

2. **Clone este repo e abra o Claude Code dentro dele:**
   ```bash
   git clone https://github.com/triadeflow-ia/migracao-mac.git
   cd migracao-mac
   claude
   ```

3. **Diga ao Claude:** *"leia o CLAUDE.md e faça a migração, um passo de cada vez"*.

   Ele segue os 7 passos do `CLAUDE.md`: confere os downloads → descompacta e restaura o
   cérebro (`.claude`, memória, KB, secrets) → valida → **religa os 9 MCP** (passo manual,
   é onde costuma travar) → restaura os projetos → validação final → lembra de limpar a nuvem.

## Importante

- **As keys vêm dentro do `migracao-mac-MAC.zip`** (na pasta `pacote-secrets/`). Religar os
  MCP é um passo manual — se for pulado, parece que "as keys não vieram", mas vieram.
- Depois de terminar: **apague a pasta do Google Drive** (tokens LIVE) e, se quiser, este
  repo (`gh repo delete triadeflow-ia/migracao-mac`).

Detalhe completo, comando por comando, com troubleshooting: [`CLAUDE.md`](./CLAUDE.md).
