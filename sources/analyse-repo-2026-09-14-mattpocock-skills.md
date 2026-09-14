# Analyse du dépôt `mattpocock/skills` (14 septembre 2026)

Dépôt : https://github.com/mattpocock/skills — version 1.2.3, licence MIT.
Auteur : Matt Pocock (Total TypeScript, AI Hero). Distribué comme plugin Claude Code
officiel (`claude plugins install mattpocock-skills`) et via `skills.sh` pour Codex.

Objet de cette note : comment il rédige ses skills, ce qu'elles valent, et ce que PILOT
peut en reprendre. Les citations sont traduites de l'anglais.

---

## 1. Ce qu'il y a dans le dépôt

### Inventaire

| Bucket | Skills | Statut |
|---|---|---|
| `engineering/` | 18 | promues, livrées dans le plugin |
| `productivity/` | 7 | promues, livrées dans le plugin |
| `in-progress/` | 6 | bêta publique, pas dans le plugin |
| `misc/` | 4 | gardées, pas promues |
| `deprecated/` | 0 | dossier vide avec README |

37 `SKILL.md` au total, 25 promues.

**Skills promues, engineering** : ask-matt (routeur), grill-with-docs, triage,
improve-codebase-architecture, setup-matt-pocock-skills, to-spec, to-tickets, implement,
wayfinder, prototype, diagnosing-bugs, research, tdd, domain-modeling, codebase-design,
code-review, resolving-merge-conflicts, wizard.

**Skills promues, productivity** : grill-me, grilling, handoff, teach, to-questionnaire,
wait-what, writing-for-agents.

**In-progress** : claude-handoff, implement-spec, loop-me, retro, setup-ts-deep-modules,
writing-beats / writing-fragments / writing-shape.

**Misc** : git-guardrails-claude-code, migrate-to-shoehorn, scaffold-exercises,
setup-pre-commit.

### Anatomie d'un dossier de skill

```
skills/engineering/tdd/
├── SKILL.md            # la skill : frontmatter + corps
├── agents/openai.yaml  # métadonnées Codex (nom affiché, résumé court, politique d'invocation)
├── tests.md            # référence : bons et mauvais tests, avec code
└── mocking.md          # référence : quand mocker
```

Les fichiers compagnons (`tests.md`, `ADR-FORMAT.md`, `HTML-REPORT.md`,
`PHASE-BOUNDARIES.md`, `template.sh`…) portent ce qui n'est lu que si une branche de la
skill l'exige. Vingt-six fichiers compagnons pour 37 skills.

### Gouvernance du dépôt lui-même

C'est la partie la plus instructive pour PILOT : le dépôt applique à lui-même ce que ses
skills prêchent.

- `CLAUDE.md` (lié en symlink à `AGENTS.md`) : règles de maintenance du dépôt, 600 mots.
- `CONTEXT.md` : glossaire du domaine *du dépôt* (Issue tracker, Issue, Decision ticket,
  Triage role), avec pour chaque terme les synonymes à éviter et les ambiguïtés tranchées.
