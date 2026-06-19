# migracao-mac

Contexto e instruções pra restaurar o ambiente Claude Code do Alex: **PC Windows → Mac novo**.

Este repo é só texto. Os arquivos pesados (3 zips + 1 script) estão no Google Drive — o
Alex baixa eles manualmente, e o Claude do Mac usa estas instruções pra saber o que fazer.

## Como usar no Mac

1. Baixe os 4 arquivos da pasta do Drive:
   https://drive.google.com/drive/folders/1anL6m3vo-A6IWPy9MN17ELf7CwzCivJd
   (salve em `~/Downloads`)

2. Clone este repo e abra o Claude Code dentro dele:
   ```bash
   git clone https://github.com/triadeflow-ia/migracao-mac.git
   cd migracao-mac
   claude
   ```

3. Diga ao Claude: **"leia o CLAUDE.md e faça a migração"**.

   Ele localiza os arquivos baixados, restaura o cérebro (`.claude`, memória, skills, KB,
   secrets), descompacta/clona os projetos e religa os MCP servers. O passo a passo completo
   está em [`CLAUDE.md`](./CLAUDE.md).

## Depois de terminar

- **Apague a pasta do Google Drive** — os zips têm tokens LIVE.
- Pode apagar este repo: `gh repo delete triadeflow-ia/migracao-mac`.
