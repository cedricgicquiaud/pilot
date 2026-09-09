# Session du 9 septembre 2026 — la vue de contrôle en direct

## Fait

- Tour 1 de crm-workday relu (PR #18 et #19) : les deux PR se mergent dans n'importe quel
  ordre, une migration au plus dans la paire, test avant code sur chaque branche, aucune
  attente de permission. Cédric a mergé les deux le 09/09.
- PR #34 de pilot mergée (outil de coût : worktrees lettrés, alias d'agents, seuils
  recalibrés). Sandbox mis à jour dans la PR #60, troisième commit ; la PR #59 y est devenue
  inutile.
- Backlog n° 9, la vue de contrôle en direct : `cout-agents.py . --direct` dans un second
  terminal (panneau cmux), une ligne par agent en cours, rafraîchie toutes les trente
  secondes ; `--une-fois` pour l'instantané que le lead joint à ses lignes de transition ;
  `--notifier` envoie les alertes en notification macOS par `cmux notify`. Aucune fiche
  d'agent ne bouge. Vérifié sur les journaux du tour 1 et sur trois journaux simulés
  (actif, bloqué, rendu). PR #35, mergée, propagée au sandbox (PR #60).
- Backlog n° 12, les écrans dans la PR : option `--pr` de la passe visuelle, une image JPEG
  par écran (1280 px, clair, 2000 px de haut au plus, 23 Ko mesurés sur le sandbox) dans
  `.pilot/pr/<CODE>/`, commitée par le lead après l'audit et affichée dans le rapport de PR,
  section « Écrans ». Fiche du testeur, `produire.md` (étapes 4 et 5), backlog. Branche
  PR #36, mergée.
- PR #37 (autre session) : le producteur regarde ce qui existe avant d'écrire, banc à quatre
  runs sur le sandbox, backlog 4 ter.
- Sandbox : la méthode est arrivée sur `main` par un push direct (commit 9200095), par erreur —
  un changement de branche avait échoué et la commande a continué sur `main`. Cédric a choisi
  de garder ; PR #60 et #59 fermées sans merge, branches supprimées. Leçon : ne jamais enchaîner
  un `git checkout` et un push avec `;`, seulement avec `&&`.
- Le HTML de présentation est d'accord avec le Markdown : rien à relire.
- Backlog n° 4, le banc des modèles : `testeur` et `verifier` joués deux fois sur TST-91 du
  sandbox, Sonnet contre le modèle actuel. Sonnet ne rapporte que ce que l'outil mesure ou ce
  que les tests disent ; le modèle actuel ajoute à chaque fois un ou deux constats réels,
  vérifiés. Décision de Cédric : le verifier reste (relecteur, il contredit) ; le testeur passe
  sur Sonnet en exécutant pur, le jugement sur l'image revenant à l'humain par les écrans dans
  la PR. Le tdd-writer et le correcteur restent à mettre au banc. PR #39. Première utilisation
  réelle de la vue en direct sur ces quatre agents : elle les a vus, au bon seuil.

## Décidé

- Les fenêtres par agent que Cédric avait vues venaient du mode « équipes » de Claude Code,
  que `pilot` n'utilise pas ; ce mode ne les ouvre plus par défaut depuis la 2.1.179 et
  exigerait tmux ou iTerm2. On ne change pas `pilot` pour ça : la vue en direct dans un
  panneau à côté dit mieux ce qu'on veut savoir.
- Aucun autre changement de méthode après le tour 1 réussi. « Trois producteurs » se
  décidera sur la jauge d'abonnement et la mémoire du Mac après le tour 2.

## Reste

- Rien en attente sur la méthode. `/pilot update` sur crm-workday avant 2.4.
- crm-workday, session du projet : `/pilot update`, `sync`, défaut de la #19 en tâche isolée,
  2.4 seule, puis tour 2 à deux agents.
- Backlog : le banc du tdd-writer (Sonnet contre Fable, même livraison, même audit), n° 10
  (fermé tant que le flux n'a pas prouvé cinq features). « Trois producteurs » se décide après
  le tour 2.
