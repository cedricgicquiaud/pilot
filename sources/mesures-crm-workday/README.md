# Mesures du CRM Workday — projet d'épreuve, arrêté le 23/09/2026

Le CRM Workday (`cedricgicquiaud/crm-workday`, dépôt archivé) a servi de terrain d'épreuve à
la méthode du 04/09 au 21/09/2026 : quatre features, une trentaine de livraisons produites par
la boucle d'agents. Ce n'était pas un produit, et il n'a jamais été mis en service.

**Décision du 23/09** : le projet s'arrête. Le code ne servait qu'à faire tourner la boucle, et
la place Linear était nécessaire ailleurs. Ce dossier garde ce qui reste utile à la méthode.

| Fichier | Ce qu'il contient |
|---|---|
| `calibration.md` | Le barème de charge. Toutes les mesures S, M, L et XL de la méthode en viennent, avec le détail livraison par livraison : agents, jetons, corrections, incidents. |
| `roadmap.md` | Les 13 features et leur découpage, pour comprendre ce que mesurent les lignes du barème. |
| `sessions/` | Les seize comptes rendus de session : les runs, les `sync`, les leçons datées citées dans `BOUCLE-AGENTS.md`. |

**Ce que ces mesures ne disent pas.** La recette humaine n'a jamais été déroulée sur ce projet :
il servait à éprouver la boucle, pas à livrer. La qualité du rendu n'est donc établie que par les
tests, les audits du `verifier` et les captures du `testeur`, tous consultables dans les PR du
dépôt archivé.

**Deux points restent sans arbitrage**, faute de la livraison 4.2d qui n'aura pas lieu :

- le **barème XL** reste à 7,5 h alors que deux familles de mesure cohabitent (horloge d'un
  producteur unique contre ligne « Par livraison » de `cout-agents`, qui donnerait 16,4 h) ;
- la **PR pilot #63** (tâches par situation, une case par règle) reste sans preuve : la recette
  de 4.2b et 4.2c, seule à pouvoir la mesurer, n'a pas été faite.

Le prochain projet réel peut reprendre ces deux questions.
