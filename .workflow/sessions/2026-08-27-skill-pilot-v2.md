# Session 2026-08-27 (4) — Skill pilot v2

## Fait

- FORGE retiré partout (global CLAUDE.md, NEXUS, SLICE, DASHBOARD, dépôt FORGE archivé,
  todo-forge-test à la corbeille).
- Skill `pilot` réécrite avec skill-creator : `init` cadre (PRD), `feature` en deux temps
  (décisions + contrat de validation ; découpage disjoint avec fichiers et numéros de contrat),
  `run` (boucle : tdd-writer × n, verifier, correcteur, PR ; s'arrête aux PR), `next` route par
  statut Linear, `sync` apprend. Section FORGE supprimée. Gabarit MISSION dans `reference/`.
  Évaluation : 3 scénarios, ancienne 40 % → nouvelle 100 %, retours positifs.
- Réglage `Agents en parallèle : n` (défaut 1) lu par `run` ; `/goal` proposé avant `run`.
- PR ouvertes : pilot #4 (docs : run, backlog 11, /goal, réglage), sandbox #24 (réglage = 1).

## Décisions

- Commande de production : `run` (pas `livre`).
- Défaut 1 agent : tester en série avant de paralléliser.
- Projets hors Linear : régime « atelier » jusqu'au support d'état local (backlog 11).

## Prochaine étape

Cédric joue lui-même, dans pilotage-sandbox : `/pilot feature Facturation` (cadrage, puis
découpage), `/goal …`, `/pilot run Facturation`. Noter tout ce qui coince pour corriger la skill.

## Non fait

- Versionner la skill dans le dépôt pilot (`skills/pilot/`) : proposé, pas tranché.
- Optimisation automatique de la description de la skill : optionnel.
