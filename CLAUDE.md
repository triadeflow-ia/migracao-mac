# MIGRAÇÃO WINDOWS → MAC — INSTRUÇÕES PARA O CLAUDE

Você está rodando no Mac novo do Alex. Sua tarefa é **restaurar todo o ambiente
Claude Code** que veio do PC Windows dele. Tudo que você precisa está descrito aqui.

Fale português com o Alex. Vá executando os passos em ordem, confirmando cada um
antes de seguir. Se algo falhar, pare e explique — não improvise com os dados dele.

## Contexto

O "cérebro" do Claude Code do Alex (config, memória, skills, agents, KB, secrets) e
os projetos dele foram empacotados em 3 zips + 1 script e subidos no Google Drive.
Este repo só tem as instruções e os links. Os arquivos pesados estão no Drive.

## Pré-requisitos (instale se faltar)

```bash
# Homebrew (se não tiver): https://brew.sh
brew install node          # necessário pros MCP servers
pip install gdown          # OU: brew install gdown  — pra baixar do Drive
```

## Passo 1 — Baixar os arquivos do Drive

Os 4 arquivos estão na pasta Drive do Alex. Rode o script de download:

```bash
bash baixar-do-drive.sh
```

Isso baixa pra `~/migracao-download/`:
- `migracao-mac-MAC.zip` (72 MB) — o cérebro
- `migracao-projetos-MAC.zip` (57 MB) — 44 projetos sem git
- `migracao-projetos-locais-MAC.zip` (38 MB) — 7 repos locais sem remote
- `clonar-projetos-no-mac.sh` — clona os 113 projetos com git

Se o `gdown` falhar (arquivo privado / cota do Drive), peça ao Alex pra baixar os 4
manualmente pelo navegador e te dizer onde salvou.

## Passo 2 — Descompactar e restaurar o cérebro

```bash
cd ~/migracao-download
unzip -o migracao-mac-MAC.zip -d migracao-mac
cd migracao-mac
chmod +x restaurar-no-mac.command
./restaurar-no-mac.command
```

O `restaurar-no-mac.command` é um script que VEIO do Windows. Ele faz merge seguro:
copia `.claude` (CLAUDE.md, rules, skills, agents, commands, hooks, settings.json já
com paths em `$HOME`), os 470 memory files (calculando o slug do Mac), o `~/.flowhub`,
a KB Obsidian (`~/Triadeflow-KB`) e o `pacote-secrets`. **Leia o conteúdo dele antes de
rodar** pra confirmar que não sobrescreve nada importante que já exista no Mac.

## Passo 3 — Projetos

```bash
mkdir -p ~/Projetos

# 44 projetos sem git:
unzip -o ~/migracao-download/migracao-projetos-MAC.zip -d ~/Projetos

# 7 repos locais (têm .git mas não têm remote — só existem aqui):
unzip -o ~/migracao-download/migracao-projetos-locais-MAC.zip -d ~/Projetos

# 113 projetos com git (clona do GitHub):
cd ~/Projetos
bash ~/migracao-download/clonar-projetos-no-mac.sh
```

## Passo 4 — Religar os MCP servers

Depois do Passo 2, o `pacote-secrets/COMANDOS-MCP.md` estará disponível (procure em
`~/migracao-download/migracao-mac/pacote-secrets/COMANDOS-MCP.md`). Ele tem os comandos
`claude mcp add ...` com os tokens já preenchidos. Rode cada um. Precisa do `node`
(Passo de pré-requisitos).

## Passo 5 — Validar

- `~/.claude/CLAUDE.md` existe e tem as instruções globais do Alex
- A pasta de memory tem os 470 arquivos (rode `ls ~/.claude/projects/*/memory | wc -l`)
- `~/Triadeflow-KB` existe
- `claude mcp list` mostra os servers religados

## Passo 6 — CRÍTICO: limpar a nuvem

Avise o Alex pra **APAGAR a pasta do Google Drive** assim que tudo estiver validado.
Os zips contêm tokens LIVE (Stripe `rk_live`, GHL PITs). Enquanto estiverem no Drive,
são um risco. Esse repo do GitHub também pode ser apagado depois (`gh repo delete`).

## Pastas pesadas que NÃO vieram

4 pastas de mídia/dados ficaram pra trás no Windows (Alex decide o destino depois):
`_organizar` (893MB), `raspagem-imersao-claude-code` (378MB), `otavio-personal` (286MB),
`shots` (46MB). Se o Alex precisar delas, vão por transporte separado.
