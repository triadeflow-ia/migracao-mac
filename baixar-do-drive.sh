#!/usr/bin/env bash
# Baixa os 4 arquivos da migração da pasta do Google Drive do Alex.
# Requer: gdown (pip install gdown  OU  brew install gdown)
set -e

DEST="$HOME/migracao-download"
mkdir -p "$DEST"
cd "$DEST"

echo "==> Baixando pra $DEST"

# IDs dos arquivos no Drive (pasta 1anL6m3vo-A6IWPy9MN17ELf7CwzCivJd)
gdown 1DLn55H1GP7XIw8gY7WrXrWLLcGUhOVo7 -O migracao-mac-MAC.zip            # cérebro 72MB
gdown 1a9iIhnDxSD-W34wW-M0UrVVK3nj8eKAt -O migracao-projetos-MAC.zip        # projetos 57MB
gdown 1aF4QAQ3FuILj6vzT2sx1q9sNTLufS0Q3 -O migracao-projetos-locais-MAC.zip # locais 38MB
gdown 1MTh57qiHD9_cZu1U75eukKCbnUQJZaip -O clonar-projetos-no-mac.sh        # script clone

echo ""
echo "==> Pronto. Arquivos em $DEST:"
ls -lh "$DEST"
echo ""
echo "Próximo: descompactar e rodar restaurar-no-mac.command (ver CLAUDE.md Passo 2)"
