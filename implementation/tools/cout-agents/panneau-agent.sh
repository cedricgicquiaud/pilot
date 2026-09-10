#!/bin/sh
# Hook SubagentStart : ouvre un panneau cmux qui suit les grandes étapes de l'agent qui démarre.
# Reçoit sur l'entrée standard le JSON du hook (session_id, transcript_path, cwd, agent_id,
# agent_type). Sans cmux, ne fait rien. Ne bloque jamais l'agent : sort toujours en 0.
#
# Disposition : le premier panneau s'ouvre à droite de la session ; les suivants s'ouvrent sous
# le dernier panneau d'agent, pour former une colonne. Le panneau porte le nom de l'agent en
# titre, et son flux s'affiche dans la couleur de sa fiche (`color:`).
command -v cmux >/dev/null 2>&1 || exit 0
[ -n "$CMUX_WORKSPACE_ID" ] || exit 0
j=$(cat)
lire() { printf '%s' "$j" | python3 -c "import json,sys; print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
session=$(lire session_id); transcript=$(lire transcript_path); agent=$(lire agent_id); cwd=$(lire cwd); type=$(lire agent_type)
[ -n "$session" ] && [ -n "$transcript" ] && [ -n "$agent" ] || exit 0
journal="$(dirname "$transcript")/$session/subagents/agent-$agent.jsonl"
outil="$cwd/.claude/tools/cout-agents/cout-agents.py"
[ -f "$outil" ] || outil="$(dirname "$0")/cout-agents.py"
couleur=$(sed -n 's/^color: *//p' "$cwd/.claude/agents/$type.md" 2>/dev/null | head -1)

# le dernier panneau d'agent ouvert dans cet espace de travail, s'il vit encore
etat="${TMPDIR:-/tmp}/pilot-panneau-$(printf '%s' "$CMUX_WORKSPACE_ID" | tr -c 'A-Za-z0-9' '_')"
dernier=$(cat "$etat" 2>/dev/null)
ref=""
if [ -n "$dernier" ]; then
  ref=$(cmux new-split down --surface "$dernier" --focus false 2>/dev/null | grep -oE 'surface:[0-9]+' | head -1)
fi
if [ -z "$ref" ]; then
  ref=$(cmux new-split right --surface "${CMUX_SURFACE_ID:-}" --focus false 2>/dev/null | grep -oE 'surface:[0-9]+' | head -1)
fi
[ -n "$ref" ] || exit 0
printf '%s' "$ref" > "$etat"
cmux send --surface "$ref" "clear; python3 '$outil' --journal '$journal' --couleur '$couleur'; exit\n" >/dev/null 2>&1
exit 0
