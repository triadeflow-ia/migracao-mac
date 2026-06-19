# MIGRAÇÃO WINDOWS → MAC — INSTRUÇÕES PARA O CLAUDE

Você (Claude) está rodando no Mac novo do Alex. Sua tarefa é **restaurar todo o ambiente
Claude Code** que veio do PC Windows dele.

**Regras de conduta:**
- Fale português com o Alex.
- Execute UM passo por vez. Mostre o comando, rode, mostre o resultado, confirme que deu
  certo, só então siga pro próximo.
- Nunca improvise com os dados/credenciais dele. Se algo divergir do esperado, **pare e
  pergunte** em vez de adivinhar.
- Os comandos abaixo assumem que os downloads estão em `~/Downloads`. Se estiverem em
  outro lugar, ajuste os caminhos.

---

## Contexto — o que está sendo restaurado

No PC Windows, o ambiente do Alex foi empacotado em **3 zips + 1 script**, que ele já
baixou do Google Drive (manualmente, pelo navegador). São eles:

| Arquivo baixado | Tamanho | Vira o quê no Mac |
|---|---|---|
| `migracao-mac-MAC.zip` | 72 MB | O "cérebro": `~/.claude`, memória, `~/.flowhub`, `~/Triadeflow-KB`, secrets |
| `migracao-projetos-MAC.zip` | 57 MB | 44 projetos SEM git → `~/Projetos` |
| `migracao-projetos-locais-MAC.zip` | 38 MB | 7 repos locais (têm `.git`, sem remote) → `~/Projetos` |
| `clonar-projetos-no-mac.sh` | ~12 KB | Script que clona os 113 projetos que têm git |

Dentro do `migracao-mac-MAC.zip` há esta estrutura (você vai ver depois de descompactar):
```
restaurar-no-mac.command     <- o script que faz a restauração
LEIA-PRIMEIRO.md
pacote-config/               <- 13.124 arquivos (config, skills, agents, memória, KB, flowhub)
  claude/                    -> copiado pra ~/.claude/
  memory/                    -> copiado pra ~/.claude/projects/<slug-do-mac>/memory/
  flowhub/                   -> copiado pra ~/.flowhub/
  Triadeflow-KB/             -> copiado pra ~/Triadeflow-KB/
pacote-secrets/              <- 16 arquivos (AS KEYS ESTÃO AQUI)
  COMANDOS-MCP.md            <- comandos prontos pra religar os 9 MCP (tokens preenchidos)
  mcp-servers-com-tokens.json
  claude-secrets/*.json      -> copiado pra ~/.claude/secrets/
  home/{.env,.secrets.env,.gitconfig,.npmrc} -> copiado pra ~/
```

**ATENÇÃO — leia isto antes de começar:** os secrets (keys) **VÊM no zip**, dentro de
`pacote-secrets/`. Mas religar os MCP servers é um **passo manual** (Passo 4). O script de
restauração copia os arquivos de secret, porém NÃO religa os MCP sozinho. Se você pular o
Passo 4, vai parecer que "as keys não vieram" — não é verdade, elas só não foram aplicadas
ainda.

---

## Pré-requisitos

Verifique o que já existe e instale o que faltar:

```bash
# Homebrew (gerenciador de pacotes do Mac). Se faltar, instale em https://brew.sh
which brew || echo "FALTA Homebrew — instale antes de continuar"

# Node (necessário pros MCP servers que usam npx)
node -v || brew install node
```

---

## Passo 0 — Confirmar que os 4 downloads existem

```bash
ls -lh ~/Downloads/migracao-mac-MAC.zip \
       ~/Downloads/migracao-projetos-MAC.zip \
       ~/Downloads/migracao-projetos-locais-MAC.zip \
       ~/Downloads/clonar-projetos-no-mac.sh
```

