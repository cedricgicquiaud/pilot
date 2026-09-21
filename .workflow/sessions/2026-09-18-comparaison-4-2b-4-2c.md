# Session du 18 septembre 2026 — ce que la 4.2a a dit des deux essais, et le témoin

Session précédente : `2026-09-17-essai-des-deux-pr.md`.

## Fait

- **Lecture du run 4.2a** (XL, ≈ 6 400 lignes, quatre tâches) contre les deux essais.
  - **PR #62 tenue sur son but** : aucun producteur coupé, ni limite de tours, ni mémoire.
  - **Mais le coût double** : 293 M relus et 3 h 41 d'agents, contre 150 M et 2 h 55 pour la
    3.1, de taille voisine et mesurée par la même ligne « Par livraison » de `cout-agents`.
    Les tâches 1 et 2 ont relu 100 M et 96 M : une tâche de livraison XL relit autant qu'une
    livraison L entière. La réserve écrite au sync (« compteur plus honnête ») ne tient donc
    pas : la 3.1 était déjà mesurée de la même façon. À corriger au prochain sync.
  - **PR #63 appliquée à moitié** : les cases sont au bon format et au bon nombre (10 à 15 par
    tâche), mais les tâches restent coupées en couches — « Opportunité : champs, montant et
    bornes », « Liste, vues, palette et recette ». Le `decoupeur` n'a pas suivi la règle du
    découpage par situation de l'utilisateur.
- **PR #62 rouverte en brouillon**, avec la mesure de la 4.2a en commentaire.
- **Montage témoin décidé** pour le tour suivant : 4.2b (XL) avec un producteur par tâche,
  4.2c (L) avec un seul producteur. La règle installée donne un producteur par tâche dès la
  taille L : la consigne doit être donnée à la main au lancement du run.
- **Recoupage par situation avant création** : 4.2b, 4.2c et 4.2d repassées de 7 à 13 tâches,
  chacune portant un geste complet (serveur, écran, tests) et au moins un refus. Trois
  amendements au découpage venus du code de 4.2a. Les 3 jalons, les 13 tâches et une tâche
  isolée (pastille du compte à 375 px) créés dans Linear.
- **Incident de plateforme** : plus aucune commande ne passait. Le hook `verrou-git` échouait
  parce que le Bureau était devenu illisible. Ce n'est pas Python qui avait perdu la
  permission macOS, mais **cmux**, l'application qui lance les commandes — toutes ses sessions
  étaient touchées. Docker Desktop, qui porte le Postgres des quatre postes, était arrêté.
  Permission rendue à cmux, Docker relancé.
- **Tour à deux postes** lancé à 17:49. 4.2c ouvre sa PR #50 à 18:34 ; 4.2b ouvre sa PR #51
  le 19/09 à 00:22, après un arrêt de la session du lead (20:24 → 00:08).

## Mesures du tour

| | 4.2b, un agent par tâche | 4.2c, un seul agent |
|---|---|---|
| Taille | XL, 2 070 lignes, 4 tâches | L, 850 lignes, 4 tâches |
| Jetons relus | 202 M | 71 M |
| Agents actifs | 2 h 51 | 11 min (valeur fausse) |
| Horloge | 7 h 49, arrêt de session compris | 1 h 28 |
| Audit | 1 important | 2 importants |

Deux réserves : les livraisons n'ont pas la même taille, donc le tableau ne tranche pas seul ;
et les 11 min de 4.2c sont sous l'horloge du seul producteur (45 min), donc fausses. La 4.2c
reste hors médiane tant que l'écart n'est pas expliqué.

## Reste

- Merger les PR #50 et #51 de crm-workday, puis la recette. Merge humain.
- `/pilot sync` : les deux lignes au barème, et la correction du commentaire sur le compteur.
- Trancher les PR #62 et #63 avec ces chiffres, en posant 4.2b à côté des XL produites par un
  seul agent (3.1), pas seulement à côté de 4.2c.
- Vérifier l'outil `cout-agents` sur la ligne « Par livraison » de 4.2c.
