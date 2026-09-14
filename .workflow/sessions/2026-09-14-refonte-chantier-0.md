# Session du 14 septembre 2026 — analyse de `mattpocock/skills` et chantier 0 de la refonte

## Fait

- Analyse complète du dépôt `mattpocock/skills` (v1.2.3, 37 skills, 25 promues) :
  `sources/analyse-repo-2026-09-14-mattpocock-skills.md`. Verdict : on garde PILOT (circuit,
  agents, merge humain), on réécrit ses textes à sa manière (fiches courtes, un « fini
  quand » par étape, référence déportée, mots-ancres), et on lui emprunte quatre briques
  telles quelles.
- Copie figée de ses skills utiles dans `sources/mattpocock-skills-1.2.3/` (MIT).
- `GRILLE-DE-RELECTURE.md` : les huit questions à poser à chaque phrase d'une fiche, les
  règles de langue (français, cinq mots-ancres anglais au plus), comment rejouer une fiche.
- Étalon archivé : `sources/etalon-TST-B1-etiquettes-de-contact.md` (mission + mesures du
  10/09). Pas de nouvelle mesure jouée : celle du 10/09 sert de référence.
- Branche `refonte/0-grille-et-etalon`, PR ouverte.

## Décidé

- Six chantiers, une PR chacun, testés sur `Projects/pilotage-sandbox` avant tout vrai
  projet : 0 grille et étalon ; 1 verrou git (hook `PreToolUse` : push sur `main`/`release`,
  `--force`, `gh pr merge`) ; 2 import tel quel de `diagnosing-bugs`,
  `resolving-merge-conflicts`, `to-questionnaire` ; 3 réécriture de `pilot/SKILL.md`
  (3 316 mots → moins de 1 000) ; 4 greffes (entretien façon `grilling`, verifier en deux
  axes + smells, anti-patterns de test pour le tdd-writer, `CONTEXT.md` + ADR posés par
  `init`, catégories de `retro` pour `sync`) ; 5 réécriture des six fiches d'agent, une par
  PR ; 6 documentation.
- Langue : fiches en français ; mots-ancres en anglais, en italique, cinq au plus par fiche ;
  skills importées gardent leur corps en anglais, description avec déclencheurs français.
- Ce qu'on ne copie pas : la chaîne manuelle de Matt, son tracker GitHub/Markdown,
  `implement-spec` (merge automatique), la suppression du refactor dans la boucle TDD.
