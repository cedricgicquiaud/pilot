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
# Le script ne touche qu'à ce qui lui appartient. Une skill, une fiche d'agent ou un outil
# propre au projet, posé à côté, n'est jamais supprimé.
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
METHODE="$PROJET/.claude/METHODE.md"

echo "Source  : $SOURCE (version $VERSION)"
echo "Projet  : $PROJET"
echo

mkdir -p "$PROJET/.claude/agents" "$PROJET/.claude/skills" "$PROJET/.claude/tools"

# --- Les fiches d'agent -----------------------------------------------------------------
#
# Elles vivent à plat dans .claude/agents/, à côté de fiches qui peuvent appartenir au
# projet. On ne peut donc pas aligner le dossier entier. La liste posée à l'installation
# précédente est relue dans METHODE.md : une fiche qui y était et n'est plus dans la méthode
# est retirée, les autres ne sont pas touchées.

FICHES=""
for f in "$SOURCE"/implementation/agents/*.md; do
  FICHES="$FICHES $(basename "$f")"
done

if [ -f "$METHODE" ]; then
  ANCIENNES="$(sed -n 's/^- fiche: //p' "$METHODE")"
  for vieille in $ANCIENNES; do
    case " $FICHES " in
      *" $vieille "*) ;;
      *) [ -f "$PROJET/.claude/agents/$vieille" ] && {
           mv "$PROJET/.claude/agents/$vieille" "$PROJET/.claude/agents/.$vieille.retiree"
           echo "  retirée : .claude/agents/$vieille (renommée, plus dans la méthode)"
         } ;;
    esac
  done
fi

echo "Installé :"
for f in $FICHES; do
  cp "$SOURCE/implementation/agents/$f" "$PROJET/.claude/agents/$f"
done
echo "  .claude/agents/ — $(echo $FICHES | wc -w | tr -d ' ') fiches"

# --- Les skills et les outils -----------------------------------------------------------
#
# Chacun est un dossier qui nous appartient en entier : rsync --delete l'aligne sur la
# source, y compris pour les fichiers retirés. Les dossiers voisins ne sont pas touchés.
# Les chemins exclus ne sont ni copiés ni supprimés : les dépendances déjà installées
# dans le projet survivent.

aligner() {
  local chemin="$1"
  mkdir -p "$PROJET/.claude/$chemin"
  rsync -a --delete \
    --exclude='__pycache__' --exclude='*.pyc' \
    --exclude='.DS_Store' --exclude='node_modules' \
    "$SOURCE/implementation/$chemin/" "$PROJET/.claude/$chemin/"
  echo "  .claude/$chemin"
}

for d in "$SOURCE"/implementation/skills/*/; do
  aligner "skills/$(basename "$d")"
done
for d in "$SOURCE"/implementation/tools/*/; do
  aligner "tools/$(basename "$d")"
done

# --- La trace ---------------------------------------------------------------------------

{
  echo "# Méthode pilot — version installée"
  echo
  echo "- Version : \`$VERSION\` (dépôt \`pilot\`)"
  echo "- Installée le : $DATE"
  echo
  echo "Fiches d'agent posées par l'installation — cette liste sert à retirer proprement"
  echo "une fiche qui sortirait de la méthode. Ne pas la modifier à la main."
  echo
  for f in $FICHES; do echo "- fiche: $f"; done
  echo
  cat <<EOF
Ce dossier est une **copie**. La version de référence vit dans le dépôt \`pilot\`, dans
\`implementation/\`. Une amélioration de la méthode s'y fait, sur une branche, avec une PR.

Pour recevoir la dernière version dans ce projet :

\`\`\`bash
cd <dépôt pilot> && git pull && ./install.sh $PROJET
\`\`\`

Modifier les fichiers de ce dossier ne remonte nulle part, et la prochaine mise à jour
les écrase.
EOF
} > "$METHODE"
echo "  .claude/METHODE.md"

echo
if [ ! -d "$PROJET/.claude/tools/passe-visuelle/node_modules" ]; then
  echo "Reste à faire, une seule fois, pour que le testeur puisse prendre des captures :"
  echo "  cd \"$PROJET/.claude/tools/passe-visuelle\" && npm install"
  echo
fi
echo "La méthode est en place. Elle se commite avec le projet."
