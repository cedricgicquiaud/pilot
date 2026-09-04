# Session du 3 septembre 2026 — Les documents remis d'aplomb

Après deux jours passés sur les fiches d'agent et la skill, cette session a repris les quatre
documents du dépôt. Le motif est le même partout : **un texte recopié à deux endroits finit par
diverger, et c'est la copie qu'on oublie de corriger.**

## Ce qui contredisait les invariants

Trois endroits proposaient un **merge automatique**, alors que l'invariant n° 1 l'interdit :

- `PILOTAGE` § 10, dans la section `## Pilot` recopiée : « Merge : humain | automatique si tests verts »
- le HTML, carte Claude : « Ne merge jamais **sans gate verte** » — donc il merge avec
- le HTML, étape du merge : « ou tu me laisses merger si la gate est verte (mode autonome) »

Le `CLAUDE.md` du dépôt affirmait par ailleurs que **GitHub fait avancer les statuts de
feature**. C'est faux, et `PILOTAGE` § 5 disait déjà le contraire : GitHub ne touche qu'aux
statuts de tâche, Claude pose ceux de feature.

La règle du merge est désormais écrite avec sa raison, et plus comme une condition technique :

> C'est là que tu réponds aux décisions que les agents ont refusé de trancher : enchaîner sans
> répondre, c'est les laisser deviner tes réponses.

## Une règle inventée, démasquée

Une leçon du 1er septembre affirmait, en citant `code.claude.com/docs/en/sub-agents` :

> La `description` doit tenir sous 150 caractères, et le corps sous 200-500 jetons.

**Vérification faite : la page ne contient ni l'un ni l'autre.** Elle ne donne aucune limite par
fiche. Sa seule limite chiffrée porte sur la **somme** des descriptions — 15 000 jetons, dont les
27 fiches installées occupent 6 %. Et sur le corps elle dit l'inverse : « déplacez le détail dans
le prompt système, qui ne se charge que lorsque cet agent tourne ».

Ces deux chiffres allaient faire raccourcir quatre descriptions pour rien. La leçon a été
réécrite sous le titre « **Une règle inventée survit tant que personne ne la vérifie** ».

C'est le même motif que le reste, appliqué à la documentation : une affirmation plausible,
sourcée en apparence, que personne n'avait relue.

## `BOUCLE-AGENTS.md` — 419 → 384 lignes

**Le § 4 bis et le backlog étaient périmés.** Quatre lignes du tableau des écarts annonçaient
comme manquant ce qui est fait depuis le 1er septembre (`effort`, `model`, `maxTurns`, la
couverture du contrat). Quatre entrées de backlog aussi : n° 5 et n° 8 marqués faits, n° 7
(élaguer les consignes) enregistre la première passe, n° 4 gagne son déclencheur.

**Le doublon avec la skill est parti.** Les briques disent maintenant *pourquoi* elles existent
et renvoient à la fiche pour le *comment*. Le § 2.3 ne recopie plus le moule de mission : il le
décrit en cinq lignes. Le test appliqué : *cette phrase sera-t-elle encore vraie dans six mois si
je modifie les fiches ?*

Détails corrigés : le titre annonçait « cinq briques » pour neuf, et le `correcteur` n'y était
pas ; deux invariants citaient le gabarit au lieu de la fiche, et un chantier terminé au futur.

**Le § 6 pointait vers un dossier qui n'existe pas** (`Gestion_projet/`), y compris depuis le
`CLAUDE.md` global — chargé à chaque session, sur tous les projets. Le tableau est refait en trois
blocs et gagne onze entrées manquantes, dont les deux outils et tout le contenu de `reference/`.

## Le backlog n° 10 — la porte ouverte sans que personne le décide

Sa condition était : « après les chantiers 1 et 5 ». **Les deux sont faits.** La même condition
figurait dans le `CLAUDE.md` du dépôt pour interdire le merge automatique.

**Décision (Cédric) : on n'ouvre pas ce chantier tant que le flux n'a pas fait ses preuves.**
Quatre ou cinq features d'affilée, sur au moins deux projets, avec les cinq constats de
validation. Et il manquera encore le n° 9.

## Le `CLAUDE.md` du dépôt — huit faits faux

