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
  (actif, bloqué, rendu). Branche `feat/vue-de-controle-en-direct`.

## Décidé

- Les fenêtres par agent que Cédric avait vues venaient du mode « équipes » de Claude Code,
  que `pilot` n'utilise pas ; ce mode ne les ouvre plus par défaut depuis la 2.1.179 et
  exigerait tmux ou iTerm2. On ne change pas `pilot` pour ça : la vue en direct dans un
  panneau à côté dit mieux ce qu'on veut savoir.
- Aucun autre changement de méthode après le tour 1 réussi. « Trois producteurs » se
  décidera sur la jauge d'abonnement et la mémoire du Mac après le tour 2.

## Reste

- Merge de la PR de la vue en direct, puis `/pilot update` sur crm-workday avant 2.4.
- crm-workday, session du projet : `/pilot update`, `sync`, défaut de la #19 en tâche isolée,
  2.4 seule, puis tour 2 à deux agents.
- Backlog : n° 4 (testeur sur un modèle moins cher, à mesurer au tour 2), n° 12 (captures
  dans la PR, quand le manque se fera sentir), n° 10 (fermé tant que le flux n'a pas prouvé
  cinq features).
