# Relecture de `agents/tdd-writer.md` avec la grille (14 septembre 2026)

Version relue : `main` à `8412543` (1 978 mots). Numéros de lignes de l'ancienne version.

| Lignes | Bloc | Question | Décision |
|---|---|---|---|
| 1-9 | Frontmatter | réglages | Garder tel quel (`opus`, 150 tours, décisions du 10/09). |
| 11-12 | Qui tu es | identité | Garder : « tu ne connais pas d'autre façon de travailler » est le trait qui ancre. |
| 14-16 | Qui travaille à côté | Q2 toujours utile | Garder, resserré. |
| 18-19 | Aucune question ; « ne devine pas » | garde-fou ; Q5 | Garder la cible positive (écris ce qui manque, arrête-toi) ; la négation qui la précède tombe. |
| 21-25 | Liste blanche, commande composée | garde-fou | Garder, resserré : l'exemple `pkill ; sleep ; curl` reste, c'est lui qui apprend. |
| 27-34 | Français, pas de signature, phrase d'avancement, conventions du projet | Q3 : « selon les conventions du projet » est un no-op ; le reste change le comportement | Garder sans la dernière phrase. La phrase d'avancement (le panneau) reste : elle est la seule chose visible par l'humain. |
| 37-40 | Ce que tu produis | Q6 : redit la description et « Qui tu es » | Fusionné dans « Qui tu es » (une phrase). |
| 44-49 | Lire `MISSION.md`, les fiches, `CLAUDE.md` | étapes | Garder. Ajouter `CONTEXT.md` (chantier 4c). |
| 50-59 | Le système de design | Q2 par branche (seulement si `.pilot/design/` existe) ; 130 mots | Une ligne dans la fiche ; le détail dans `reference/design-agents.md`, lu seulement dans ce cas. |
| 60-63 | L'outillage de test, fichiers de test existants | Q7 : découvrable, mais dire où regarder change la vitesse | Garder en une ligne. |
| 64-66 | `tests.md` | pointeur | Garder. |
| 67-71 | Ce qui existe déjà | Q4 : « deux ou trois recherches par critère » est une borne | Garder, resserré. |
| 73-75 | Deux arrêts avant la première ligne | garde-fou | Garder. |
| 79-91 | Ton périmètre, tu ne tranches pas | invariants | Garder, resserré ; « le découpage s'est trompé, tu t'arrêtes » est le fini-quand du cas. |
| 95-111 | Phase 1, spécification | Q4 : ajouter le fini-quand | Garder ; « Fini quand : chaque critère est une condition observable, et chaque phrase du contrat de `MISSION.md` en a un ». |
| 115-116 | Un critère à la fois | Q8 : c'est la *tranche verticale* de `tests.md` | Garder, nommer. |
| 120-129 | Rouge | Q6 : trois puces redisent `tests.md` (comportement observable, attendu indépendant) | Garder la mécanique (un cas, échec pour la bonne raison, commit seul) ; les règles du bon test renvoient à `tests.md`. |
| 133-145 | Vert | Q6 (`skip`, simulacre : déjà dans `tests.md` et contrôlés par le `verifier`) ; Q5 (« ne touche pas au test ») | Garder le minimal, la réutilisation, la suite complète, le commit ; « un test qui semble faux se reprend en phase rouge » en positif ; les interdits redondants avec `tests.md` tombent. |
| 149-155 | Refactor | Q2 toujours utile | Garder, resserré. |
| 159-169 | Quand t'arrêter | Q4 : compteurs observables, c'est le modèle | Garder. |
| 173-187 | La clôture | étapes ; Q6 : le gabarit de PR est dans `git.md` | Garder ; renvoi à `git.md` pour la PR. |
| 191-217 | Ce que tu rends | format montré | Garder tel quel. |
| 219-226 | Ce qui n'est pas ton travail | refus (section obligatoire du gabarit) | Garder, sans les deux puces déjà couvertes par les phases (« passer au vert sans échec », « code sans test »). |

## Q3, phrases sans effet supprimées

- « Tu écris le code et les messages de commit selon les conventions du projet. »
- « Sinon le critère se réglera en discussion plus tard… et c'est le code qu'il faudra
  refaire » : justification pour le lecteur, pas pour l'agent.
- « Ce code-là ne serait couvert par aucun test : c'est précisément ce que tu es là pour
  empêcher » : même chose.

## Q8, mots-ancres

*rouge / vert / refactor* (déjà là), *tranche verticale* (défini dans `tests.md`). Rien
d'autre.

## Résultat

- 1 978 → voir le compte dans la PR. Un fichier de référence créé :
  `reference/design-agents.md` (ce qu'un agent fait d'un système de design), lu par le
  `tdd-writer` seulement si `.pilot/design/` existe ; le `verifier` et le `testeur` y
  renverront à leur tour.
- Épreuve : banc TST-B1, même mission, même commit de départ que le 10/09, la fiche réécrite
  sur Opus, puis le `verifier`. Comparé à l'étalon (10/10, 0 bloquant, 4 mineurs, 23 commits,
  11 tests, 11 min, 107 échanges, 11 M).
