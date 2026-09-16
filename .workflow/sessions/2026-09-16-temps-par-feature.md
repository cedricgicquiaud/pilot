# Session du 16 septembre 2026 — où passe le temps d'une feature

Session précédente : `2026-09-15-boucle-plus-legere.md`.

## Fait

- Lecture du run 3.1 de crm-workday (PR #37, 47 commits) : livraison fusionnée 3.1a + 3.1b,
  producteur 2 h en une passe (125 M relus, seuil 70), boucle de contrôle 49 min, 2 h 57
  d'horloge, 2 h 55 d'agents ; lead 8 % des jetons. La session du lead a enchaîné sept heures
  de commandes (cadrage, run 3.0, sync, deux update, run 3.1) jusqu'à sa fin.
- CI de la PR #37 rouge sur `e2e/emails.spec.ts` : « demain » calculé sur minuit UTC, rouge
  entre 00:00 et 02:00 Paris. Relance de la part 2 suffit ; tâche isolée à créer.
- Question de Cédric : « le pilote met de plus en plus de temps ». Analyse des quinze
  livraisons de la calibration : heures d'agents par livraison stables (0,85 à 1,85 h) ; ce
  qui s'allonge est le calendrier hors runs (cadrage, rétro, méthode, jours sans session).
- Branche `docs/temps-par-feature` : quatre règles.
  - `sync` écrit une ligne par feature terminée : calendrier, cadrage, runs, attente de merge,
    le reste, et dit quelle colonne a grossi.
  - `feature` note l'heure de début, l'heure de validation du découpage, le nombre de questions.
  - Une livraison fusionnée sort de la médiane de sa taille ; son producteur se compare au seuil
    multiplié par le nombre de livraisons fusionnées.
  - `next` propose une session neuve (ou `/compact`) avant `run` et `feature`.
  Documents : `PILOTAGE-LINEAR-GITHUB-CLAUDE.md` (le barème ne mesure que la production),
  `BOUCLE-AGENTS.md` § 4 (leçon du 16/09). HTML inchangé : ni statut, ni vocabulaire, ni nommage.

## Reste

- crm-workday : relancer la part 2 de la CI de la PR #37, merger, `/pilot next` dans une
  session neuve. Au sync : 3.1 marquée « fusion de 2 », hors médiane XL.
- Après merge de cette PR : `/pilot update` dans crm-workday avant le run de 3.2.
- La première ligne par feature s'écrira à la fin de la feature 3. Pour les features 1 et 2,
  la reconstituer depuis les journaux si on veut comparer ; pas fait ici.
- Tâche isolée pour `e2e/emails.spec.ts` (fuseau) ; CRM-70 couvre déjà `e2e/vues.spec.ts`.
