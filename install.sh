#!/usr/bin/env bash
#
# Installe la méthode pilot dans un projet.
#
#   ./install.sh <chemin du projet>
#
# Copie les fiches d'agent, la skill pilot et les outils dans <projet>/.claude/.
# Sert aussi bien à la première pose qu'à une mise à jour : les fichiers du projet sont
# alignés sur la version de ce dépôt, qui fait foi.
#
# Après l'installation, le projet contient sa propre copie de la méthode. Elle est
# versionnée avec lui : chaque membre du projet travaille avec la même.

set -euo pipefail

SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ $# -ne 1 ]; then
  echo "Usage : $0 <chemin du projet>" >&2
  exit 1
fi

PROJET="$(cd "$1" 2>/dev/null && pwd)" || { echo "Dossier introuvable : $1" >&2; exit 1; }

if [ ! -d "$PROJET/.git" ]; then
  echo "« $PROJET » n'est pas un dépôt git." >&2
  echo "La méthode se versionne avec le projet : sans dépôt, l'installation n'a pas de sens." >&2
  exit 1
fi

if [ ! -d "$SOURCE/implementation" ]; then
  echo "« $SOURCE/implementation » est introuvable. Lancer ce script depuis le dépôt pilot." >&2
  exit 1
fi

VERSION="$(git -C "$SOURCE" rev-parse --short HEAD 2>/dev/null || echo inconnu)"
DATE="$(date +%F)"

echo "Source  : $SOURCE (version $VERSION)"
echo "Projet  : $PROJET"
echo

mkdir -p "$PROJET/.claude"

# rsync --delete aligne la destination sur la source. Les chemins exclus ne sont ni
# copiés ni supprimés : les dépendances déjà installées dans le projet survivent.
copier() {
  local quoi="$1"
  mkdir -p "$PROJET/.claude/$quoi"
  rsync -a --delete \
    --exclude='__pycache__' --exclude='*.pyc' \
    --exclude='.DS_Store' --exclude='node_modules' \
    "$SOURCE/implementation/$quoi/" "$PROJET/.claude/$quoi/"
  echo "  .claude/$quoi"
}

echo "Installé :"
copier agents
copier skills
copier tools

cat > "$PROJET/.claude/METHODE.md" <<EOF
# Méthode pilot — version installée

- Version : \`$VERSION\` (dépôt \`pilot\`)
- Installée le : $DATE

Ce dossier est une **copie**. La version de référence vit dans le dépôt \`pilot\`, dans
\`implementation/\`. Une amélioration de la méthode s'y fait, sur une branche, avec une PR.

Pour recevoir la dernière version dans ce projet :

\`\`\`bash
cd <dépôt pilot> && git pull && ./install.sh $PROJET
\`\`\`

Modifier les fichiers de ce dossier ne remonte nulle part, et la prochaine mise à jour
les écrase.
EOF
echo "  .claude/METHODE.md"

echo
if [ ! -d "$PROJET/.claude/tools/passe-visuelle/node_modules" ]; then
  echo "Reste à faire, une seule fois, pour que le testeur puisse prendre des captures :"
  echo "  cd \"$PROJET/.claude/tools/passe-visuelle\" && npm install"
  echo
fi
echo "La méthode est en place. Elle se commite avec le projet."