- PILOT reste hors pilotage Linear pour ces chantiers (question posée, pas de réponse ;
  branches + sessions comme aujourd'hui).

## Chantier 1 — le verrou git (même jour, après le merge de la PR #44)

- `implementation/tools/verrou-git/verrou-git.py` : hook `PreToolUse` sur Bash. Refuse le
  push vers `main`/`master`/`release` (nommé ou branche courante), le push forcé,
  `--all`/`--mirror`, `gh pr merge`, l'API de merge, `merge`/`rebase` depuis une branche
  protégée. Commandes composées examinées morceau par morceau. Une erreur du verrou laisse
  passer. Écrit en Python plutôt qu'en bash + `jq` : `install.sh` exige déjà Python.
- `test_verrou.py` : 40 commandes jouées sur `main` et sur `feature/x`, 80/80 conformes.
- `install.sh` pose le hook dans `.claude/settings.json` à côté du panneau de suivi.
- Épreuve en session réelle sur un dépôt jetable (`claude -p`, Sonnet) : `git push --all
  origin --dry-run` refusé par le hook avant exécution, message lu par Claude ;
  `git push -u origin feature/test --dry-run` passé. Le sandbox n'a pas été touché : il
  recevra le verrou par `/pilot update` après le merge.
- Découvert au passage : un hook global `~/.claude/scripts/command-validator` existe déjà
  (c'est lui qui refuse `rm -rf`). La version globale du verrou pourrait s'y ajouter plutôt
  que doubler les hooks ; à décider avec Cédric.

## Chantier 2 — trois skills importées telles quelles (même jour)

- `implementation/skills/diagnosing-bugs/`, `resolving-merge-conflicts/`, `to-questionnaire/` :
  copies de `sources/mattpocock-skills-1.2.3/`, corps en anglais, une ligne d'origine en tête,
  description enrichie de déclencheurs français. `to-questionnaire` reste tapée par l'humain.
- Branchées : `fix` (bug qui ne se reproduit pas → `diagnosing-bugs`), `produire.md` (conflit
  au merge → `resolving-merge-conflicts`), `cadrer.md` temps 1 (décision du client →
  `/to-questionnaire`), section Outils de `SKILL.md`, inventaires.
- Épreuve en session réelle (`claude -p`, Sonnet) sur deux dépôts jetables après `install.sh` :
  « les tests ne passent plus, diagnostique » → Skill tool `diagnosing-bugs` appelé, boucle
  rouge nommée, cause exacte trouvée ; « le merge bloque sur un conflit, résous-le » → Skill
  tool `resolving-merge-conflicts` appelé, merge terminé en gardant les deux intentions.
- Sandbox (PR #67) et crm-workday (PR #27) mis à jour à `3f2e14f` (verrou git) sur branches
  `chore/update-methode-3f2e14f` ; ils recevront les skills au prochain `update`.

## Chantier 3 — `pilot/SKILL.md` réécrit avec la grille (même jour)

- Journal de relecture bloc par bloc : `.workflow/relectures/2026-09-14-skill-pilot.md`.
- `SKILL.md` : 3 420 → 1 327 mots. Ce qui en sort va dans trois nouveaux fichiers de
  `reference/` : `fiches.md` (le moule, tailles, priorités, dépendances, dates, vérification),
  `linear.md` (MCP vs script, workspaces, initiatives, relations, icônes, frise), `git.md`
  (branches, release, gabarit de PR, verrou). Renvois posés dans `cadrer.md`, `produire.md`,
  `suivre.md`. Cible « moins de 1 000 » non atteinte : ce qui reste est le principe, le
  vocabulaire, sept invariants, les statuts, les tables de commandes ; couper là ferait
  perdre du sens.
- Épreuve : evals 1 et 2 rejouées sur copies jetables, ancienne et nouvelle version. `init`
  identique. `feature Facturation` : la nouvelle tient les cinq assertions (cadrage complet,
  contradicteur, arrêt) là où l'ancienne s'arrêtait sur le mauvais workspace ; la garde
  « team introuvable = mauvais workspace » a été réintroduite après coup.
- Environnement : la connexion MCP `linear` de la machine est authentifiée sur GM5 ; les
  evals qui lisent le sandbox (weme-studio) tournent en dégradé, à rejouer après `/mcp`.

## Chantier 4a — l'entretien par rounds (même jour)

- `reference/entretien.md` (361 mots) : la mécanique de `grilling` en français : arbre de
  décisions, frontière, rounds numérotés avec réponse recommandée, les faits cherchés avant
  de demander, fini quand la frontière est vide. `init` et `feature` y renvoient au lieu de
  décrire l'entretien chacun de leur côté.
- Épreuve : `init` sans Linear ni recherche sur un produit inventé (cave à vin), Sonnet :
  trois rounds annoncés, Q1 à Q5 au format attendu, réponse recommandée à chaque question,
  arrêt en fin de round. Sur le sandbox, la garde « mauvais workspace » du chantier 3 a
  bien arrêté `feature Facturation` avant l'entretien (connexion `linear` sur GM5).

## Reste

- Cédric relit la PR 4a (entretien).
- Cédric relit la PR du chantier 3 (SKILL.md, les trois fichiers, le journal).
- Cédric merge la PR du chantier 2, puis les PR d'update du sandbox (#67) et de crm-workday (#27), puis `/pilot update` à nouveau pour les skills.
- Chantier 3 : réécriture de `pilot/SKILL.md` avec la grille.
- (chantier 1) Cédric relit et merge la PR du chantier 1, puis `/pilot update` sur le sandbox et
  crm-workday.
- Version globale du verrou (`~/.claude`) : proposer après l'avoir vu tourner sur un projet.
- Chantier 2 : import tel quel de `diagnosing-bugs`, `resolving-merge-conflicts`,
  `to-questionnaire`.
- Sandbox : `.pi/liste-blanche.json` est modifié et non commité, à regarder avant le
  prochain run.
