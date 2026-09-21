# Session du 17 septembre 2026 — les deux PR partent en essai sur la 4.2

Session précédente : `2026-09-16-temps-par-feature.md`.

## Fait

- **PR #61 mergée** (11:47) : le `verifier` cherche deux défauts de concurrence, relus sous
  verrou et lectures hors transaction. Épreuve dans la PR, sur la 4.1b réelle.
- **Deux PR restées en brouillon**, faute d'épreuve concluante : #62 (un producteur neuf par
  tâche sur les L et XL) et #63 (tâches par situation, une case par règle).
- **Branche `essai/4-2`** : merge des deux brouillons au-dessus de `main`, pour les faire
  tourner ensemble sur une vraie livraison. Installée dans crm-workday (`d291a80`, réinstallée
  en `f0e1f8b` pour que `METHODE.md` pointe vers ce dépôt).
- **PR #62 fermée** en posant la branche d'essai. Rien n'était perdu — la branche existe
  toujours —, mais une PR fermée se lit comme une idée abandonnée, et aucun commentaire ne
  disait pourquoi. Rouverte en brouillon le 18/09.
- **crm-workday, cadrage de la 4.2 « Opportunités »** : 14:40 → 16:07, 1 h 27, 65 questions
  (entretien 26, contradicteur 29, découpage 10). Quatre livraisons découpées, **seule 4.2a
  créée dans Linear** — écart assumé à la règle « toutes les tâches de la feature à son
  ouverture », pour voir le résultat de l'essai avant d'aller plus loin.
- **Run 4.2a** (16:51 → PR #49 à 21:09, mergée le 18/09 à 00:00) : première livraison XL
  produite par un producteur neuf par tâche. Aucune coupure de producteur. CI rouge sur deux
  clics enchaînés sans attendre l'URL, corrigée par le lead (`2354428`).

## Reste

- Lire le run 4.2a contre ce que les deux essais promettaient.
- Rouvrir la PR #62 en brouillon, avec la mesure.
