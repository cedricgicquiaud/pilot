# Session 2026-08-28 — Retour aux sources, testeur, rapport de PR

## Décisions prises

- Relecture des trois vidéos contre ce qui est en place (§ 4 bis de `BOUCLE-AGENTS.md`).
  Ordre retenu : testeur dans la boucle → disjoncteur → épreuve des deux heures → Volt, puis
  Carnet à deux agents. Le mécanisme « Gate / Auditeur par type de projet » d'hier vient après.
- Disjoncteur sous abonnement Max : protège le quota, pas l'argent ; unité = tours + durée par
  mission, hook `PreToolUse`. Nécessaire avant de fermer l'écran, pas avant.
- Le testeur tourne **à chaque livraison, avant le merge**, limité aux cases de la livraison
  (le modèle à deux niveaux de merge est rejeté : trop compliqué). Il coche lui-même `UAT.md` ;
  case refusée = bloquant, correcteur, rejeu une fois, sinon PR « non mergeable ».
- La leçon « idiomes gravés → plus de faute » est nuancée : constat oui, causalité non prouvée
  (imitation du code corrigé possible). PR #6.
- Recherche (état de l'art) et contradicteur (second avis sur le cadrage), repris de FORGE
  phase FIND (`AlanZien/FORGE`, `01-find.md`, `03-spec.md`) : **backlog n° 13, plus tard**.
  Avec eux, la réduction à deux validations par feature (plan au début, produit à la fin, PR =
  clic) reste en attente. La validation à la PR reste dans tous les cas.
- Pilot n'est pas imposé (consigne, pas verrou). Linear s'utilise sans pilot. Pour un second
  développeur (Claude Code dans VS Code) : skill et agents dans le dépôt (`.claude/`), MCP
  Linear chez lui. Idée notée : `/pilot init` proposé une fois à l'ouverture d'un projet
  avec code (global / partagé / non). Non fait.

## Fait

- Agent `testeur` (`~/.claude/agents/testeur.md`) : essai à froid sur TST-25/26, 8/8, 15-20 min,
  un tiers en frictions d'outil (corrigées dans la fiche : serveur local, premier navigateur,
  champ mot de passe, déconnexion préalable).
- Skill `pilot` : `run` appelle `verifier` + `testeur` en parallèle, chevauchant la production
  suivante ; correcteur nourri des deux rapports ; `/goal` aligné ; rapport de PR au gabarit
  fixe en cinq blocs (verdict, prouvé, à relire, décisions, suite, technique replié) ;
  `init` pose `Lancer l'app :` / `Testeur :` ; `MISSION.template.md` : cases UAT non cochées.
  Vérifié ancienne/nouvelle version sur un cas lecture seule : 1/5 → 5/5.
- `BOUCLE-AGENTS.md` : brique testeur, § 4 bis écarts, backlog 11-13. PR #5 à #8 mergées,
  #9 ouverte.
- Sandbox : PR #33 (TST-52, démo Linear seul), #34 mergée (lignes Pilot), #32 en attente ;
  guide de démo publié (artefact « Démo Linear, puis Pilot »). Run Agenda lancé dans une
  autre session : livraison 1 en 40 min, testeur a déclenché une correction.

## À faire ensuite

1. Merger PR #9 ; supprimer le worktree `pilotage-sandbox-demo` après merge de #33.
2. Lire le rapport de la PR #35 (Agenda) : ce que le testeur a attrapé.
3. Disjoncteur (hook tours + durée) sur le sandbox, puis épreuve des deux heures.
4. Backlog 11 (profil Chrome tests), 13 (recherche + contradicteur) quand la boucle est stable.
5. Sync de la skill vers les projets qui l'embarqueront (Nexus, si décidé avec l'associé).