« Pas de dépôt git initialisé » (il y en a un) · « 13 sections » (24) · deux agents (six) ·
`run` absent de la liste des commandes · vocabulaire à trois étages, sans « livraison », le mot
le plus utilisé de la méthode · les statuts posés par GitHub · la condition du merge automatique ·
le moule de mission situé dans le sandbox.

La section « Mise en œuvre » a été réduite à un renvoi : l'inventaire n'existe plus qu'au § 6 de
`BOUCLE-AGENTS.md`. Le nom du sandbox en est retiré — reste la règle qui compte :

> Toute évolution se répercute des deux côtés. Un document qui décrit ce que la skill ne fait
> plus est pire que pas de document.

## `PILOTAGE` et le HTML

`PILOTAGE` était en bien meilleur état. Cinq corrections : le sens de l'intégration (c'est Linear
qui reconnaît ses tâches dans ce que fait GitHub, pas l'inverse), le titre du § 3 qui annonçait
trois étages pour quatre, `benchmark` absent des commandes, l'étape 3 du circuit qui disait
« plusieurs en parallèle » et oubliait le `testeur`, et le § 10 qui recopiait une section `Pilot`
périmée.

**Le HTML décrivait la méthode d'avant la boucle agents.** Outre les deux mentions de merge
automatique, il lui manquait trois étapes entières : le cadrage avec son contrat de validation,
le découpage complet, et **toute la vérification** — ni relecteur, ni testeur d'écran, ni
correcteur. Le circuit passe de huit à dix étapes.

## La visibilité pendant un run

Constat partagé : pendant un `run`, le fil ne montre rien entre le lancement et le rapport final.
Consigne ajoutée dans `reference/produire.md` — une ligne par transition, au fil :

```
Livraison 1/3 « Saisie des lignes » — producteur lancé
Livraison 1/3 — PR #42 ouverte, audit en cours
Livraison 1/3 — verifier : 2 points importants · testeur : 1 défaut → correcteur
```

> Un run muet pendant vingt minutes est un run qu'on ne peut pas interrompre au bon moment.

## Le plan de validation, avant toute automatisation

**Les pièces ont été testées, le flux ne l'a jamais été.** `testeur`, `decoupeur` et `correcteur`
n'ont jamais tourné ; les trois autres une ou deux fois, sur des bancs jetables.

1. Un run complet sur le sandbox — on cherche ce qui casse, pas la performance
2. Deux features de plus, même projet — un défaut vu une fois est un accident
3. Un projet différent — il révélera ce qu'on croyait explicite

**Cinq constats à chaque run :** aucun agent n'a demandé quelque chose à un humain · aucun n'est
sorti de son périmètre · le `verifier` a relancé les tests lui-même · aucune correction manuelle
en cours de run · le coût reste dans les repères de `cout-agents.py`.

## Incident : une PR mergée pendant un push

La PR #14 a été mergée à l'instant où les deux commits étaient poussés. **Le merge a pris l'état
de la branche avant le push** : les six fichiers sont restés dehors, sans que GitHub le signale.

Reporté sur une branche neuve `docs/revue-methode`, PR #15, mergée. Leçon pratique : après un
merge, vérifier que les commits attendus sont bien dans `main` (`git merge-base --is-ancestor`).

## Fichiers touchés

Dépôt (PR #15, mergée) : `BOUCLE-AGENTS.md`, `CLAUDE.md`, `PILOTAGE-LINEAR-GITHUB-CLAUDE.md`,
`circuit-linear-github-claude.html`, plus les comptes rendus des 1er et 2 septembre.

Hors dépôt : `~/.claude/CLAUDE.md` (chemin mort), `skills/pilot/reference/produire.md` (consigne
d'annonce), `template-feature.md`, `template-tache.md`, `template-bug.md`, `section-pilot.md`
(les quatre moules réécrits), `agents/contradicteur.md` (outils web retirés).

## Prochaines étapes

1. **Le run complet sur le sandbox** — étape 1 du plan de validation. C'est la vraie suite.
2. Resynchroniser `.pilot/MISSION.template.md` dans le sandbox.
3. Repasser les six fiches aux deux règles de rédaction du 2 septembre : montrer plutôt que
   définir, une phrase une lecture. Elles ont été écrites avant.
4. Les sections 1, 2, 3 et 5 du HTML, non relues au-delà des corrections de fond.
5. Deux branches locales à supprimer : `docs/cadrage-renforce`, `docs/revue-methode`.
