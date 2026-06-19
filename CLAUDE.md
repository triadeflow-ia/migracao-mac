# MIGRAÇÃO WINDOWS → MAC — INSTRUÇÕES PARA O CLAUDE

Você está rodando no Mac novo do Alex. Sua tarefa é **restaurar todo o ambiente
Claude Code** que veio do PC Windows dele.

Fale português com o Alex. Vá executando os passos em ordem, confirmando cada um antes
de seguir. Se algo falhar, pare e explique — nunca improvise com os dados/credenciais dele.

## Contexto

O "cérebro" do Claude Code do Alex (config, memória, skills, agents, KB, secrets) e os
projetos dele foram empacotados no PC Windows em 3 zips + 1 script, e estão no Google Drive.

**O Alex vai baixar os 4 arquivos manualmente** pelo navegador, da pasta do Drive:
https://drive.google.com/drive/folders/1anL6m3vo-A6IWPy9MN17ELf7CwzCivJd

Os 4 arquivos:
| Arquivo | Tamanho | O quê |
|---|---|---|
| `migracao-mac-MAC.zip` | 72 MB | O cérebro: `~/.claude`, 470 memory files, `~/.flowhub`, KB Obsidian, `pacote-secrets` |
| `migracao-projetos-MAC.zip` | 57 MB | 44 projetos SEM git |
| `migracao-projetos-locais-MAC.zip` | 38 MB | 7 repos com `.git` mas SEM remote (só existem local) |
| `clonar-projetos-no-mac.sh` | — | Script que clona os 113 projetos que têm git |

## Passo 0 — Localizar os arquivos baixados

Pergunte ao Alex onde ele salvou os downloads (provavelmente `~/Downloads`). Confirme que
os 4 arquivos estão lá antes de continuar:
```bash
ls -lh ~/Downloads/migracao-*.zip ~/Downloads/clonar-projetos-no-mac.sh
```
Se não achar, peça o caminho certo. Os comandos abaixo assumem `~/Downloads` — ajuste se for outro.

## Pré-requisitos (instale se faltar)

```bash
# Homebrew (se não tiver): https://brew.sh
brew install node     # necessário pros MCP servers
```

## Passo 1 — Restaurar o cérebro

```bash
cd ~/Downloads
unzip -o migracao-mac-MAC.zip -d migracao-mac
cd migracao-mac
chmod +x restaurar-no-mac.command
./restaurar-no-mac.command
```

O `restaurar-no-mac.command` VEIO do Windows e faz merge seguro: copia `.claude`
(CLAUDE.md, rules, skills, agents, commands, hooks, settings.json já com paths em `$HOME`),
os 470 memory files (calculando o slug do Mac), o `~/.flowhub`, a KB Obsidian
(`~/Triadeflow-KB`) e o `pacote-secrets`. **Leia o conteúdo do script antes de rodar** pra
confirmar que não sobrescreve nada que já exista no Mac.

## Passo 2 — Projetos

```bash
mkdir -p ~/Projetos

# 44 projetos sem git:
unzip -o ~/Downloads/migracao-projetos-MAC.zip -d ~/Projetos

# 7 repos locais (têm .git mas não têm remote — só existem aqui):
unzip -o ~/Downloads/migracao-projetos-locais-MAC.zip -d ~/Projetos

# 113 projetos com git (clona do GitHub):
cd ~/Projetos
bash ~/Downloads/clonar-projetos-no-mac.sh
```

## Passo 3 — Religar os MCP servers

Depois do Passo 1, o arquivo de comandos estará em
`~/Downloads/migracao-mac/pacote-secrets/COMANDOS-MCP.md`. Ele tem os comandos
`claude mcp add ...` com os tokens já preenchidos. Rode cada um. Precisa do `node`.

## Passo 4 — Validar

- `~/.claude/CLAUDE.md` existe e tem as instruções globais do Alex
- A memória tem os arquivos: `ls ~/.claude/projects/*/memory | wc -l` (esperado ~470)
- `~/Triadeflow-KB` existe
- `claude mcp list` mostra os servers religados

## Passo 5 — CRÍTICO: limpar a nuvem

Avise o Alex pra **APAGAR a pasta do Google Drive** assim que tudo estiver validado.
Os zips contêm tokens LIVE (Stripe `rk_live`, GHL PITs). Este repo do GitHub também pode
ser apagado depois (`gh repo delete triadeflow-ia/migracao-mac`).

## Pastas pesadas que NÃO vieram

4 pastas de mídia/dados ficaram no Windows (Alex decide o destino depois):
`_organizar` (893MB), `raspagem-imersao-claude-code` (378MB), `otavio-personal` (286MB),
`shots` (46MB).
