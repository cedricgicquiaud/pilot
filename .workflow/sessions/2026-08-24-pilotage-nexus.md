# Session 2026-08-23/24 — bac à sable achevé, pilotage branché sur Nexus

## Fait

### Bac à sable (Carnet, team TST — terminé et supprimé)
- Feature « Socle et comptes » livrée entière : 4 livraisons (PR #5-#8), 12 tâches,
  statuts automatiques à chaque merge, feature 25→50→75→100 % puis Terminée par sync.
- Barème recalibré : M = 0.15 h, L = 0.19 h ; feature L complète = 0.66 h de session
  sur 1 jour actif (vs 2.44 h prévues). Confirmation : le facteur limitant est le
  temps humain, pas le code.
- Team TST supprimée. Réponse au test de quota : impossible de supprimer la dernière
  team d'un workspace ; sinon la suppression libère la place.
- Piège découvert : les initiatives sont au niveau WORKSPACE — supprimer une team
  laisse ses initiatives orphelines (MVP, V2 supprimées à la main).

### Skill pilotage (~/.claude/skills/pilot/)
- Multi-workspace : linear_api.py `--workspace <slug>` / linear-<slug>.env,
  save-key.sh <slug>, init_team.py --workspace ; section Pilot nomme connexion + clé.
- MCP suffit pour le quotidien : statut de feature = save_project → state, dates =
  save_project/save_milestone (un collaborateur sans clé API joue feature/next/fix/sync ;
  la clé ne sert qu'à init et aux initiatives). GraphQL projectCreate : description ≤ 255 c.,
  corps long dans `content`.
- Projet à plusieurs : init copie la skill dans le dépôt (.claude/skills/pilot) + .mcp.json.
- Icônes/couleurs : palette par initiative (20 noms d'icônes API vérifiés) ; l'intérieur
  des barres de timeline n'est PAS colorable (vérifié à l'écran) — repères = pastille de
  statut, losanges de jalons (Display → Properties → Milestones), grouping par statut.
- sync pose les dates réelles (jalon = date du merge ; feature = 1re branche → dernier merge).
- Nouvelles règles : titre de feature = résultat lisible par un non-développeur ;
  « Terminé quand » = preuves spécifiques, jamais génériques.

### Nexus (team NEX, workspace agentos-tracker — compte unique conservé)
- init joué : team NEX complète ; PR #417 mergée (section Pilot dans CLAUDE.md,
  .pilot/calibration.md, skill embarquée, .mcp.json) ; NEX-1 Terminée automatiquement.
- Roadmap créée : initiative « MVP Guemini » (cible 06/02/2027) = 24 features historiques
  Terminées (dates réelles des 376 PR, 20/05→19/08) + 11 features de roadmap À cadrer
  (jalons datés 30/09 → 06/02, couloirs Cédric/Greg, tailles, priorités).
- Hors initiative : NEX-2→6 (dépendances externes, priorité Haute : DPA Circul'Egg,
  consentement DSI, tenant M365, compte Pennylane, VPS/DNS) + feature « Vitrine — lancement ».
- NEX-7 « Valider les intitulés de la roadmap » : 11 reformulations (titres résultat +
  descriptions réécrites) à faire valider par Greg. RIEN N'EST ENCORE RENOMMÉ.

## Prochaines étapes
1. Inviter Greg dans le workspace Linear ; chez lui : cloner, /mcp, s'authentifier.
2. À la validation de NEX-7 : appliquer les 11 renommages + réécritures, clore NEX-7.
3. Les 5 tâches non-dev NEX-2→6 (« cette semaine » selon la feuille de route).
4. « prochaine feature » → ouvrir « Staging et hébergement » (priorité Haute) ou
   « Contexte entreprise » : découpage en tâches à valider, puis livraisons.
5. FORGE : branche locale feature/linear-pilotage (2 commits) non poussée — à relire/pousser.
6. Test restant : deux workspaces Linear (nécessite un 2e compte, reporté).

## Repères
- Team NEX id b180d640-2b70-4631-bfd8-d7b8e7875f44 ; initiative MVP Guemini
  33b78273-27a7-40dc-95c8-616803b9f684 ; dépôt weme-studio/Nexus (~/Desktop/NEXUS).
- Fichiers locaux NEXUS non commités préexistants : .workflow/BACKLOG.md modifié,
  docs/product/*.md, .understandignore (pas à moi, ne pas toucher).
