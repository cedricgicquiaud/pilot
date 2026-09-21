# Session du 21 septembre 2026 — le seuil descend à XL, le compteur est réparé

Session précédente : `2026-09-18-comparaison-4-2b-4-2c.md`.

## Fait

- **Les trois PR en attente sont mergées** : #63 (tâches par situation, une case par règle),
  #62 (producteur par tâche) et #64 (comptes rendus des 17 et 18/09).
- **Le seuil de la règle « un producteur neuf par tâche » passe de « L et XL » à « XL »**,
  avant merge de la #62. La mesure qui tranche est la 4.2c du 18/09 : une L de 850 lignes en
  quatre tâches, produite par un seul `tdd-writer` en 45 min, 71 M relus, sans incident ni
  coupure. Une L tient dans une session ; la règle n'y a rien à faire. Sur une XL, ce qu'elle
  achète n'est pas une économie — la 4.2a a relu 293 M contre 150 M pour la 3.1, de taille
  voisine — mais l'absence de coupure : deux XL avaient été tuées en route les 16 et 17/09.
  `produire.md` et `BOUCLE-AGENTS.md` (invariant, leçon du banc, leçon datée 18-19/09) alignés.
- **crm-workday quitte la branche d'essai** : `install.sh` repose la méthode officielle
  (`a45e0c2`) à la place de `1648a13`. Deux fichiers seulement changent, `produire.md` et
  `METHODE.md` — les autres fiches de l'essai étaient déjà identiques. PR #52 du projet.
- **Ménage** : `essai/4-2` et les trois branches mergées supprimées, ici et sur GitHub.
- **`cout-agents` réparé** (PR #65). Il annonçait 11 min d'agents actifs sur la 4.2c, sous
  l'horloge de son seul producteur. Un journal d'agent n'est pas toujours écrit dans l'ordre :
  une relance par message y remet des lignes plus anciennes, l'écart entre deux lignes devient
  négatif, et il était **soustrait** au temps actif — un nombre négatif étant bien « plus petit
  que 90 secondes ». Le `verifier` de la 4.2c, relancé après 34 min de veille, valait −29 min
  à lui seul. Désormais un écart négatif ne compte ni en travail ni en attente.
  4.2c : 11 min → **44 min** ; 2.6a : 1 h 02 → 1 h 17 ; les « −15 min » et « −49 min » du lead
  notés au barème les 16 et 17/09 disparaissent. Vérifié sur 149 transcripts : aucune durée
  négative ne subsiste.

## Reste

- Merger la PR #65 ici, et la PR #52 de crm-workday.
- `/pilot sync` dans crm-workday : réécrire la ligne 4.2c avec 44 min (elle pourra entrer dans
  la médiane L, dont elle était exclue à cause du chiffre faux), et corriger le commentaire du
  barème XL, qui attribue encore le doublement du coût de la 4.2a à un changement de compteur
  alors que la 3.1 était mesurée de la même façon.
- Les trois mesures en cours sur crm-workday : la recette de 4.2b et 4.2c (elle seule tranche
  ce que la PR #63 valait), la 4.2d (XL, confirme le seuil), la ligne « temps par feature » à
  la fin de la feature 4 — la deuxième après la feature 3.
- Huit comptes rendus de session non commités traînent dans `.workflow/sessions/` de
  crm-workday ; `.pilot/calibration.md` y est modifié, il part avec la prochaine PR.
- **Comparaison à trois méthodes (pilot, OMC, Pocock) sur un projet neuf** : menée dans une
  autre session, sur un autre dépôt. Rien à en faire ici tant qu'elle n'a pas rendu.
  Le banc 4.1 contre Pocock (16-17/09) reste la référence des trois changements déjà mergés.
