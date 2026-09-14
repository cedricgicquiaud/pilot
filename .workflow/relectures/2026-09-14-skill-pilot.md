# Relecture de `pilot/SKILL.md` avec la grille (14 septembre 2026)

Version relue : `main` après la PR #46 (3 420 mots). Une ligne par bloc, la question de
`GRILLE-DE-RELECTURE.md` qui tranche, et la décision. Les numéros de lignes sont ceux de
l'ancienne version.

| Lignes | Bloc | Question | Décision |
|---|---|---|---|
| 1-12 | Description (frontmatter) | pointeur | Garder : elle déclenche, les evals la couvrent. |
| 14-25 | Le principe, la règle unique | Q2 toujours utile | Garder, resserré. |
| 27-37 | Vocabulaire (table) | Q2 toujours utile | Garder. |
| 39-43 | Règle de taille d'une feature | Q2 par branche (roadmap, découpage) | `reference/fiches.md` § Feature. |
| 45-48 | Les jalons ne sont pas obligatoires | Q2 par branche (découpage) | `reference/fiches.md` § Livraison. |
| 50 | « Ne jamais dire projet » | Q5 négation | Réécrit en positif dans la table : un Project Linear se dit feature. |
| 52-57 | Quand la skill s'applique, 1 et 2 | Q6 doublon de la description | Supprimé : la liste des phrases françaises est déjà dans la description. |
| 58-65 | Projet piloté / non piloté | Q2 toujours utile | Garder, resserré. |
| 69-70 | Rien n'est créé sans liste validée | invariant | Garder (une ligne). |
| 71-75 | Le moule | Q2 par branche (roadmap, feature, fix) | `reference/fiches.md` § Le moule. |
| 76-77 | Granularité | Q2 par branche | `reference/fiches.md` § Tâche. |
| 78-79 | Une PR par livraison, nom de branche | Q2 par branche (run, fix) | `reference/git.md` ; une ligne reste dans les invariants. |
| 80-90 | Description de PR au gabarit | Q2 par branche (run, fix) ; Q6 : `.github/PULL_REQUEST_TEMPLATE.md` en est une copie posée par `init` | `reference/git.md` § La PR ; le gabarit GitHub reste une copie d'environnement. |
| 91-98 | Branches et environnements, `release` | Q2 par branche (projets avec release) | `reference/git.md` § Branches. |
| 99-101 | Jamais de push, jamais de merge | invariant ; Q5 | Garder en positif : Claude ouvre la PR et s'arrête ; le verrou refuse le reste. |
| 102-106 | Le contrat précède le code | invariant | Garder, une phrase ; le détail est dans `cadrer.md`. |
| 107-110 | Livraisons disjointes | invariant | Garder, une phrase ; détail dans `cadrer.md` et `produire.md`. |
| 111-114 | Pas de code sans test | invariant | Garder, une phrase. |
| 115-118 | Les décisions remontent | invariant | Garder, une phrase. |
| 119-120 | Compter après création | Q6 : `cadrer.md` l. 193 le fait déjà | `reference/fiches.md` § Après création (source unique) ; `cadrer.md` y renvoie. |
| 121-126 | Taille, labels | Q2 par branche | `reference/fiches.md` § Taille, Labels. |
| 127-133 | Titre = résultat ; « Terminé quand » spécifiques | Q2 par branche | `reference/fiches.md` § Le moule. |
| 134-140 | Caps (initiatives) | Q2 par branche (roadmap avec versions) | `reference/linear.md` § Initiatives. |
| 141-153 | Icônes, couleurs, vues de la frise | Q2 par branche (roadmap) ; Q7 non : rien de tout ça n'est découvrable, l'API refuse sans dire pourquoi | `reference/linear.md` § Icônes et couleurs, § Lire la frise. |
| 154-158 | Priorités | Q2 par branche (roadmap, next, fix) | `reference/fiches.md` § Priorités. |
| 159-168 | Dépendances | Q2 par branche ; deux natures mêlées | Règle (test de l'inversion) dans `fiches.md` ; appels d'API dans `linear.md`. |
| 169-175 | Scénario retenu, réserve | Q2 par branche (roadmap, sync) | `reference/fiches.md` § Dates. |
| 176-178 | Le facteur limitant est le temps humain | Q2 par branche (roadmap) | `reference/fiches.md` § Dates. |
| 182-195 | Outils MCP / script, limites | Q2 : « lire la section Pilot avant d'appeler Linear » est toujours utile, le reste par branche | La phrase reste dans `SKILL.md` § Outils ; le détail dans `reference/linear.md`. |
| 196-203 | Plusieurs workspaces | Q2 par branche (init, projets multi-clients) | `reference/linear.md` § Workspaces. |
| 204-207 | Initiatives au niveau workspace | Q2 par branche | `reference/linear.md` § Initiatives. |
| 208-217 | `gh`, verrou, benchmark, skills voisines | pointeurs | Garder, resserré. |
| 219-234 | Statuts | Q2 toujours utile (next, sync, feature, run) | Garder, resserré : qui pose quoi, quand. |
| 238-247 | Commandes : s'arrêter, lire `reference/` | Q2 toujours utile | Garder. |
| 249-271 | Tables des commandes | Q4 : « Elle s'arrête sur » est le fini-quand | Garder telles quelles. |
| 273-285 | Où vit la méthode, `update` | Q6 : `.claude/METHODE.md` (posé par `install.sh`) et `suivre.md` § `update` disent la même chose | Deux lignes et un renvoi. |
| 287-292 | Le circuit en une ligne | Q2 toujours utile | Garder. |
| 294-299 | Vérification à l'échelle | Q2 par branche (sync, audit) | `reference/fiches.md` § Vérification à l'échelle. |

## Q3, phrases sans effet supprimées

- « Charger leurs schémas via ToolSearch avant usage » : l'agent ne peut pas appeler un outil
  différé sans le charger, l'erreur le lui dit.
- « Gestion de projet classique, quatre étages » : la table le montre.
- « Ne travaille jamais de mémoire » doublait « lis le fichier avant d'exécuter » ; une seule
  formulation, positive, avec la conséquence.

## Q8, mots-ancres

Aucun nouveau. Les mots de la méthode (feature, livraison, tâche, contrat, moule, réserve)
sont définis dans la table ou dans `fiches.md` à leur première apparition.

## Résultat

- `SKILL.md` : 3 420 → 1 327 mots. Le reste (1 846 mots) est réparti dans `fiches.md` (779),
  `linear.md` (668), `git.md` (399) ; l'ensemble passe de 3 420 à 3 168 mots, la différence
  étant les doublons et les phrases sans effet.
- Trois fichiers de référence créés : `fiches.md` (comment s'écrit et se planifie une fiche),
  `linear.md` (l'outil : MCP, API, workspaces, initiatives, frise), `git.md` (branches,
  release, PR, verrou).
- Chaque règle déplacée est atteinte par un pointeur depuis la commande qui l'exécute
  (`cadrer.md`, `produire.md`, `suivre.md`).

## Épreuve (evals, `claude -p`, Sonnet, copies jetables)

| Eval | Ancienne version | Nouvelle version |
|---|---|---|
| 2 `init` dossier vide | lit `cadrer.md`, pose la question « de quoi parle le produit », s'arrête | idem |
| 1 `feature Facturation` | s'arrête avant le cadrage : la connexion `linear` est sur GM5, pas weme-studio | lit `cadrer.md`, interroge Linear (vide), cadre depuis le code et `UAT.md`, lance le `contradicteur`, s'arrête à la validation du cadrage : les cinq assertions de l'eval tenues |
| 0 `next` | même blocage de workspace, propose de corriger l'accès | non rejouée (même environnement) |

La nouvelle version a perdu la garde « team introuvable = mauvais workspace » que l'ancienne
exprimait par « ne jamais supposer le workspace par défaut ». Réintroduite en une phrase dans
`SKILL.md` § Outils et `linear.md` § Workspaces, après l'épreuve. Les evals qui lisent Linear
sont à rejouer une fois la connexion `linear` authentifiée sur weme-studio.