- `.agents/adr/` : deux ADR (décisions d'architecture), une page chacune. Exemple :
  « pointeur explicite vers `/setup` seulement pour les dépendances dures ».
- `.agents/writing-docs.md`, `invocation.md`, `install-block.md` : la doctrine de
  rédaction, en un seul endroit, que les skills pointent.
- `.out-of-scope/` : base des demandes refusées, avec la raison et les numéros d'issues.
  Un fichier par idée rejetée. Le triage la consulte avant de rouvrir un débat.
- `docs/<bucket>/<skill>.md` : une page humaine par skill promue, publiée sur aihero.dev,
  avec quatre sections imposées : *Ce que ça fait*, *Quand l'utiliser*, *Questions
  fréquentes* (tirées des issues réelles, jamais inventées), *Ça marche si*.
- `.changeset/` + `CHANGELOG.md` : chaque changement de skill est un changeset relié à une PR.
- `scripts/link-skills.sh` : symlinks vers `~/.claude/skills`, donc `git pull` = mise à jour.

---

## 2. Comment il rédige : les chiffres

### Longueur des `SKILL.md`

| | Promues (25) | PILOT, pour comparaison |
|---|---|---|
| Minimum | 22 mots (`grill-me`) | 115 mots (`template-tache.md`) |
| Médiane | 559 mots | — |
| Moyenne | 729 mots | — |
| Maximum | 2 000 mots (`wayfinder`) | 3 316 mots (`pilot/SKILL.md`) |

Répartition des promues :

| Tranche | Skills |
|---|---|
| < 150 mots | grill-me (22), grill-with-docs (35), wait-what (60), implement (70), research (131), resolving-merge-conflicts (133), handoff (138) |
| 300 – 700 mots | grilling (319), to-questionnaire (470), prototype (487), domain-modeling (493), to-spec (493), tdd (559), wizard (673) |
| 850 – 1 100 mots | codebase-design (851), to-tickets (894), improve-codebase-architecture (899), triage (990), setup (1 008), code-review (1 064) |
| > 1 400 mots | diagnosing-bugs (1 402), teach (1 488), ask-matt (1 769), writing-for-agents (1 777), wayfinder (2 000) |

Lecture : sept skills tiennent en moins de dix lignes. Les cinq longues sont soit des
références (writing-for-agents, ask-matt = routeur), soit des disciplines en phases
(diagnosing-bugs, wayfinder).

Côté PILOT : `pilot/SKILL.md` (3 316) + `reference/` (cadrer 2 222, produire 2 958,
suivre 1 426) = environ 10 000 mots pour une commande jouée de bout en bout. Les fiches
d'agent font 800 à 1 900 mots chacune. PILOT est donc 5 à 6 fois plus verbeux à
fonctionnalité comparable. Ce n'est pas forcément un défaut (les agents PILOT tournent
sans humain, ils ont besoin de plus de cadre), mais c'est le premier écart à regarder.

### Descriptions (le frontmatter)

Longueur des `description:` des skills promues : de 51 à 421 caractères, médiane 150.
Deux régimes :

- **Skill invoquée par l'humain** (`disable-model-invocation: true`) : description d'une
  ligne, tournée vers un humain qui parcourt la liste des commandes.
  `grill-me` : « A relentless interview to sharpen a plan or design. »
- **Skill invoquée par le modèle** : description = pointeur de déclenchement, avec les
  branches. `tdd` : « Test-driven development. Use when the user wants to build features or
  fix bugs test-first, mentions "red-green-refactor", or wants integration tests. »

22 skills sur 37 sont invoquées par l'humain seulement. La règle : une skill humaine peut
appeler une skill modèle, jamais l'inverse.

### Formes récurrentes (sur 37 `SKILL.md`)

| Forme | Occurrences |
|---|---|
| Étapes numérotées | 20 |
| Titre H1 dans le corps | 18 (les autres commencent directement par le texte) |
| Appel explicite « Call the Skill tool with "X" » | 10 |
| Mention de `CONTEXT.md` | 8 |
| Critère de fin explicite (« Done when », « Completion criterion ») | 8 |
| Section `## Process` | 6 |
| Gabarits balisés (`<spec-template>`, `<vertical-slice-rules>`) | 3 |
| Cases à cocher | 3 |

---

## 3. Comment il rédige : la doctrine

La skill `writing-for-agents` (1 777 mots) est le manuel. Elle est écrite pour être lue par
l'agent qui écrit une skill. Ses idées, dans l'ordre d'importance pour PILOT.

### 3.1 Le pointeur de contexte

Un « pointeur de contexte » est une phrase tenue en mémoire par l'agent qui nomme un
document hors contexte et dit *quand* aller le chercher. La description d'une skill en est
un ; une ligne de `CLAUDE.md` qui nomme un fichier aussi.

Sa règle : « c'est la *formulation* du pointeur, pas sa cible, qui décide si l'agent y va.
Une cible indispensable derrière un pointeur mou est un bug de variance : affûter la
formulation d'abord, inliner le contenu seulement si ça échoue. »

Trois consignes : mettre le mot déclencheur en tête ; un déclencheur par branche (les
synonymes d'une même branche sont une branche écrite deux fois) ; couper l'identité que le
corps porte déjà.

### 3.2 Les deux charges

Chaque document dépense l'un de deux budgets :

- **Charge de contexte** : ce qui est chargé à chaque tour (descriptions, `CLAUDE.md`).
  Coûte des tokens et de l'attention que la skill se déclenche ou non.
- **Charge cognitive** : ce que l'humain doit se rappeler (quelle skill existe, quand la
  taper). « L'humain est l'index. Ce n'est pas un coût à minimiser : c'est le prix de son
  contrôle. Le dépenser là où son jugement compte, l'enlever là où il ne compte pas. »

