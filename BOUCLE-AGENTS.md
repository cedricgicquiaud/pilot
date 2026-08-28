# La boucle agents — faire travailler plusieurs agents Claude Code sans les regarder

_Document interne. Il complète `PILOTAGE-LINEAR-GITHUB-CLAUDE.md` : la Partie B de ce dernier
décrit le circuit complet d'une feature (cadrer → découper → produire → merger → apprendre) ;
ce document détaille l'étape « produire » : comment plusieurs agents fabriquent en parallèle,
avec une vérification qui tourne sans humain. Méthode rodée les 26 et 27 août 2026
sur le dépôt `AlanZien/pilotage-sandbox` (10 PR mergées, 2 features terminées, 126 tests verts)._

---

## 1. Pourquoi

Trois idées, tirées de deux vidéos (analyse critique complète en annexe
`sources/analyse-videos-2026-08-26.md`) :

1. **Le goulot n'est plus d'écrire le code, c'est de le vérifier.** Tant que la
   vérification, c'est un humain qui lit en direct, on reste « moniteur d'auto-école »,
   le pied sur le frein. Il faut une boucle de vérification qui tourne sans lui.
2. **Quatre chantiers pour y arriver** : le contrat (`CLAUDE.md`, tout ce qu'on répète à
   l'oral) ; l'examen (une commande de tests que l'agent lance lui-même) ; les bacs à sable
   (un dossier isolé par agent, commandes sûres pré-autorisées) ; la relecture (un agent neuf
   qui n'a pas écrit le code, avec un seul mandat : trouver ce qui casse).
3. **Un agent est un poste, pas un outil.** Chaque poste a une fiche : périmètre, docilité
   (l'exécutant obéit, le relecteur contredit), effort, disjoncteurs (budget, accès).

Deux tests pour savoir si on y est : « un ingénieur l'aurait-il fait comme ça ? » avant chaque
sortie d'agent ; « puis-je lancer deux chantiers le matin et partir deux heures ? ». Si la
seconde question fait peur, c'est la boucle qu'il faut renforcer, pas la tolérance au risque.

Sources : Cherny, « Steps of AI Adoption » (16/07/2026) ; vidéo 1
<https://www.youtube.com/watch?v=8ZJI4uCp6bA> ; vidéo 2
<https://www.youtube.com/watch?v=Nmu1-eILb9g> ; vidéo 3 (Factory « Missions »)
<https://www.youtube.com/watch?v=ow1we5PzK-o> ; Cognition, « Making Fable Cheaper Than Opus ».
À retenir : la méthode. Les chiffres (METR, +441 %, jauge en tokens) sont des directions, pas
des certitudes.

---

## 2. La recette

### 2.0 Place dans le circuit

La boucle commence quand le découpage est validé (feature « Planifiée » dans Linear) et se
termine quand les PR sont ouvertes avec leur rapport d'audit. Avant : cadrage et découpage,
avec l'humain. Après : merge humain, puis apprentissage. Le tout est décrit dans la Partie B
du document pilotage ; l'humain ne lance la boucle que par `/pilot run <feature>`.

### 2.1 Vue d'ensemble

```
Feature Linear (découpée en livraisons disjointes)
        │
        ▼
 ┌──────────────┐   ┌──────────────┐
 │ Producteur A │   │ Producteur B │   ← 1 worktree + 1 MISSION.md chacun
 └──────┬───────┘   └──────┬───────┘
        ▼                  ▼
   Relecteur (verifier) — n'a pas écrit le code, signale, ne corrige pas
        │
        ▼
   Correcteur — liste fermée de corrections, rien d'autre
        │
        ▼
   PR (rapport d'audit joint)  →  merge HUMAIN  →  décisions gravées dans Linear
```

Une itération complète = 18 à 25 minutes par livraison, mesuré sur le bac à sable.

### 2.2 Les cinq briques

| Brique | Ce que c'est | Détail |
|---|---|---|
| **Tâches disjointes** | Deux livraisons qui ne touchent pas les mêmes fichiers, **fichiers de tests compris** (un fichier de tests par livraison). | Les points de contact voulus (navigation partagée, `UAT.md`) se règlent au merge, ~20 min. C'est une compétence de découpage, pas d'outil. |
| **Un worktree par agent** | Un *worktree* est un second dossier de travail Git branché sur le même dépôt, sur sa propre branche. | `git worktree add ../<nom> -b feature/<CODE>-<n>-<slug>`. Si A casse tout dans son dossier, B ne le voit pas. |
| **Un `MISSION.md` par worktree** | L'ordre de mission de l'agent : périmètre strict, examen obligatoire, STOP après la PR. | Gabarit en 2.3. Fichier exclu de git via `.git/info/exclude`. |
| **Commandes pré-autorisées** | La liste des commandes sûres dans `.claude/settings.json`, versionnée. | Tests, git local, lectures, quelques outils Linear. Réseau, suppressions, merge restent en manuel. `settings.local.json` (hors git) pour `gh pr create`. Voir 2.4. |
| **Producteur TDD** | Le producteur est la fiche de poste `tdd-writer` : test rouge → code minimal → test vert → refactor, un commit par transition. Il refuse d'écrire du code avant un test. | `~/.claude/agents/tdd-writer.md`. Le `MISSION.md` est sa partie variable. Sur le sandbox du 26/08, les producteurs étaient génériques : tests présents, mais rien ne prouvait qu'ils précédaient le code. |
| **Relecteur indépendant** | Un agent qui n'a pas écrit le code audite le diff avant tout merge. | Agent `verifier` (`~/.claude/agents/verifier.md`), read-only. Jamais de merge sans lui. Il vérifie aussi, dans l'historique, que chaque test précède le code qu'il couvre. |

### 2.3 Le gabarit `MISSION.md`

Versionné dans le sandbox : `.pilot/MISSION.template.md`. Six sections ; les crochets sont
la partie variable, remplie depuis Linear à chaque livraison.

```markdown
# MISSION — <CODE Linear> <titre de la livraison>

## Ta mission
- Feature Linear : <nom> — livraison <n>/<total> « <titre> »
- Tâches : <CODE>-a, <CODE>-b (lire chaque fiche avant de commencer)
- Branche : feature/<CODE>-<n>-<slug> (déjà créée, tu es dessus)

## Périmètre STRICT
Tu touches uniquement : <fichiers>. Tu ne touches jamais : les autres modules,
CLAUDE.md, .claude/, .pilot/. Un autre agent travaille en parallèle :
tout chevauchement sera un conflit au merge.

## Règles du projet (rappel, détail dans CLAUDE.md)
- <idiomes de code du projet>
- Une décision produit ou d'architecture non couverte par la fiche : tu ne tranches pas.
  Tu la notes dans « Décisions à prendre » et tu prends l'option la plus réversible.

## Examen obligatoire avant de te déclarer fini
1. <commande de tests> : tout vert, sortie collée dans le rapport.
2. Relire ton diff contre les idiomes, ligne par ligne.
3. Chaque « Terminé quand » : constaté (comment ?) ou refusé (pourquoi ?).

## Livraison
Ordre imposé à chaque tâche : test rouge (commit `test:`), code minimal (commit `feat:`/`fix:`),
refactor. Jamais de code de production sans test rouge préalable.
Commits atomiques, tâche finie → « Terminée » dans Linear, push, PR titrée
`<CODE>-<n> <titre>`, dernière ligne `Closes <CODE>-a, <CODE>-b`.
STOP après la PR. Pas de merge, pas de tâche suivante, pas de « tant que j'y suis ».

## Rapport final
Ce qui change (3 lignes) · sortie réelle des tests · « Terminé quand » constaté/refusé
par tâche · décisions à prendre · écarts au périmètre.
```

D'où vient chaque section quand on la remplit :

| Section | Source |
|---|---|
| Périmètre, tâches, critères | Fiches Linear de la livraison |
| Décisions produit déjà prises | Fiche feature Linear, section « Décisions produit » |
| Règles de fabrication | `CLAUDE.md` du dépôt, section idiomes |
| Commande d'examen | `CLAUDE.md` du dépôt |
| Nom de branche, titre de PR, format de commit | Conventions pilotage |
| Fin de mission, rapport | Invariants de la boucle (ce document) |

Le `MISSION.md` est jetable parce que tout ce qu'il contient de durable vit ailleurs.

### 2.4 L'allowlist de référence

`.claude/settings.json` du sandbox :

```json
{
  "permissions": {
    "allow": [
      "Bash(node --test:*)",
      "Bash(git status:*)", "Bash(git diff:*)", "Bash(git log:*)",
      "Bash(git add:*)", "Bash(git commit:*)", "Bash(git push:*)", "Bash(git branch:*)",
      "Bash(ls:*)", "Bash(cat:*)", "Bash(grep:*)", "Bash(find:*)",
      "Bash(head:*)", "Bash(tail:*)",
      "mcp__linear__get_issue", "mcp__linear__list_issues", "mcp__linear__get_project",
      "mcp__linear__save_issue", "mcp__linear__save_project", "mcp__linear__save_comment"
    ]
  }
}
```

Adapter la commande de tests au projet. Ne jamais y mettre : suppression, merge, réseau
autre que `git push`.

### 2.5 Deux façons de lancer un agent

| Mode | Quand | Propriétés |
|---|---|---|
| **Session indépendante** (pane cmux dans le worktree) | Travail long, doit survivre, doit être visible et interruptible. Les producteurs. | Lit le `settings.json` de son worktree, contexte propre, survit à la session principale. C'est le seul mode qui teste réellement l'allowlist. |
| **Sous-agent orchestré** (lancé par la session principale) | Travail court, borné, dont seule la valeur est le rapport. Relecteurs, correcteurs. | Hérite des permissions de la session principale, invisible, meurt avec elle. |

---

## 3. Trois invariants non négociables

1. **Le merge reste humain.** L'arbitrage ne se délègue pas. Ce n'est pas de la prudence
   décorative : c'est le cas d'échec mesuré (Cognition : déléguer le jugement = −27 points).
2. **Les décisions de fond remontent, elles ne se prennent pas en chemin.** Exemple réel : un
   correcteur a décidé seul de passer le registre des permissions en « refus par défaut ».
   Bonne décision, mais c'était de l'architecture, pas une correction. Dans la boucle, ce
   choix doit s'arrêter et être posé à l'humain. D'où la ligne « tu ne tranches pas » du
   gabarit, puis la gravure de chaque décision validée dans la fiche Linear.
3. **Pas de code sans test préalable, prouvé par les commits.** Des tests écrits après le code
   confirment des décisions, ils n'attrapent pas de bugs (Factory). Le producteur est
   `tdd-writer`, l'historique montre le test avant le code, le `verifier` le contrôle. Ça ne
   change rien au parallélisme : le TDD se joue à l'intérieur d'une livraison, le parallélisme
   entre livraisons. Le contrat de validation (backlog n° 8) fournira les premiers tests rouges.

---

## 4. Ce que l'essai a appris

Chaque leçon avec le fait qui la justifie.

**Tests verts ≠ sûr.** Deux producteurs consciencieux, 32 tests verts, et deux failles
bloquantes (échappement HTML, contrôle de permissions) trouvées uniquement par le relecteur
indépendant. Les deux producteurs avaient reproduit le même défaut d'idiome : seul un œil
extérieur le voit. C'est la découverte n° 1 de l'essai ; la plomberie (worktrees,
permissions) n'était que mécanique.

**Chaque leçon d'audit se grave dans le `CLAUDE.md` du projet.** Les deux failles du matin
sont devenues une section « Idiomes de code » (commit de 21:40). Le soir, huit livraisons qui
manipulaient du texte utilisateur et des mutations ont appliqué ces règles ; les fautes exactes
n'ont pas réapparu, mais une variante (URL de logo non échappée dans un attribut) est passée et
a été attrapée par l'audit. Ce qu'on peut affirmer : le contrat s'enrichit au fil des audits,
et le relecteur reste nécessaire. Ce qu'on ne peut pas affirmer : que c'est la règle écrite,
plutôt que l'imitation du code déjà corrigé que les producteurs avaient sous les yeux, qui a
évité les fautes. Il faudrait l'épreuve comparative (backlog n° 4) pour le savoir.

**Les fiches Linear font le bon métier au bon niveau.** Sur 8 livraisons, aucun agent n'a
livré à côté. La qualité tient sur trois étages : la fiche (intention et résultat observable),
les idiomes du `CLAUDE.md` (exigences transversales), l'audit + l'escalade (ce que ni l'un ni
l'autre ne dit). Une fiche « complète » coûterait plus cher que le code qu'elle décrit.

**Chaque « Terminé quand » doit contenir un constat de refus.** La vingtaine de décisions
remontées et les défauts trouvés à l'audit avaient un motif commun : des cas négatifs (ce qui
doit être refusé) que la fiche ne disait pas. Les fiches qui avaient déjà ce réflexe sont
passées l'audit sans correction.

**Ce qui n'est pas dans la fiche n'existe pas.** L'interface du sandbox est laide parce
qu'aucune fiche n'a commandé du beau. Preuve que les fiches pilotent vraiment. Et personne
dans la boucle ne regarde l'écran : l'audit vérifie la sécurité et la justesse, pas l'œil.

**Le nombre d'agents se déduit, il ne se vise pas.** « Commencer à deux » vient de Cherny ; le
bon nombre = chantiers réellement disjoints × capacité à relire ce qui remonte × budget. Le
soir du 26/08, trois producteurs en parallèle sans incident, parce qu'il y avait trois
livraisons disjointes.

**Parallèle seulement si la disjonction est décidée en amont ; sinon, en série.** Factory
(vidéo 3) a testé dix agents en parallèle sur un même projet et a abandonné : ils se marchent
dessus, dupliquent, prennent des décisions d'architecture incohérentes ; la coordination mange
le gain. Ils exécutent les features une par une et ne parallélisent que les lectures (recherche,
revue). Notre essai a réussi en parallèle parce qu'un humain avait découpé des livraisons
disjointes à l'étape précédente. Les deux sont vrais : le parallélisme est un gain quand la
disjonction est garantie par le découpage, jamais quand on laisse un système découper seul.

**Des PR empilées se mergent dans leur base, pas dans `main`.** Premier `run` réel (Facturation,
27/08, 1 agent à la fois) : chaque worktree avait été créé depuis la branche de la livraison
précédente. Les PR #26 à #29 ont donc été mergées dans la branche d'avant, pas dans `main`, qui
n'a reçu que la livraison 1 ; il a fallu une PR d'intégration (#31). Règle depuis : tout worktree
part de `origin/main`, même en série ; les PR sont indépendantes et se mergent dans n'importe
quel ordre. Si des PR empilées existent quand même : supprimer chaque branche au merge (GitHub
re-cible alors la suivante) ou re-cibler vers `main` avant de merger.

**Un agent = un rôle + un contexte + une durée de vie.** Les producteurs et correcteurs
n'étaient pas des agents installés : des instances jetables de Claude Code, définies par leur
`MISSION.md`. Seul `verifier` est une fiche de poste permanente. Créer une fiche `producteur`
permanente n'a de sens que le jour où quelqu'un d'autre que la session orchestratrice doit
lancer la boucle (workflow encodé, collègue, autre outil).

**La boucle complète tient en une instruction.** Le 26/08 soir : « livre X et Y, boucle
complète » → production → audit → corrections → PR, sans sollicitation, verrouillée par la
commande `/goal` avec le critère « PR ouvertes, auditées sans bloquant ni important, tests
verts, décisions listées ». Trois niveaux d'automatisation existent :

| Niveau | Qui enchaîne | État |
|---|---|---|
| 1 | La session principale, en une instruction | Validé |
| 2 | Un agent orchestrateur qui appelle `tdd-writer` puis `verifier` | Non testé |
| 3 | Un workflow encodé (l'enchaînement fixé par du code, pas par un modèle) | À faire |

**Docilité par contrat, pas par marque de modèle.** L'exécutant a « périmètre STRICT » et
interdiction de réinterpréter ; le relecteur a mandat de contredire. Même modèle partout,
comportements opposés. Le casting par marque (« tel modèle est docile ») est périssable.

---

## 5. Backlog des manques avant d'industrialiser

Ce qui a été mis en place relève du **management** (fiches de poste, docilité par poste,
disjoncteur d'accès, propriété du dispositif). Ce qui manque relève de l'**économie**, de la
**tenue dans le temps** et de la **confiance** nécessaire pour merger moins souvent.

| # | Manque | Pourquoi ça compte | Piste |
|---|---|---|---|
| 1 | Disjoncteur de budget tokens par poste | Rien n'arrête un agent parti en boucle. Le manque le plus sérieux avant de monter en nombre. | Budget par session / par workflow. |
| 2 | Modèle déclaré par poste | Tous les agents ont tourné sur le même modèle. Premier levier de coût (Cognition : meneur cher qui délègue < meneur moyen qui code). Factory ajoute : mettre la validation sur un autre fournisseur que la production, pour qu'ils ne partagent pas les mêmes angles morts. | Champ `model` dans les fiches `~/.claude/agents/`. |
| 3 | Effort déclaré par poste | Max pour arbitrage et revue, contenu pour l'exécution. Pousser partout coûte et fait dériver. | Champ `effort` dans les fiches. |
| 4 | Banc d'essai maison | L'essai a évalué le dispositif, pas les modèles. Recruter un modèle sur un poste se fait sur épreuve comparative. | Deux livraisons identiques, deux modèles, même audit. |
| 5 | Validation de bout en bout | Personne n'ouvre l'application. Factory : un validateur « testeur utilisateur » qui lance l'app, remplit, clique, vérifie les parcours ; c'est là que passe la majorité du temps réel, et c'est ce qui leur permet de ne pas relire chaque PR. Indispensable avant de déplacer le curseur du merge. | Agent qui ouvre l'app dans le navigateur, joue les parcours, audite l'écran comme `verifier` audite le diff. |
| 6 | Fiche `producteur` permanente | Résolu par `tdd-writer` (§ 2.2). Reste à ajouter dans sa fiche les invariants de la boucle (périmètre strict, STOP après PR, décisions signalées non tranchées) pour le niveau 3. | Compléter `tdd-writer.md` ; `MISSION.md` reste la partie variable. |
| 7 | Élaguer les consignes tous les six mois | Les modèles récents ont besoin de moins d'échafaudage (Cherny : « we cut 80 % of the prompt »). | Relire `CLAUDE.md` et skills : retirer ce qui tient debout tout seul. |
| 8 | Contrat de validation à l'échelle de la feature | Nos « Terminé quand » sont par tâche, jamais consolidés. Factory écrit avant tout code la liste de « ce qui devra être vrai », chaque feature devant couvrir ses phrases ; des tests écrits après le code « confirment des décisions, ils n'attrapent pas de bugs ». Prévu à l'étape « Cadrer » du circuit. | Section de la fiche feature Linear ; le découpage affecte chaque phrase à une livraison ; `verifier` contrôle la couverture. |
| 9 | Vue de contrôle | Sur plusieurs heures, un fil de discussion ne montre ni l'avancement ni la dépense. | Un tableau : livraisons finies / en cours, budget consommé, rapports de handoff. Lié au n° 1. |
| 10 | Reprise automatique après audit | Chez nous : audit → corrections → PR, puis stop. Factory enchaîne des jalons regroupant plusieurs livraisons et crée des tâches de suivi sans humain. C'est ce qui autorise « un merge par feature » au lieu d'un par livraison. | Après 1 et 5 seulement. |

---

## 6. Où vivent les choses

| Quoi | Où |
|---|---|
| Ce document (la méthode expliquée) | `Gestion_projet/BOUCLE-AGENTS.md` |
| Analyse critique des vidéos sources | `Gestion_projet/sources/analyse-videos-2026-08-26.md`, `sources/analyse-video-2026-08-27-factory-missions.md` |
| Gabarit MISSION, allowlist, CLAUDE.md d'exemple | `AlanZien/pilotage-sandbox` (banc d'essai) |
| Fiches de poste permanentes | `~/.claude/agents/verifier.md`, `tdd-writer.md` |
| Commandes de pilotage | `~/.claude/skills/pilot/` |
| Recette condensée pour Claude | Mémoire globale `recette-deux-agents-paralleles` |

Toute évolution de la méthode se fait ici d'abord, se teste sur le sandbox, puis s'installe
dans `~/.claude/`.
