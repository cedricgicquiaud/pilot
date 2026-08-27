
## Résultat du premier `run` réel (sandbox, Facturation, 27/08 après-midi)

- Cadrage : 10 décisions, contrat de 24 phrases (10 refus), 13 tâches TST-55 → 67, fichiers disjoints.
- Boucle en série (1 agent) : 5 PR (#25-29), 203 tests, TDD prouvé, 2 importants attrapés par
  l'audit et corrigés (syntaxe ui.js, injection CSV), 0 conflit, ~1,4 h en une instruction.
- Accroc : worktrees créés depuis la branche précédente → PR empilées mergées dans leur base,
  PR d'intégration #31 nécessaire. Skill corrigée (worktree depuis origin/main), leçon gravée.
- `sync` joué : 2 idiomes ajoutés au CLAUDE.md du sandbox (non commités, partent avec la PR suivante).
- Feature suivante déjà ouverte : TST-68 Interface propre (worktree pilotage-sandbox-6).
- Règles de rédaction de PR affinées : une puce par changement (« Ce qui change »), une idée par
  puce dans « Comment ». Propagées à pilot, rendu-fonctionnel, gabarit sandbox, document.