D'où le choix : une skill que seul l'humain tape n'a pas de description chargée (zéro
charge de contexte), au prix qu'il doit s'en souvenir. Le routeur `ask-matt` existe pour
alléger cette mémoire.

### 3.3 La hiérarchie d'information et la divulgation progressive

Un document mêle des **étapes** (ce que l'agent fait, dans l'ordre) et de la **référence**
(définitions, règles, consultées à la demande). Trois étages :

1. Étape dans le fichier : le niveau principal.
2. Référence dans le fichier : consultée au besoin.
3. Référence déportée : un fichier compagnon derrière un pointeur, chargé seulement si la
   branche s'active.

« Pousse trop peu vers le bas, le haut gonfle ; pousse trop, tu caches ce dont l'agent a
besoin. Cette tension est toute la décision. » Le test : inliner ce que toutes les branches
utilisent, déporter ce que seules certaines atteignent.

Exemple concret : `tdd` garde dans `SKILL.md` les règles de la boucle et les
anti-patterns (toujours utiles), déporte les exemples de code dans `tests.md` et le mocking
dans `mocking.md`.

### 3.4 Critère de fin pour chaque étape

« Chaque étape se termine sur un critère de fin : la condition qui dit à l'agent que le
travail est fait. » Deux propriétés : **clarté** (l'agent distingue fait de pas-fait) et
**exigence** (« chaque modèle modifié pris en compte » force plus de travail que « produis
une liste »).

Le danger nommé : la **complétion prématurée**. Les étapes suivantes visibles tirent
l'agent vers « être fini ». Défense : affûter la borne d'abord ; ne cacher les étapes
suivantes (en coupant le document) que si la borne reste floue *et* qu'on observe la
précipitation.

Meilleur exemple dans le dépôt, `diagnosing-bugs`, phase 1 :

> « La phase 1 est finie quand tu peux nommer **une commande** que tu as **déjà lancée au
> moins une fois** (montre l'appel et sa sortie), et qui est : capable de passer au rouge sur
> *ce* bug ; déterministe ; rapide (des secondes) ; lançable sans humain. Si tu te surprends
> à lire du code pour bâtir une théorie avant que cette commande existe, arrête : sauter à
> l'hypothèse est exactement l'échec que cette skill empêche. »

### 3.5 Les « leading words » (mots-ancres)

Un mot-ancre est « un concept compact qui vit déjà dans le pré-entraînement du modèle et
avec lequel l'agent pense en exécutant le document ». Répété comme un token, jamais comme
une phrase, il ancre une région de comportement pour presque rien.

Ses exemples : *seam* (couture, l'endroit où on teste), *tracer bullet* (tranche verticale
fine de bout en bout), *frontier* (les tickets débloqués), *fog of war* (ce qu'on ne peut
pas encore spécifier), *tight loop* (boucle rapide et déterministe), *deep module*, *red*.

Refactoring proposé : « rapide, déterministe, léger » → *tight* ; « une boucle en laquelle
tu crois » → *red* (la boucle passe au rouge sur le bug, ou non).

Corollaire : **prompter en positif**. « Ne pense pas à un éléphant, et il n'y a plus que
l'éléphant. » Une interdiction ne vaut que comme garde-fou impossible à formuler
positivement, et même alors, accompagnée de la cible positive.

### 3.6 L'élagage

- Une seule source de vérité par signification. La duplication « gonfle la place d'une
  idée dans la hiérarchie au-delà de son rang réel ».
- L'environnement est une source de vérité (`package.json`, `--help`) ; un document qui le
  recopie est un cache, qui ne vaut que si la recherche est chère.
- Test du **no-op** phrase par phrase : « une instruction que le modèle suit déjà par
  défaut paie de la charge pour ne rien dire ». Le test est relatif au modèle, pas au
  lecteur : deux humains en désaccord tranchent en lançant le document, pas en débattant.
  Quand une phrase échoue, supprimer la phrase entière.
- **Sédiment** : « des couches périmées qui se déposent parce qu'ajouter paraît sûr et
  retirer risqué, jusqu'à devoir carotter pour retrouver ce qui vit encore ».

### 3.7 Le ton

- Deuxième personne, impératif, dense. Le « pourquoi » est inline, jamais dans un
  préambule : `code-review` finit par une section « Pourquoi deux axes » de six lignes.
- Zéro tiret cadratin dans tout le dépôt (règle de `CLAUDE.md`) : deux-points, virgules,
  parenthèses. Utile à noter : le `CLAUDE.md` global de Cédric interdit la même chose pour
  ses réponses.
- Neutralité de harness : depuis la 1.2.3, aucun nom d'outil Claude (`Task`, types
  d'agents) dans les skills, pour rester jouable sur Codex.
- Gabarits délimités par des balises XML-like (`<spec-template>…</spec-template>`) pour
  que le modèle sache où commence et finit le modèle à remplir.
- Chaque skill qui dépend d'une configuration dit *une* phrase : « le tracker aurait dû
  t'être fourni ; sinon, dis à l'utilisateur de lancer `/setup-matt-pocock-skills` ». Et
  seulement les skills qui ne peuvent pas fonctionner sans (ADR 0001) ; les autres parlent
  vaguement du « glossaire du projet » et se dégradent gracieusement.

---

## 4. La composition : petites briques et orchestrateurs

C'est la deuxième leçon structurelle. Le dépôt sépare :

- **Primitives invoquées par le modèle**, réutilisables : `grilling` (l'entretien),
  `domain-modeling` (le glossaire et les ADR), `codebase-design` (le vocabulaire des
  modules profonds), `tdd` (les règles de la boucle), `research`, `prototype`,
  `code-review`, `wizard`.
- **Enveloppes invoquées par l'humain**, minces, qui composent : `grill-me` = une ligne
  (« Call the Skill tool with "grilling" ») ; `grill-with-docs` = « appelle deux fois,
  grilling et domain-modeling » ; `implement` = 70 mots (« utilise tdd aux coutures
  convenues, typecheck régulièrement, code-review à la fin, commit »).

La chaîne principale, telle que le routeur `ask-matt` la décrit :

```
grill-with-docs → to-spec → to-tickets → implement (×n, /clear entre chaque) → code-review
```

Avec deux voies d'entrée (`triage` pour les demandes externes, `diagnosing-bugs` pour ce
qui casse), un mode « gros effort brumeux » (`wayfinder`) et des outils isolés.

Positionnement revendiqué dans le README : « GSD, BMAD et Spec-Kit aident en possédant le
processus. Ce faisant, ils vous retirent le contrôle et rendent les bugs du processus durs
à résoudre. Ces skills sont petites, faciles à adapter, composables. » Le contrôle humain
passe par le fait que chaque étape est une commande que l'humain tape.

PILOT est du côté opposé de cet axe : un circuit chaîné (`init → roadmap → feature → run
→ sync → next`) où « chaque commande finit en proposant la suivante ». Le contrôle humain
y passe par quatre validations imposées par feature (cadrage, découpage, merge, idiomes).
Les deux approches sont défendables ; il faut juste savoir que Matt refuserait la seconde,
et que ses skills sont écrites pour la première.

---

## 5. Qualité, skill par skill (les pertinentes pour PILOT)

Verdict après lecture complète. Note sur 3 : ★ moyen, ★★ bon, ★★★ à prendre.

| Skill | Mots | Verdict | Pourquoi |
|---|---|---|---|
| `grilling` | 319 | ★★★ | La meilleure formalisation d'un entretien de cadrage que j'aie lue : arbre de décisions, *frontière* (les questions posables maintenant), rounds numérotés avec réponse recommandée, « trouver les faits est ton travail, décider est le sien », fin = frontière vide. |
| `diagnosing-bugs` | 1 402 | ★★★ | Six phases avec critères de fin vérifiables ; la phase 1 (construire la boucle rouge avant toute hypothèse) est la vraie valeur. Dix façons de construire la boucle, classées. |
| `writing-for-agents` | 1 777 | ★★★ | Le manuel de rédaction. Voir § 3. |
| `code-review` | 1 064 | ★★★ | Deux axes (standards / spec) en sous-agents séparés « pour qu'aucun ne pollue l'autre », jamais fusionnés. Baseline de 12 code smells de Fowler, chacun en « ce que c'est → comment corriger ». |
| `tdd` | 559 | ★★ | Référence courte : coutures pré-convenues, trois anti-patterns (couplé à l'implémentation, tautologique, tranche horizontale), règles de la boucle. Pas de refactor dans la boucle (déplacé en review, décision assumée). |
| `to-tickets` | 894 | ★★ | Tranches verticales, arêtes de blocage, quiz de granularité à l'humain, et le pattern *expand-contract* pour les refactors larges (ajouter la nouvelle forme, migrer par lots, supprimer l'ancienne). |
| `domain-modeling` + formats | 493 + 770 | ★★★ | Glossaire `CONTEXT.md` (terme, définition en une phrase, synonymes à éviter) mis à jour *pendant* la conversation. ADR = un paragraphe, seulement si les trois conditions tiennent (dur à inverser, surprenant sans contexte, vrai arbitrage). |
| `wayfinder` | 2 000 | ★★ | Planifier un effort trop grand pour une session comme une carte de tickets-décisions. Concepts forts : *fog of war* / « pas encore spécifié », « hors périmètre » distinct, « ticket ou brouillard ? = peux-tu formuler la question précisément, pas y répondre ». Long et exigeant. |
| `to-spec` | 493 | ★★ | Synthèse sans ré-interview ; l'étape « esquisser les coutures de test et les faire valider » est la bonne idée. Le reste est un gabarit classique. |
| `resolving-merge-conflicts` | 133 | ★★★ | Cinq étapes, rien à enlever : résoudre par *intention* retracée à la source de chaque côté, jamais `--abort`. |
| `handoff` | 138 | ★★ | Compacte la conversation en document pour un autre agent ; référence les artefacts au lieu de les recopier ; masque les secrets. |
| `wait-what` | 60 | ★★ | Correctif d'une réponse qui n'est pas passée : « redis-le avec du contexte, en anglais technique simplifié, avec le vocabulaire de `CONTEXT.md` ». Le nom fait tout le travail. |
| `research` | 131 | ★★ | Agent en arrière-plan, sources primaires, un fichier Markdown cité. Minimaliste. |
| `to-questionnaire` | 470 | ★★ | Pour ce qui est dans la tête de quelqu'un d'autre : interviewer sur *l'envoi* (à qui, ce qu'il faut en retour), puis viser l'écart. |
| `implement-spec` (in-progress) | 315 | ★ | Graphe de tickets, sous-agents implémenteurs en worktrees, sous-agent *merger*. La même idée que `run`, moins mûre, et **le merge y est automatique** : incompatible avec l'invariant PILOT. |
| `retro` (in-progress) | 530 | ★★ | Sept catégories d'amélioration de l'environnement de l'agent (navigation, checks automatiques, standards, no-ops, économie d'outils, accès à l'information). |
| `git-guardrails-claude-code` (misc) | 302 | ★★ | Hook `PreToolUse` qui bloque `git push`, `reset --hard`, `clean -f`, `branch -D`. Script de 69 mots. |
| `wizard` | 673 | ★★ | Génère un script bash qui guide un humain étape par étape dans des actions que seul un humain peut faire (dashboards tiers, secrets). |
| `triage` | 990 | ★ | Machine à états pour issues GitHub externes. Hors sujet pour PILOT (Linear porte déjà les statuts). |
| `setup-matt-pocock-skills` | 1 008 | ★ | Configuration par dépôt (tracker, labels, docs). Linear y est « autre / custom, décris en un paragraphe ». |
| `codebase-design` | 851 | ★★ | Vocabulaire des modules profonds (module, interface, profondeur, couture, adaptateur). Utile en review, pas prioritaire. |
| `prototype` | 487 | ★ | Deux branches (logique → un HTML autonome ; UI → variantes sur une route). Marginal pour PILOT. |
| `teach`, `writing-*`, `loop-me`, `scaffold-exercises`, `migrate-to-shoehorn`, `setup-pre-commit`, `setup-ts-deep-modules` | — | — | Hors périmètre PILOT. |

---

## 6. Correspondances avec PILOT

| Brique PILOT | Équivalent chez Matt | Que faire |
|---|---|---|
| Entretien de cadrage (`init`, `feature`, « poser les questions par petits lots ») | `grilling` | **Reprendre la mécanique** : frontière, rounds numérotés, réponse recommandée par question, faits cherchés par sous-agent. C'est exactement « petits lots » rendu exécutable. |
| `contradicteur` | rien | Garder. Matt n'a pas d'agent qui cherche ce qui manque ; c'est une force de PILOT. |
| Contrat de validation (10 à 30 phrases observables) | `to-spec` (user stories + décisions de test + coutures) | Garder le contrat. **Importer une étape** : convenir des *coutures* (où seront écrits les tests) au cadrage, pas seulement ce qui doit être vrai. |
| `decoupeur` (livraisons disjointes, fichiers listés) | `to-tickets` | Garder (la disjonction de fichiers est plus forte, elle sert le parallélisme). **Emprunter** : les trois questions du quiz de granularité, et le pattern expand-contract pour les refactors larges. |
| `tdd-writer` (acteur, 1 905 mots) | `tdd` (référence, 559) + `implement` (70) | Pas un remplacement : le tdd-writer a besoin de son frontmatter d'agent (outils, tours, modèle). **Importer** les trois anti-patterns et `mocking.md` comme référence lue par le tdd-writer. |
| `verifier` (preuve TDD dans l'historique, diff, gravité) | `code-review` | Garder la preuve TDD (Matt ne l'a pas). **Importer** : la séparation en deux axes (standards / contrat de validation) et la baseline des 12 smells avec « → comment corriger ». |
| `testeur`, `correcteur` | rien | Garder. |
| `run` (worktrees, MISSION.md, liste blanche) | `implement-spec` (in-progress) | Garder. `run` est plus mûr. Le merger automatique de Matt viole l'invariant merge humain. |
| `fix` | `implement` + `tdd` | Comparable. **Ajouter** `diagnosing-bugs` en amont quand la tâche est un bug non trivial. |
| `roadmap` | `wayfinder` (carte de décisions) | Buts différents (features vs décisions). **Emprunter** : une section « Pas encore spécifié » et une section « Hors périmètre » distinctes sur la fiche feature ; le test « ticket ou brouillard ». PILOT a déjà la « réserve » pour les features conditionnelles, c'est le même geste. |
| `next`, `sync`, `benchmark` | rien | Garder. Pour la partie « grave les leçons dans `CLAUDE.md` » de `sync`, **structurer avec les sept catégories de `retro`**. |
| `research-assistant` (1 014 mots) | `research` (131 mots) | Candidat à l'élagage, pas au remplacement. À tester en parallèle sur un même sujet avant de trancher (règle : pas de config avant test). |
| Idiomes de code / d'interface dans `CLAUDE.md` du projet | `CONTEXT.md` + ADR | **Adopter** : `init` pose un `CONTEXT.md` (le vocabulaire Projet / Feature / Livraison / Tâche *est* un glossaire) et un `docs/adr/`. Les « décisions de fond remontées » au merge y sont gravées au format une-paragraphe. |
| Invariant « jamais de push sur main, jamais de merge » (prompt seulement) | `git-guardrails` (hook) | **Adopter, adapté** : un hook `PreToolUse` qui bloque `git push` vers `main`/`release` et `gh pr merge`. Une règle de prompt se contourne ; un hook non. |
| Résumés de session `.workflow/sessions/` | `handoff` | Comparable ; la convention PILOT pourrait devenir une skill de 140 mots. |
| Points de contact réglés au merge | `resolving-merge-conflicts` | **Adopter tel quel** (133 mots), pour la séance de merge humaine. |
| Actions « MANUEL » de `init` (réglages Linear) | `wizard` | Optionnel : générer le script guidé des étapes manuelles de `init`. |
| `rendu-fonctionnel` | `wait-what` | Complémentaires. `wait-what` en version française, pointant sur le vocabulaire PILOT, coûte 60 mots. |
| `AGENT.template.md` (1 365 mots) | `writing-for-agents` | **Adopter comme référence** pour la prochaine réécriture des fiches et de `pilot/SKILL.md`. |
| Projets clients (questions que seul le client peut trancher) | `to-questionnaire` | **Adopter tel quel**. Cas fréquent chez Cédric. |

### Points d'incompatibilité à connaître

1. **Tracker** : tout ce qui écrit dans un tracker (`to-spec`, `to-tickets`, `triage`,
   `wayfinder`) est pensé pour GitHub Issues ou fichiers locaux. Linear est « autre :
   décris ton workflow en un paragraphe ». PILOT a déjà le MCP Linear et `init_team.py` ;
   on prend les idées, pas les skills.
2. **Merge** : `implement-spec` merge par sous-agent. Interdit dans PILOT.
3. **Langue** : tout est en anglais. Les mots-ancres (*seam*, *frontier*, *tight*) peuvent
   rester en anglais dans des fiches françaises ; PILOT le fait déjà avec `tdd-writer`,
   `verifier`.
4. **Harness** : Matt vise Claude Code et Codex ; PILOT est Claude Code seul, à dessein
   (frontmatter d'agents, MCP). Pas de contrainte à reprendre.

---

## 7. Ce que PILOT ferait différemment après cette lecture

Par ordre de rendement.

1. **Passer `pilot/SKILL.md` au test du no-op et à la divulgation progressive.** 3 316 mots
   chargés à chaque déclenchement, dont une section « Règles dures » de 1 400 mots qui mêle
   étapes, référence (codes couleur Linear, noms d'icônes acceptés) et rappels. La doctrine
   de Matt dirait : `SKILL.md` = principe, quand ça s'applique, table des commandes,
   pointeurs ; tout le reste en `reference/`, chargé par branche. Cible raisonnable : 800 à
   1 000 mots.

2. **Un critère de fin par étape dans les fiches d'agent.** Les commandes PILOT ont « elle
   s'arrête sur » (bien). Les fiches d'agent décrivent surtout un rôle et un ordre de
   mission ; ajouter « fini quand » vérifiable à chaque section (« fini quand chaque phrase
   du contrat est affectée à une livraison et que la somme couvre tout »).

3. **Des primitives réutilisables invoquées par le modèle.** `grilling` et
   `domain-modeling` sont appelées par quatre skills. Dans PILOT, l'entretien de `init` et
   celui de `feature` sont décrits deux fois dans `cadrer.md`. Une skill `entretien`
   (mécanique de `grilling`, en français) appelée par les deux.

4. **Un `CONTEXT.md` et des ADR dans chaque projet piloté**, posés par `init`. PILOT a un
   vocabulaire imposé et des décisions datées dispersées dans `CLAUDE.md` global,
   `BOUCLE-AGENTS.md` et les fiches feature. Le format ADR d'une page, avec les trois
   conditions, leur donne un seul endroit.

5. **Un `.out-of-scope/` dans le dépôt PILOT** pour les idées refusées de la boucle
   agents (aujourd'hui dans le backlog de `BOUCLE-AGENTS.md`, mêlées aux idées à faire).

6. **Le hook git.** Voir tableau § 6.

7. **Prompter en positif dans les fiches.** Les fiches PILOT contiennent beaucoup de « ne
   devine pas », « jamais de », « tu ne corriges rien ». Certaines sont des garde-fous
   légitimes ; d'autres se reformulent en cible positive (« écris ce qui te manque dans ton
   rapport et arrête-toi » existe déjà, la négation qui précède est peut-être un no-op).

8. **Un routeur.** `next` joue ce rôle à l'exécution. Une page humaine « quelle commande
   dans quelle situation », sur le modèle des quatre sections des docs de Matt (*ce que ça
   fait, quand, questions fréquentes, ça marche si*), manque au `README.md` de PILOT.

---

## 8. Ce qu'il ne faut pas copier

- **La chaîne manuelle.** Faire taper `/to-spec`, puis `/to-tickets`, puis `/implement` ×n
  avec `/clear` entre chaque convient à un développeur qui veut garder la main à chaque pas.
  PILOT s'adresse aussi à un humain qui ne veut voir que Linear et les PR. Le circuit
  chaîné avec validations est le bon choix pour cet usage.
- **Le tracker local en Markdown.** PILOT a Linear ; c'est ce que le client regarde.
- **La suppression du refactor dans la boucle TDD.** Matt l'a retirée parce que « les
  agents ne le faisaient jamais » et l'a déplacée en review. PILOT impose un commit par
  transition, refactor compris, et le `verifier` le contrôle. C'est plus exigeant et
  vérifiable ; garder.
- **`implement-spec`** : merge automatique.

---

## 9. Sources lues

- Tous les `SKILL.md` promus et in-progress, les fichiers compagnons de `tdd`, `triage`,
  `domain-modeling`, `ask-matt`, `setup`, `writing-for-agents`.
- `README.md`, `CLAUDE.md`, `CONTEXT.md`, `.agents/*`, `.out-of-scope/*`, `CHANGELOG.md`
  (1.2.0 à 1.2.3), `.claude-plugin/plugin.json`, `docs/engineering/tdd.md` comme exemple
  de page humaine.
- Côté PILOT : `implementation/skills/pilot/SKILL.md`, `README.md`, en-têtes de
  `tdd-writer.md`, `verifier.md`, `contradicteur.md`, `cadrer.md`, `research-assistant`,
  `CLAUDE.md` du dépôt.

Clone de travail : scratchpad de session, non conservé.
