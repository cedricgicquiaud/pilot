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

## Reste

- Cédric relit et merge la PR du chantier 0 (la grille surtout).
- Chantier 1 : le verrou git. Adapter `sources/mattpocock-skills-1.2.3/git-guardrails-claude-code/scripts/block-dangerous-git.sh`,
  l'installer par `install.sh` (qui sait déjà fusionner un hook dans `settings.json`),
  tester sur le sandbox, puis proposer la version globale `~/.claude`.
- Sandbox : `.pi/liste-blanche.json` est modifié et non commité, à regarder avant le
  prochain run.