Devem aparecer os 4 com os tamanhos da tabela acima. Se algum faltar ou estiver com 0 KB,
peça ao Alex pra rebaixar do Drive. Se estiverem em outra pasta, descubra onde:
```bash
find ~ -name "migracao-mac-MAC.zip" 2>/dev/null
```
e ajuste os caminhos dos próximos passos.

---

## Passo 1 — Descompactar o cérebro

Descompacte para uma pasta dedicada. **Isto importa:** o script precisa rodar de dentro da
pasta onde estão `pacote-config/` e `pacote-secrets/` lado a lado com ele.

```bash
cd ~/Downloads
rm -rf migracao-mac                       # limpa tentativa anterior, se houver
unzip -o migracao-mac-MAC.zip -d migracao-mac
```

Confirme a estrutura (tem que listar `restaurar-no-mac.command`, `pacote-config`, `pacote-secrets`):
```bash
ls -la ~/Downloads/migracao-mac
```

Se em vez disso aparecer mais uma pasta aninhada (ex.: `migracao-mac/migracao-mac-MAC/...`),
ache o nível certo — é onde está o `restaurar-no-mac.command`:
```bash
find ~/Downloads/migracao-mac -name "restaurar-no-mac.command"
```
Use ESSA pasta como `BASE` nos próximos passos.

---

## Passo 2 — Rodar a restauração do cérebro

```bash
cd ~/Downloads/migracao-mac               # a pasta que contém o restaurar-no-mac.command
chmod +x restaurar-no-mac.command
./restaurar-no-mac.command
```

O que o script faz (leia a saída dele com atenção):
- faz backup do `~/.claude/settings.json` se já existir (`.bak-migracao`);
- copia `pacote-config/claude/` → `~/.claude/` (CLAUDE.md, rules, skills, agents, commands,
  hooks, settings.json com paths já em `$HOME`);
- copia a memória → `~/.claude/projects/<slug-do-seu-home>/memory/` e imprime quantos itens;
- copia `~/.flowhub` e `~/Triadeflow-KB`;
- dá `chmod +x` nos scripts `.sh` de hooks/scripts/flowhub;
- copia os secrets: `pacote-secrets/claude-secrets/` → `~/.claude/secrets/` e
  `pacote-secrets/home/` → `~/`.

**Verifique a saída:** se aparecer a linha `==> pacote-secrets nao encontrado aqui`, o script
rodou de um diretório errado e PULOU os secrets. Nesse caso, vá ao Passo 4.3 (cópia manual).
Se aparecer `==> Copiando secrets ... secrets instalados`, os secrets foram pro lugar certo.

---

## Passo 3 — Validar o cérebro

```bash
# CLAUDE.md global do Alex existe?
test -f ~/.claude/CLAUDE.md && echo "OK CLAUDE.md" || echo "FALTA CLAUDE.md"

# Quantos arquivos de memória? (esperado ~470)
ls ~/.claude/projects/*/memory 2>/dev/null | wc -l

# KB e flowhub
test -d ~/Triadeflow-KB && echo "OK KB" || echo "FALTA KB"
test -d ~/.flowhub && echo "OK flowhub" || echo "FALTA flowhub"

# Secrets copiados?
ls -la ~/.claude/secrets/ 2>/dev/null
ls -la ~/.secrets.env ~/.env 2>/dev/null
```

Se a memória vier muito abaixo de ~470 ou o CLAUDE.md faltar, pare e avise o Alex — a
restauração não completou.

---

## Passo 4 — Religar os 9 MCP servers (MANUAL — é aqui que costuma travar)

### 4.1 — Localizar o arquivo de comandos
```bash
find ~ -name "COMANDOS-MCP.md" 2>/dev/null
```
Deve achar em `~/Downloads/migracao-mac/pacote-secrets/COMANDOS-MCP.md`.

