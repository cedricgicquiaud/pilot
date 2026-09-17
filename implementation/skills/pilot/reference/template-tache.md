## Problème

_Ce qui manque ou ce qui gêne aujourd'hui. Une ou deux phrases, compréhensibles sans lire la feature._
_« Le numéro de facture est saisi à la main : deux factures peuvent recevoir le même. »_

## Ce qu'on fait

_Le résultat visé, pas la manière de coder._
_« Générer le numéro à l'enregistrement, à partir du dernier utilisé. »_

## Terminé quand

_Des constats observables, pas des intentions. **Au moins un refus** : ce qui doit devenir_
_impossible. Une tâche sans refus n'est vérifiée qu'à moitié._

_**Une case par clause** des décisions produit et des phrases du contrat que la tâche porte,_
_recopiée en toutes lettres, sa source entre parenthèses. Une décision de trois clauses fait_
_trois cases : un renvoi « décisions 14 à 17 » laisse la troisième clause sans preuve._

- [ ] _Deux factures créées à la suite reçoivent deux numéros consécutifs (contrat 4)._
- [ ] _Une facture annulée garde son numéro ; le suivant ne le réutilise pas (D6)._
- [ ] _Refus : le champ numéro n'est plus saisissable à la main (D5)._

## Cas de test attendus

_Les cas que la tâche doit prouver, un par ligne, refus compris. Le producteur peut en ajouter,_
_pas en retirer._

- _deux créations successives ; une création après annulation ; une saisie manuelle refusée_
