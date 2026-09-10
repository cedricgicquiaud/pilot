#!/bin/sh
# Hook SubagentStart : ouvre un panneau cmux qui suit les grandes étapes de l'agent qui démarre.
# Reçoit sur l'entrée standard le JSON du hook (session_id, transcript_path, cwd, agent_id,
# agent_type). Sans cmux, ne fait rien. Ne bloque jamais l'agent : sort toujours en 0.
command -v cmux >/dev/null 2>&1 || exit 0
[ -n "$CMUX_WORKSPACE_ID" ] || exit 0
j=$(cat)
lire() { printf '%s' "$j" | python3 -c "import json,sys; print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }
session=$(lire session_id); transcript=$(lire transcript_path); agent=$(lire agent_id); cwd=$(lire cwd)
[ -n "$session" ] && [ -n "$transcript" ] && [ -n "$agent" ] || exit 0
journal="$(dirname "$transcript")/$session/subagents/agent-$agent.jsonl"
outil="$cwd/.claude/tools/cout-agents/cout-agents.py"
[ -f "$outil" ] || outil="$(dirname "$0")/cout-agents.py"
ref=$(cmux new-split down --focus false 2>/dev/null | grep -oE 'surface:[0-9]+' | head -1)
[ -n "$ref" ] || exit 0
cmux send --surface "$ref" "clear; python3 '$outil' --journal '$journal'; exit\n" >/dev/null 2>&1
exit 0
