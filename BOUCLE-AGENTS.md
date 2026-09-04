# La boucle agents — faire travailler plusieurs agents Claude Code sans les regarder

_Document interne. Il complète `PILOTAGE-LINEAR-GITHUB-CLAUDE.md` : la Partie B de ce dernier
décrit le circuit complet d'une feature (cadrer → découper → produire → merger → apprendre) ;
ce document détaille l'étape « produire » : comment plusieurs agents fabriquent en parallèle,
avec une vérification qui tourne sans humain. Méthode rodée les 26 et 27 août 2026
sur le dépôt `AlanZien/pilotage-sandbox` (10 PR mergées, 2 features terminées, 126 tests verts)._

---

## 1. Pourquoi

Trois idées, tirées de deux vidéos (analyse critique complète en annexe
`sources/analyse-videos-2026-08-26.md`, dans ce dépôt) :

1. **Le goulot n'est plus d'écrire le code, c'est de le vérifier.** Tant que la
   vérification, c'est un humain qui lit en direct, on reste « moniteur d'auto-école »,
   le pied sur le frein. Il faut une boucle de vérification qui tourne sans lui.
2. **Quatre chantiers pour y arriver** : le contrat (`CLAUDE.md`, tout ce qu'on répète à
   l'oral) ; l'examen (une commande de tests que l'agent lance lui-même) ; les bacs à sable
   (un dossier isolé par agent, commandes sûres pré-autorisées) ; la relecture (un agent neuf
   qui n'a pas écrit le code, avec un seul mandat : trouver ce qui casse).
3. **Un agent se recrute, il ne s'installe pas.** Chaque agent a une fiche : périmètre, docilité
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
   Relecteur (verifier) + Testeur (testeur) — n'ont pas écrit le code, signalent, ne corrigent pas
   (l'un lit le diff, l'autre regarde l'écran)
        │
        ▼
   Correcteur — liste fermée de corrections, rien d'autre
        │
        ▼
   PR (rapport d'audit joint)  →  merge HUMAIN  →  décisions gravées dans Linear
```

Une itération complète = 18 à 25 minutes par livraison, mesuré sur le bac à sable.

### 2.2 Les briques

Ce tableau dit **pourquoi** chaque brique existe. Le **comment** vit dans la fiche de l'agent ou
dans la skill, et n'est pas recopié ici : deux textes qui décrivent le même mécanisme finissent
par se contredire, et c'est le second qu'on oublie de corriger.

| Brique | Pourquoi elle existe | Le détail |
|---|---|---|
| **Livraisons disjointes** | Deux agents qui modifient le même fichier produisent deux travaux à démêler à la main au moment de les réunir. C'est une compétence de découpage, pas un outil. | `feature`, temps 2 |
| **Un worktree par agent** | Un second dossier de travail branché sur le même dépôt, sur sa propre branche. Si A casse tout dans le sien, B ne le voit pas. | `run`, étape 2 |
| **Un `MISSION.md` par worktree** | La fiche dit la règle, la mission donne la valeur. Sans elle, l'agent ne sait ni quels fichiers il ouvre, ni ce qu'il doit prouver. | `reference/MISSION.template.md` |
| **Commandes pré-autorisées** | L'agent doit travailler sans demander la permission à chaque geste — mais pas n'importe lequel. Réseau, suppressions et merge restent manuels. | § 2.4 |
| **Producteur** | Le test commité avant le code est la seule preuve qu'il a été écrit en premier. Un test écrit après confirme une décision ; il n'attrape pas de bug. | `agents/tdd-writer.md` |
| **Relecteur indépendant** | Celui qui a écrit le code ne voit pas ses propres fautes. Découverte n° 1 de l'essai : deux failles bloquantes trouvées par lui seul, sur 32 tests verts. | `agents/verifier.md` |
| **Testeur** | Il ne lit jamais le diff. C'est ce qui fait de son avis une seconde preuve, et non un doublon du relecteur. | `agents/testeur.md` |
| **Correcteur** | Sa tentation propre n'est pas de bâcler, c'est d'élargir la liste. Un diff qui grossit oblige à tout ré-auditer. | `agents/correcteur.md` |
| **Découpeur** | Le découpage décide si les agents travaillent ou se gênent. Une réponse valable est « ça ne se parallélise pas ». | `agents/decoupeur.md` |
| **Contradicteur** | Un trou trouvé avant le code coûte une phrase à corriger ; le même trou trouvé après coûte une journée. | `agents/contradicteur.md` |

### 2.3 Le `MISSION.md`

Un fichier par livraison, écrit par `run` depuis `reference/MISSION.template.md`, exclu de git.

**Il porte ce qui change d'une livraison à l'autre** : les tâches, les fichiers modifiables, les
décisions produit déjà tranchées, le texte des phrases du contrat à rendre vraies, les idiomes
du projet, la commande de tests, le titre de la PR.

**Il ne porte jamais la façon de travailler** — ordre des commits, périmètre, « tu ne tranches
pas », `UAT.md`, stop après la PR, format du rapport. Tout cela est dans la fiche de l'agent.

Il est jetable parce que tout ce qu'il contient de durable vit ailleurs.

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
| **Session indépendante** (pane cmux dans le worktree) | Travail long, doit survivre, doit être visible et interruptible. Les producteurs. | **Se lance par `claude --agent tdd-writer`** : une session ordinaire ne charge aucune fiche, et n'aurait donc aucune des règles de la boucle. Lit le `settings.json` de son worktree, contexte propre, survit à la session principale. C'est le seul mode qui teste réellement l'allowlist. |
| **Sous-agent orchestré** (lancé par la session principale) | Travail court, borné, dont seule la valeur est le rapport. Relecteurs, correcteurs. | Hérite des permissions de la session principale, invisible, meurt avec elle. |

---

## 3. Trois invariants non négociables

1. **Le merge reste humain.** L'arbitrage ne se délègue pas. Ce n'est pas de la prudence
   décorative : c'est le cas d'échec mesuré (Cognition : déléguer le jugement = −27 points).
2. **Les décisions de fond remontent, elles ne se prennent pas en chemin.** Exemple réel : un
   correcteur a décidé seul de passer le registre des permissions en « refus par défaut ».
   Bonne décision, mais c'était de l'architecture, pas une correction. Dans la boucle, ce
   choix doit s'arrêter et être posé à l'humain. D'où la ligne « tu ne tranches pas » de la
   fiche `tdd-writer`, puis la gravure de chaque décision validée dans la fiche Linear.
3. **Pas de code sans test préalable, prouvé par les commits.** Des tests écrits après le code
   confirment des décisions, ils n'attrapent pas de bugs (Factory). Le producteur est
   `tdd-writer`, l'historique montre le test avant le code, le `verifier` le contrôle. Ça ne
   change rien au parallélisme : le TDD se joue à l'intérieur d'une livraison, le parallélisme
   entre livraisons. Les phrases du contrat, recopiées dans le `MISSION.md`, fournissent les
   premiers tests rouges.

---

## 4. Ce que l'essai a appris

Chaque leçon avec le fait qui la justifie.

**Le premier run complet a tenu (04/09).** Feature « Tableau de bord », deux livraisons de
taille S produites l'une après l'autre, vérifiées ensuite à la main hors de la boucle : 308
tests relancés par un tiers, tous verts ; douze cycles `test:` puis `feat:` dans l'ordre, sans
exception ; aucun test désactivé ni affaibli — les diffs de tests ne contiennent que des ajouts.
Quatre décisions de produit sont remontées au lieu d'être tranchées en chemin. 32 minutes de
travail réel pour un barème qui en prévoyait 30, et **12 minutes d'attente du merge humain** :
le goulot d'étranglement n'est plus l'agent.

Deux réserves. Le `correcteur` ne s'est pas déclenché — rien à corriger sur les deux tours ;
c'est le seul agent qui n'a jamais tourné. Et un run ne prouve pas une méthode : il faut les
quatre ou cinq features d'affilée, sur deux projets, que le backlog n° 10 réclame.

**L'outil vaut mieux que l'agent qui l'imite.** Le `testeur` pilotait le navigateur clic par
clic : 26, 23, 14 et 9 minutes sur quatre passes, jusqu'à 401 échanges et 46 M de jetons relus,
296 appels navigateur. Avec la passe visuelle outillée, la même vérification prend 2,9 et
2,2 minutes, 36 et 28 échanges, 1 M de jetons relus, zéro appel navigateur. Dix fois plus
rapide, quarante fois moins de jetons. Le producteur, lui, n'a pas bougé d'une minute : la
réécriture de sa fiche l'a rendu plus fiable, pas plus rapide. Ce qui coûte cher dans une
boucle d'agents, ce n'est pas de réfléchir, c'est de faire à la main ce qu'un script fait en
dix secondes — et de faire revenir chaque capture d'écran dans la conversation.

**Un chevauchement d'une seule ligne reste un chevauchement.** Les deux livraisons du run
ajoutaient chacune une balise `<script>` à `index.html` et une section à `UAT.md`. Le découpage
les disait indépendantes — c'est vrai de leur code, faux de leur merge. Créer les deux
worktrees d'avance les aurait fait partir du même `main` : les deux lignes au même endroit, un
conflit à démêler à la main. Corrigé dans la fiche du `decoupeur` (le contact se déclare, même
pour une ligne) et dans `produire.md` (un worktree se crée quand son producteur démarre, pas au
début du run).

**Une consigne incomplète se comble en silence (04/09).** Le `correcteur`, éprouvé sur banc
avec six pièges, en passe cinq : il écrit le test avant la correction et le rouge échoue
vraiment, il corrige le défaut visuel sans test et le dit, il ne touche pas à la duplication
que le rapport marque « non retenu » alors qu'elle est à deux lignes de sa correction, il ne
modifie aucun test existant. Le sixième piège était un défaut décrit sans sa cible — « le bouton
n'a pas le bon état au survol », sans dire lequel. Il a choisi un bleu plus foncé, plausible, et
l'a présenté comme une correction ordinaire. Sa fiche disait « ne devine pas » et « arrête-toi
s'il te manque une information » : trop général pour le cas, et impraticable quand quatre autres
défauts restent à traiter. Elle nomme maintenant le cas — un défaut qui ne dit pas ce qu'il
attend va dans « Non corrigé », avec la question qui manque. La leçon vaut au-delà de cet
agent : une règle qui n'a pas de cas nommé ne s'applique pas.

**Une panne silencieuse se cache derrière ce qui marche encore (04/09).** Depuis une semaine,
les PR du sandbox ne portaient plus le lien vers leur fiche Linear. Le symptôme paraissait
cosmétique. La cause ne l'était pas : le dépôt avait changé de propriétaire GitHub, et
l'organisation nouvelle n'était pas déclarée dans l'intégration de Linear, qui ne voyait donc
plus aucune de ses PR. Rien n'avait l'air cassé parce que **les statuts de tâche continuaient
d'avancer** : ce n'est pas l'intégration qui les posait, c'est le producteur, via `save_issue`.
Deux mécanismes faisaient le même travail, l'un est tombé, l'autre l'a masqué. La preuve tenait
en un champ : la fiche de la dernière livraison mergée avait `attachments: []`, celle d'il y a
une semaine portait l'URL de sa PR. `sync` contrôle désormais ce champ à chaque réconciliation.

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
`MISSION.md`. Seul `verifier` avait alors une fiche permanente. **Les six agents en ont une
depuis** (backlog n° 6) : la fiche porte ce qui ne change jamais, le `MISSION.md` ce qui change
d'une livraison à l'autre.

**La boucle complète tient en une instruction.** Le 26/08 soir : « livre X et Y, boucle
complète » → production → audit → corrections → PR, sans sollicitation, verrouillée par la
commande `/goal` avec le critère « PR ouvertes, auditées sans bloquant ni important, tests
verts, décisions listées ». Trois niveaux d'automatisation existent :

| Niveau | Qui enchaîne | État |
|---|---|---|
| 1 | La session principale, en une instruction | Validé |
| 2 | Un agent orchestrateur qui appelle `tdd-writer` puis `verifier` | Non testé |
| 3 | Un workflow encodé (l'enchaînement fixé par du code, pas par un modèle) | À faire |

**Le testeur fait le travail ; l'outillage lui coûte un tiers du temps.** Essai à froid du
28/08 sur la livraison « Recherche et filtres » de Carnet, déjà mergée : compte jetable et
contacts créés par l'interface, 8 cases sur 8 jouées et constatées, console propre, 15 à
20 minutes. Environ un tiers perdu en frictions : `file://` refusé (il faut un serveur local),
deux navigateurs connectés, une extension de mots de passe qui bloque un champ, une session
d'un essai précédent encore ouverte, des captures qui ne survivent pas à la session. Les
trois premières sont réglées dans la fiche ; les autres sont au backlog. Deux cases du
cahier étaient ambiguës (jeu de données non précisé, contact supprimé dans ou hors du
filtre) : même leçon que les « Terminé quand », une case dit sa donnée et son refus.

**Le testeur attrape de vrais défauts, mais pas en jouant le cahier — en regardant l'écran.**
Mesure du 31/08 sur 28 passages de `testeur` (WATIDO, sandbox, PILOT) : sur ~115 cases de
recette déroulées, 108 constatées, et les rares refus portaient souvent sur une case mal
rédigée (« rebuild > 30 s » alors qu'il prend 7 s) plutôt que sur un défaut. Tout ce qui a été
trouvé de réel — huit défauts — venait de la colonne « vu hors cahier » : contour de sélection
invisible (lien `inline` autour d'un SVG `block`, boîtes 0 × 0), bloc de couleur étiré sur toute
la hauteur d'une carte, bouton fixe par-dessus le menu à 375 px, débordement horizontal, titre
caché sous la barre fixe. Aucun n'était visible dans les tests, tous verts, ni dans le diff lu
par `verifier` ; environ une correction sur cinq de la boucle en vient, et chacune a été
verrouillée ensuite par un test. Le rejeu du cahier, lui, coûtait jusqu'à 2,5 min et 4 M jetons
**par case**. D'où la fiche actuelle : la passe visuelle remplace le cahier, le cahier repasse
à l'humain en phase de recette. Contre-épreuve du 31/08 sur le sandbox, nouvelle fiche : 8
minutes, 33 actions navigateur, 6 captures (contre 22 à 36 minutes et ~290 actions pour
l'ancienne), et sept défauts remontés dont trois confirmés dans le code sans ouvrir le
navigateur — aucune règle `:focus` dans la feuille de style, aucun `@media` hors impression.
L'agent a aussi écarté de lui-même un faux positif (un bouton « coupé » qui n'était qu'un
artefact de capture, position mesurée à l'appui).

**Un agent qui n'a pas le droit de lire le code invente sur le code.** Les deux passages du
31/08 ont affirmé, chacun de son côté, que « la feuille de style contient bien une règle
`prefers-color-scheme: dark` mais l'application n'offre pas de bascule ». Vérification : le
projet ne contient aucune règle `prefers-color-scheme`, ni dans sa feuille, ni dans le vendor,
ni dans le HTML — et l'outil le montre sans discuter, l'image sombre étant l'octet pour octet
identique à l'image claire. L'agent avait comblé un trou d'observation par une explication
plausible. La fiche interdit désormais toute affirmation sur le code, et la mesure remplace la
supposition : quand la machine mesure, l'agent n'a plus de trou à combler. C'est la deuxième
raison d'outiller la passe, après le coût.

**Une fiche d'exécution s'écrit à l'envers d'une fiche de jugement.** Les fiches de la boucle
disent *comment faire* : phases numérotées, ordre imposé, gabarit de rapport. C'est ce qu'on veut
d'un agent qui exécute — la reproductibilité est le but. Les deux fiches du cadrage disent *ce qui
fait un bon résultat*, et laissent trouver le chemin. La différence n'est pas cosmétique : une
marche à suivre produit toujours son livrable. Si `decoupeur` avait reçu « rends le tableau des
lots », il aurait rendu un tableau ; il a conclu que cette feature ne se parallélisait pas, chiffré
l'alternative à quatre conflits pour un gain nul, et remonté six décisions produit qu'aucune de ses
consignes ne nommait. Une procédure n'a pas de case « ce que vous me demandez est une mauvaise
idée » ; un mandat, si. Seconde raison, propre au modèle : la documentation d'Anthropic note que
des consignes trop prescriptives, écrites pour les générations précédentes, **font baisser** la
qualité de Fable. Règle retenue : discipline là où l'agent exécute, latitude là où il juge.

**Une règle inventée survit tant que personne ne la vérifie.** L'audit du 01/09 a produit deux
chiffres présentés comme venant de `code.claude.com/docs/en/sub-agents` : « la `description` doit
tenir sous 150 caractères » et « le corps sous 200-500 jetons ». **Vérification du 03/09 : ni l'un
ni l'autre n'est dans cette page.** Elle ne donne aucune limite par fiche. Sa seule limite chiffrée
porte sur la **somme** des descriptions — 15 000 jetons, au-delà desquels Claude Code prévient au
démarrage ; les 27 fiches installées en occupent 6 %. Et sur le corps elle dit l'inverse :
« déplacez le détail dans le prompt système, qui ne se charge que lorsque cet agent tourne ».

Ces deux chiffres allaient faire raccourcir quatre descriptions pour rien. C'est le même motif que
le reste du document, appliqué à la documentation : une affirmation plausible, sourcée en
apparence, que personne n'avait relue. Ce qui reste vrai de cet audit : `name` et `description`
sont les deux seuls champs obligatoires ; une description courte est un bon réflexe, pas une
contrainte de l'outil ; et il existe des champs qu'on ignorait — `maxTurns`, `effort`,
`permissionMode`, `disallowedTools`, `memory`, `skills`, `hooks`, `isolation`.

**Ce que coûte chaque agent, mesuré.** `cout-agents.py` sur les trois projets, moyennes par
agent : producteur 7,5 min, 67 échanges, 3,7 M jetons relus ; correcteur 2,8 min, 26 échanges,
1,1 M ; relecteur 2,6 min, 20 échanges, 0,7 M ; auditeur 2,0 min, 18 échanges, 0,5 M. Le
testeur d'avant : 6,9 min, 96 échanges, 5,3 M, 52 appels de navigateur. Le même écran par la
passe outillée : 2,4 min, 27 échanges, 0,8 M, **zéro** appel de navigateur. Sur le banc
d'essai, l'écart d'un bout à l'autre est d'un facteur 48 sur les jetons relus (39 M pour
`atest-TB1b`, 0,8 M pour `passe-outillee`). Ces chiffres servent de seuils : au-delà du double
de la médiane de son agent, un agent est à regarder, pas forcément à blâmer.

**Un agent ne connaît pas sa dépense, mais il sait compter ses essais.** L'outillage n'expose
aucun compteur de jetons à l'intérieur d'une fiche : un plafond en jetons ne serait pas
observable par celui qui doit le respecter. D'où des points d'arrêt exprimés dans ce que
l'agent voit lui-même — trois essais infructueux sur le même test, dix cycles rouge/vert, une
vingtaine d'échanges pour un audit. C'est moins précis qu'un disjoncteur, mais c'est vérifiable
après coup par `cout-agents.py`, et surtout ça évite le pire : l'agent qui, à force d'insister,
finit par contourner le test au lieu d'échouer proprement.

**L'instrument était le vrai plafond, pas le coût.** L'essai du 31/08 avec le navigateur piloté
par l'extension a buté sur trois des cinq points de la passe : les frappes `Tab` ne parviennent
pas à la page, `resize_window` ne change pas le viewport (bloqué à 1374 px, le repli par iframe
ne rend que l'en-tête), et le thème système est hors de portée. Playwright fixe une largeur
exacte, envoie de vraies frappes, force `colorScheme` et écrit des PNG — les quatre limites
tombent ensemble. Il tourne sur le Chrome déjà installé (`channel: 'chrome'`), donc sans
navigateur à télécharger et sans toucher au profil de l'utilisateur. Sur le tableau de bord du
sandbox, il a nommé le défaut que les deux agents avaient mis 35 actions à approcher :
`button#mailbox-toggle « Boîte aux lettres »`, débordement de 74 px à 375 px. Essai de la fiche
outillée, deux écrans (tableau de bord et agenda) : **0 action de navigateur piloté, 1 min 15 s
de bout en bout, deux défauts remontés** avec leurs valeurs et l'élément fautif nommé, dont un
inédit (à 375 px la semaine de l'agenda est coupée, samedi et dimanche illisibles) — contre 33
et 35 actions pour 8 et 14 minutes sur **un seul** écran avec l'extension. L'agent a joint le
test qui verrouillerait les deux défauts, et il a conclu « il n'y a pas de thème sombre » en
s'appuyant sur l'empreinte identique des deux captures, sans rien avancer sur le code.

**Docilité par contrat, pas par marque de modèle.** L'exécutant a « périmètre STRICT » et
interdiction de réinterpréter ; le relecteur a mandat de contredire. Même modèle partout,
comportements opposés. Le casting par marque (« tel modèle est docile ») est périssable.

---

## 4 bis. Écarts avec les sources

Relecture du 28/08 : ce que les trois vidéos préconisent, contre ce qui est en place.

| Préconisation | Source | Chez nous | Écart |
|---|---|---|---|
| Le contrat (`CLAUDE.md`) | V1 | `CLAUDE.md` + idiomes gravés au fil des audits + `MISSION.md` | Couvert |
| L'examen, tests **et** navigateur | V1 | Tests lancés par le producteur ; `testeur` depuis le 28/08 | Couvert, à inscrire dans `run` |
| Les bacs à sable (worktrees, allowlist, deux agents) | V1 | Rodé, trois producteurs le 26/08 | Couvert |
| La relecture par un agent neuf | V1 | `verifier` | Couvert, découverte n° 1 de l'essai |
| Le test des deux heures (deux chantiers, écran fermé) | V1 | Run Facturation : 1,4 h en une instruction, **un agent, écran ouvert** | Non fait tel quel |
| Pas d'agents en plus avant que la boucle mérite confiance | V1 | Règle « parallèle seulement si disjoint » | Respecté |
| Docilité et effort réglés par agent | V2 | Docilité par contrat ; `effort` posé sur les six agents, `model` sur deux (`fable`) | Couvert le 01/09 |
| Disjoncteurs : budget et accès | V2 | Accès : allowlist ; budget : `maxTurns` sur les six agents, plus un point d'arrêt auto-imposé par fiche | Couvert le 01/09 |
| Recruter un modèle sur épreuve | V2 | `fable` posé sur `decoupeur` et `contradicteur` par jugement, pas par mesure | Backlog 4 |
| Le meneur délègue, ne délègue jamais le jugement | V2, Cognition | Merge humain, décisions remontées | Couvert, invariants |
| Contrat de validation avant le code | V3 | Écrit au cadrage, réparti au découpage, texte recopié dans `MISSION.md`, couverture contrôlée par le `verifier` | Couvert le 02/09 |
| Validateur « testeur utilisateur » | V3 | `testeur` | Couvert, voir backlog 5 |
| Handoff structuré | V3 | Rapport final du `MISSION.md`, audit joint à la PR | Couvert |
| Vue de contrôle (avancement, budget) | V3 | Linear pour l'avancement, rien pour la dépense | Backlog 9 |
| Élaguer les consignes tous les six mois | V2 | Aucune date | Backlog 7 |
| Ne pas piloter au compteur de tokens | V1 (critique) | Pas de jauge | Respecté |

Sur un abonnement Max, le disjoncteur de budget ne protège pas l'argent (plafonné) mais le
quota (fenêtre de 5 h, limite hebdomadaire) : un agent en boucle vide la réserve de tous les
autres. L'unité utile n'est donc pas le dollar mais le nombre d'actions et la durée par
mission, imposés par un hook `PreToolUse`. Nécessaire au moment de fermer l'écran, pas avant.

Ordre retenu le 28/08 : `testeur` dans la boucle de chaque livraison, limité aux cases de la
livraison (fait à froid) ; disjoncteur ; épreuve des deux heures sur le sandbox ; seulement
ensuite un second projet (mobile, Maestro) et deux agents en parallèle.

## 5. Backlog des manques avant d'industrialiser

Ce qui a été mis en place relève du **management** (fiches d'agent, docilité par agent,
disjoncteur d'accès, propriété du dispositif). Ce qui manque relève de l'**économie**, de la
**tenue dans le temps** et de la **confiance** nécessaire pour merger moins souvent.

| # | Manque | Pourquoi ça compte | Piste |
|---|---|---|---|
| 1 | Disjoncteur de budget tokens par agent | **En partie traité le 01/09.** Mesure : `.claude/tools/cout-agents/cout-agents.py <projet> --seuils` lit les transcripts de sous-agents et sort le coût par agent (durée, échanges, jetons écrits et relus, appels navigateur), avec les agents au-dessus des seuils. Garde-fous : chaque fiche porte désormais un point d'arrêt qu'un agent peut observer lui-même (`tdd-writer` : trois essais infructueux sur le même test ou dix cycles ; `verifier` : le double d'une vingtaine d'échanges veut dire qu'il a quitté le diff ; `testeur` : 15 actions de navigateur en secours). Le relevé est **automatique en fin de `run`** (étape 7 de la commande) : le tableau part dans la réponse finale et sa dernière ligne dans `.pilot/calibration.md`, avec les agents hors seuils nommés — la dépense n'est visible qu'à ce moment-là, après plus personne ne regarde. **Corrigé le 01/09** : le disjoncteur existe. `maxTurns` dans le frontmatter d'une fiche coupe l'agent après n tours ; il est posé sur les six agents, à environ le double des échanges mesurés (tdd-writer 150, correcteur 80, decoupeur 70, testeur 60, verifier et contradicteur 50). Les points d'arrêt auto-imposés restent utiles : ils font rendre un rapport partiel au lieu d'être coupé net. | `maxTurns` par fiche + mesure automatique en fin de run + arrêt auto-imposé. |
| 2 | Modèle déclaré par agent | **En partie fait le 01/09** : `model:` accepte `opus`, `sonnet`, `haiku`, `fable`, `inherit` ou un identifiant complet. Posé où le choix était évident — `fable` sur `decoupeur` et `contradicteur`, les deux agents de jugement du cadrage, qui tournent une fois par feature sur du texte court (33 et 21 échanges mesurés). Reste à trancher pour les agents de la boucle : descendre `testeur`, `afix` et `aaudit` sur `sonnet` demande de mesurer ce qu'on y perd, pas de le supposer — c'est le n° 4. | Champ `model` dans les fiches. |
| 3 | Effort déclaré par agent | **Fait le 01/09** : `effort` accepte `low` à `max` dans le frontmatter. Posé selon la nature du travail, pas selon l'importance de l'agent — `xhigh` sur les deux agents de jugement (`decoupeur`, `contradicteur`), `high` sur `tdd-writer` et `verifier`, `medium` sur `testeur` depuis qu'un outil mesure à sa place. | Champ `effort` dans les fiches. |
| 4 | Banc d'essai maison | L'essai a évalué le dispositif, pas les modèles. Recruter un modèle sur un agent se fait sur épreuve comparative. **Déclencheur** : le premier `run` sur le sandbox après la reprise des fiches. `tdd-writer` est le dernier agent à descendre de modèle, pas le premier — un modèle moins capable contourne davantage, et c'est le seul qui écrit du code. Le candidat évident est le `testeur`, dont un outil fait les mesures à sa place. | Deux livraisons identiques, deux modèles, même audit. |
| 4 bis | Le `correcteur` éprouvé | **Fait le 04/09.** Banc à six pièges : 5 sur 6. Réussis : test avant correction avec un rouge réel, défaut visuel corrigé sans test et signalé comme tel, liste fermée respectée alors que la duplication était dans un fichier ouvert à deux lignes de la correction, aucun test existant modifié, suite complète relancée. Raté : un défaut décrit sans sa cible — il a inventé la valeur au lieu de poser la question. Fiche corrigée le jour même. | Fait. Reste à le voir tourner en run réel : les deux livraisons du 04/09 n'ont produit aucun défaut. |
| 5 | Validation de bout en bout | **Fait le 02/09.** La passe visuelle est inscrite dans `run` (étape 4) et dans la fiche du `testeur` ; la moitié « gabarit `MISSION.md` » est devenue sans objet depuis le partage fiche / mission — le moule ne porte plus que le variable. Tranché le 31/08 : **`UAT.md` est le cahier de recette de l'humain**, qu'il déroule lui-même avant mise en ligne ; aucun agent ne le joue ni ne le coche. Le producteur continue de l'écrire (une case par « Terminé quand », non cochée), pour un lecteur qui ne connaît pas le code ; un état vierge de l'application avant chaque passage ; l'instrument mobile (Maestro sur simulateur) au premier projet mobile. Voir aussi 11 et 12. | Section `## Pilot` : `Lancer l'app :`, `Testeur :`. Rapport de `run` en deux colonnes : prouvé (tests, audit, cases jouées) / à relire (esthétique, non testable). |
| 6 | Fiche `producteur` permanente | **Fait le 02/09.** `tdd-writer.md` porte désormais les invariants de la boucle : périmètre strict, « tu ne tranches pas », `UAT.md`, URL des écrans, push, PR, STOP, format du rapport. Le gabarit `MISSION.md` a été allégé d'autant : il ne porte plus que la partie variable. Éprouvé sur banc le 01/09 — l'agent a refusé un piège de périmètre et remonté une décision au lieu de la trancher, alors que son `MISSION.md` était muet sur les deux. | Fait. |
| 7 | Élaguer les consignes tous les six mois | **Première passe faite les 01 et 02/09.** `SKILL.md` : 597 → 276 lignes, le détail des commandes sorti dans `reference/cadrer.md`, `produire.md`, `suivre.md`. Douze règles retirées du moule de mission, quatre définitions de `section-pilot.md`, les six fiches réécrites. Prochaine passe à prévoir vers mars 2027. | Relire `CLAUDE.md` et skills : retirer ce qui tient debout tout seul. |
| 8 | Contrat de validation à l'échelle de la feature | **Fait le 02/09.** La chaîne est complète : le contrat s'écrit au cadrage (10 à 30 phrases, un tiers de refus), le découpage affecte chaque phrase à une livraison, `MISSION.md` en porte **le texte** et plus seulement les numéros, et le `verifier` contrôle qu'un test couvre chacune. Le maillon qui manquait était le texte dans `MISSION.md` : sans lui, le `verifier` lisait « numéros 4, 5, 6 » et n'avait rien à vérifier. _Constat d'origine :_ nos « Terminé quand » étaient par tâche, jamais consolidés. Factory écrit avant tout code la liste de « ce qui devra être vrai », chaque feature devant couvrir ses phrases ; des tests écrits après le code « confirment des décisions, ils n'attrapent pas de bugs ». Prévu à l'étape « Cadrer » du circuit. | Section de la fiche feature Linear ; le découpage affecte chaque phrase à une livraison ; `verifier` contrôle la couverture. |
| 9 | Vue de contrôle | **En partie traité le 01/09** par `cout-agents.py` : après coup, le coût par agent et les agents à regarder. Manque toujours le direct — pendant un run, le fil ne montre ni l'avancement ni la dépense. | Un tableau : livraisons finies / en cours, budget consommé, rapports de handoff. Lié au n° 1. |
| 10 | Reprise automatique après audit | Chez nous : audit → corrections → PR, puis stop. Ailleurs, on enchaîne des jalons regroupant plusieurs livraisons sans humain — c'est ce qui autorise « un merge par feature » au lieu d'un par livraison. **Les conditions n° 1 et n° 5 sont levées depuis le 02/09**, mais on n'ouvre pas ce chantier tant que le flux n'a pas fait ses preuves : quatre ou cinq features d'affilée, sur au moins deux projets, avec les cinq constats de l'étape de validation (aucune demande à un humain, aucune sortie de périmètre, tests relancés par le `verifier`, aucune correction manuelle en cours de run, coût dans les repères). **Première feature au compteur le 04/09** : « Tableau de bord » sur le sandbox, deux livraisons, les cinq constats tenus — sauf que le `correcteur` n'a pas eu de défaut à traiter, donc rien ne dit encore comment la boucle se comporte quand elle en trouve un. Et il manquera encore le n° 9 : enchaîner trois livraisons sans rien voir de ce qui se passe est le cas exact que le merge humain protège. | Après validation du flux sur plusieurs features et plusieurs projets, puis n° 9. |
| 11 | Profil de navigateur dédié aux tests | **Devenu marginal le 31/08** : la passe visuelle tourne sans fenêtre et sans profil utilisateur, donc aucune extension tierce ne peut la bloquer. Le besoin ne subsiste que pour le navigateur piloté gardé en secours (parcours interactif, formulaire à soumettre). | Créer le profil le jour où le secours servira vraiment. |
| 12 | Captures durables | **Résolu le 31/08.** La passe visuelle passe par Playwright (`.claude/tools/passe-visuelle/passe-visuelle.mjs`, Chrome du système, rien à télécharger) : elle écrit ses images en fichiers dans `.pilot/recette/<date>-<écran>/` (dossier ignoré de git) et un `mesures.json` à côté. Reste ouvert : les images restent locales, elles ne s'affichent pas dans la PR — à traiter le jour où le manque se fait sentir. | Fait. |
| 13 | Recherche et contradicteur au cadrage (repris de FORGE, phase FIND) | **Contradicteur fait le 01/09** : fiche `contradicteur`, appelée par `feature` avant la validation du cadrage et par `roadmap` sur la liste proposée. Premier passage sur une feature réelle du sandbox : trois bloquants (un renvoi vers une page qui n'est pas publique, un lien de paiement qui ne peut pas toujours être construit, une livraison non démontrable seule) et six décisions manquantes, tous vérifiés dans le code, en 21 échanges. **Recherche tranchée le 02/09.** Au **PRD** : `init` lance la skill `research-assistant` avant l'entretien — ce qui existe, les standards du domaine, les règles extérieures qui s'imposent ; le document va dans `.pilot/recherche.md`. Systématique, sans question préalable : au moment du PRD personne ne sait encore rien, et une supposition posée là se paie sur toute la roadmap. Au **cadrage d'une feature** : pas de recherche (décision de Cédric). Les questions y sont internes au produit, pas externes ; `WebSearch` et `WebFetch` ont été retirés des outils du `contradicteur`. | Fait. |

---

## 6. Où vivent les choses

**Dans ce dépôt** (`~/Desktop/PILOT`)

| Quoi | Où |
|---|---|
| La méthode expliquée — ce document | `BOUCLE-AGENTS.md` |
| Le circuit complet, présentable à un client | `PILOTAGE-LINEAR-GITHUB-CLAUDE.md` et sa version visuelle `circuit-linear-github-claude.html` |
| Analyse critique des vidéos sources | `sources/analyse-videos-2026-08-26.md`, `sources/analyse-video-2026-08-27-factory-missions.md` |
| Comptes rendus de session | `.workflow/sessions/` |

**Dans `implementation/`** — ce qui s'exécute

| Quoi | Où |
|---|---|
| Les six fiches d'agent | `agents/` : `tdd-writer.md`, `verifier.md`, `testeur.md`, `correcteur.md`, `decoupeur.md`, `contradicteur.md` |
| Les commandes de pilotage | `skills/pilot/SKILL.md` — règles communes et résumé des neuf commandes |
| Le détail des commandes | `skills/pilot/reference/cadrer.md`, `produire.md`, `suivre.md` |
| Comment s'écrit une fiche d'agent | `skills/pilot/reference/AGENT.template.md` |
| Le moule d'ordre de mission | `skills/pilot/reference/MISSION.template.md` |
| Les moules de fiche Linear | `skills/pilot/reference/template-feature.md`, `template-tache.md`, `template-bug.md` |
| Le moule de configuration d'un projet | `skills/pilot/reference/section-pilot.md` |
| Les scripts | `skills/pilot/scripts/` : `init_team.py`, `linear_api.py`, `schedule.py`, `benchmark.py` |
| La recherche préalable au PRD | `skills/research-assistant/SKILL.md` |
| La passe visuelle | `tools/passe-visuelle/passe-visuelle.mjs` (Playwright sur le Chrome du système) |
| Le relevé de coût | `tools/cout-agents/cout-agents.py` |
| Ce qui reste personnel | `global/` : le `CLAUDE.md` de préférences et la skill `rendu-fonctionnel`, copiés à la main dans `~/.claude/` |
| Mémoire de Claude, hors dépôt | `~/.claude/projects/-Users-cedricgicquiaud/memory/recette-deux-agents-paralleles.md` |

**Dans chaque projet piloté** — la copie qui travaille

`./install.sh <projet>` pose `agents/`, `skills/` et `tools/` dans le `.claude/` du projet,
avec un `METHODE.md` qui note la version installée. Cette copie est versionnée avec le projet :
tous ceux qui le clonent travaillent avec la même méthode, et l'historique du projet montre
quelle version a produit quel code.

**La copie ne se modifie jamais.** Une amélioration se fait ici, sur une branche, avec une PR.
Le projet la reçoit quand il relance `install.sh`.

**Sur le banc d'essai** (`AlanZien/pilotage-sandbox`)

L'allowlist, un `CLAUDE.md` d'exemple, et `.pilot/MISSION.template.md` adapté au projet — le
moule porte les idiomes et la commande de tests du dépôt, à reporter quand le moule de
référence change.
