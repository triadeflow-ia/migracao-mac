# migracao-mac

Restauração do ambiente Claude Code do Alex: **PC Windows → Mac novo**.

Este repo é leve — só instruções e o script de download. Os arquivos pesados
(72+57+38 MB) estão no Google Drive.

## Como usar no Mac

1. Clone este repo e entre na pasta:
   ```bash
   git clone https://github.com/triadeflow-ia/migracao-mac.git
   cd migracao-mac
   ```

2. Abra o Claude Code dentro dessa pasta:
   ```bash
   claude
   ```

3. Diga ao Claude: **"leia o CLAUDE.md e execute a migração"**.

   Ele vai: baixar os zips do Drive → restaurar o cérebro (.claude, memória, skills,
   KB, secrets) → descompactar/clonar os projetos → religar os MCP servers.

Se preferir fazer na mão, o passo a passo completo está em [`CLAUDE.md`](./CLAUDE.md).

## Conteúdo

| Arquivo | O quê |
|---|---|
| `CLAUDE.md` | Instruções que o Claude do Mac executa (passo a passo completo) |
| `baixar-do-drive.sh` | Baixa os 4 arquivos da pasta do Drive (usa `gdown`) |
| `README.md` | Este arquivo |

## Depois de terminar

- **Apague a pasta do Google Drive** — os zips têm tokens LIVE.
- Pode apagar este repo também: `gh repo delete triadeflow-ia/migracao-mac`.