### 4.2 — Ler e executar
Abra o arquivo, leia, e rode **cada** comando `claude mcp add ...` que está nele. São 9
servers (5 HTTP simples, 2 GHL com header de token, 2 stdio com env de chave). Os tokens já
estão preenchidos no arquivo — não precisa pedir nada ao Alex, e **não cole o conteúdo desse
arquivo em nada público** (tem Stripe `rk_live` e PITs do GHL).

```bash
cat ~/Downloads/migracao-mac/pacote-secrets/COMANDOS-MCP.md
# depois rode, um a um, os comandos "claude mcp add" listados ali
```

Se algum `claude mcp add` der erro de sintaxe, rode `claude mcp add --help` (a sintaxe muda
com a versão) e adapte. Não invente tokens — use só os que estão no arquivo.

### 4.3 — Se os secrets NÃO foram copiados no Passo 2
(Só faça isto se o `ls ~/.claude/secrets/` do Passo 3 veio vazio.)
```bash
cd ~/Downloads/migracao-mac           # ou a BASE que você achou no Passo 1
cp -R pacote-secrets/claude-secrets/. ~/.claude/secrets/
cp -R pacote-secrets/home/. ~/
```

### 4.4 — Confirmar
```bash
claude mcp list
```
Devem aparecer os 9 servers. Se algum ficar com status de erro, me diga qual e o erro.

---

## Passo 5 — Restaurar os projetos

```bash
mkdir -p ~/Projetos

# 44 projetos sem git:
unzip -o ~/Downloads/migracao-projetos-MAC.zip -d ~/Projetos

# 7 repos locais (têm .git, sem remote — só existem aqui, não dá pra clonar):
unzip -o ~/Downloads/migracao-projetos-locais-MAC.zip -d ~/Projetos

# 113 projetos com git — clona do GitHub:
cd ~/Projetos
bash ~/Downloads/clonar-projetos-no-mac.sh
```

Se algum `git clone` falhar por autenticação, confira `gh auth status` (ou `git config`).
Os repos são da conta `triadeflow-ia`. Continue os demais e reporte os que falharam ao final.

---

## Passo 6 — Validação final

```bash
echo "Memória:"; ls ~/.claude/projects/*/memory 2>/dev/null | wc -l
echo "MCP:";      claude mcp list
echo "Projetos:"; ls ~/Projetos | wc -l
test -f ~/.claude/CLAUDE.md && echo "CLAUDE.md OK"
test -d ~/Triadeflow-KB && echo "KB OK"
```

Resuma pro Alex: quantos memory files, quantos MCP ativos, quantos projetos, e o que (se
algo) falhou.

---

## Passo 7 — CRÍTICO: limpar a nuvem

Quando tudo estiver validado, avise o Alex pra:
1. **Apagar a pasta do Google Drive** — os zips contêm tokens LIVE (Stripe `rk_live`, PITs GHL).
2. Opcional: apagar este repo público: `gh repo delete triadeflow-ia/migracao-mac`.

---

## Troubleshooting rápido

- **"As keys/secrets não vieram"** → Mito. Elas estão em
  `~/Downloads/migracao-mac/pacote-secrets/`. O que falta é rodar o Passo 4 (religar MCP) e,
  se necessário, a cópia manual do 4.3.
- **Script disse "pacote-secrets nao encontrado aqui"** → Você rodou o `.command` de fora da
  pasta certa. Volte ao Passo 1, ache a pasta com `restaurar-no-mac.command` e rode de lá.
- **Memória com poucos arquivos** → Provável `pacote-config/memory` não copiado; confira se o
  unzip do Passo 1 completou sem erro e rode o script de novo.
- **`claude mcp add` falha** → `claude mcp add --help` e adapte a sintaxe à versão instalada.

## Pastas pesadas que NÃO vieram (Alex decide depois)
`_organizar` (893MB), `raspagem-imersao-claude-code` (378MB), `otavio-personal` (286MB),
`shots` (46MB). Ficaram no Windows; vão por transporte separado se ele precisar.
