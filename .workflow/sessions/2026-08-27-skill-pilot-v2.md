
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

## Discussion du 27/08 (soir) — types de projets, gate et auditeur

Point de départ : les 40 lignes ajoutées par la session sandbox au fichier de passation
`2026-08-27-reprise-boucle-agents.md` (types de projets, six manques React Native / Volt,
Playwright pour apps web et sites). Rien d'implémenté, tout discuté.

### Décisions prises

- **Périmètre de `pilot` : les projets de code** — application web, application mobile, site.
  Skills → skill-creator (boucle déjà complète). Documents → branche + PR + relecture.
  `init` refuse un projet sans code (« pas de gate possible ») plutôt qu'une gate vide.
- **Principe** : le pilotage vaut partout ; la boucle prouve ce qu'elle peut prouver et dit
  le reste. `run` ne dit jamais « auditée » pour ce qu'il n'a pas vérifié : rapport en deux
  colonnes « prouvé / à relire ».
- **Gate déduite de la stack par `init`** (table : script `test`, `tsconfig`, ESLint,
  `playwright.config`, Expo/`ios`/`android` → gate rapide + gate lente séparées, pytest…) ;
  écrite dans `## Pilot` (`Gate :`, `Gate feature :`), confirmée d'un mot, jamais posée à froid.
- **Auditeur décidé au cadrage produit** (pas de la stack) : `Auditeur : code` ou
  `code + captures`. Dépend de l'exigence visuelle et de l'existence d'un cadrage visuel.
- **Trois rythmes du visuel** : régression automatique à chaque livraison (captures de
  référence, tout l'écran) ; conformité par feature, sur les écrans touchés, captures relues
  par l'auditeur contre le cadrage ; qualité d'ensemble à un jalon, humaine. Jamais
  « écran par écran à chaque feature ».
- La revue visuelle de conformité reste la relecture de Cédric tant qu'elle n'est pas
  outillée ; déclarée comme telle dans le rapport de `run`.
- La carte des cas dans la skill reste courte : détection de gate + règle d'auditeur. Les
  outils (Playwright, Maestro…) se choisissent par projet à la session de cadrage.

### Exemples de sections `## Pilot` discutés (stack réelle relevée)

- Volt : `volt-mobile` Expo + Jest + RNTL + ESLint + EAS ; `volt-api` Python ; `maestro/flows/`
  déjà 5 parcours. Gate mobile (`tsc`, lint, jest), gate api (pytest), gate feature lente
  (eas build preview + maestro), auditeur code + captures Maestro, secrets exclus
  (`.env`, `google-service-account.json`, certificats).
- Nexus : `front` Vite + bun test + Playwright a11y déjà présent ; backend `apps/backend`.
- Site vitrine : Playwright gate principale (structure, liens, axe-core, captures × largeurs),
  auditeur captures + contenu ; Webflow sans dépôt = pilotage seul.

### Ordre convenu pour la suite

1. **Mécanisme `Gate` / `Auditeur` dans la skill** (à faire d'abord, Volt en dépend) :
   détection à `init`, lecture par `run`, rapport « prouvé / à relire ». Avec skill-creator,
   trois scénarios en lecture seule (Carnet, Nexus, Volt), ancienne contre nouvelle.
2. Merger la PR #5 ; ajouter dans `BOUCLE-AGENTS.md` la section « Gate et auditeur par type
   de projet » avec les trois rythmes du visuel.
3. Session de cadrage de la boucle sur Volt (dans le dépôt Volt) : stack confirmée, section
   `## Pilot`, secrets exclus, puis une feature petite pour mesurer.
4. Ensuite seulement : `Agents en parallèle : 2` sur Carnet.

État à la pause : rien d'implémenté pour ces points ; skill `pilot` v2 active ; PR #5 ouverte
(contient aussi les 40 lignes de la session sandbox dans le fichier de passation).
