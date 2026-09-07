# 7 septembre 2026 — Le diagnostic des runs, et ce que les durées cachaient

Cédric demandait ce qui reste à faire sur la méthode, et si l'agent n'était pas « un peu lent
à traiter les features ». La réponse a demandé de relire les mesures, puis de les refaire.

## Ce que les derniers runs ont produit

Sandbox, 04/09 : quatre livraisons en run complet, quatre tâches isolées, un cadrage complet
avec `contradicteur` et `decoupeur`. VOLT_APP, 07/09 : méthode installée, premier `fix` en vingt
minutes. crm-workday, du dossier vide le 04/09 à 18:30 au 06/09 à minuit : étude, PRD, direction
visuelle, team Linear de 13 features, la feature 1 (XL, cinq livraisons) cadrée, produite, mergée
et rétro faite en une journée, la feature 2 cadrée, découpée en neuf, première livraison mergée.

## Première lecture, fausse

La calibration de crm-workday disait : livraison 2.1a, 6,1 h d'agents, dont 161 minutes pour le
relecteur « à relancer les tests et le build ». La note de session en tirait une leçon : couper
la première livraison d'une feature en deux.

Cédric a posé la bonne question : ces durées sont-elles du traitement, ou y a-t-il eu de
l'inactivité ?

## Seconde lecture, mesurée dans les transcriptions

Pour chaque agent : durée d'horloge, temps actif (intervalles de moins de 90 secondes, comme
le fait l'outil) et trous, avec la commande qui les précède.

| Livraison | Horloge | Travail réel | Attente |
|---|---|---|---|
| 1.2a | 48 min | ≈ 50 min | 8 min |
| 1.2b | 70 min | 74 min | 13 min |
| 1.4 | 78 min | 78 min | 0 |
| 1.3 | 81 min | 78 min | 5 min (CI) |
| 2.1a | 6 h 03 | **81 min** | **4 h 38** |

Le travail réel d'une livraison sur une vraie pile est stable : 50 à 80 minutes, quelle que
soit la taille. La 2.1a n'est pas une anomalie de travail. Ses trois trous suivent trois
commandes composées dont un morceau n'était pas dans la liste blanche (`sleep`, `curl`, `echo`,
`git show`, `sort`, `npm run build`), alors que `lsof`, `kill` et `pkill` y étaient. La session
principale ne contient aucun message de Cédric entre 17:36 et 00:01 : les reprises à 19:35,
22:19 et 23:32 sont ses retours devant l'écran. Même motif que les 101 minutes du testeur sur
le sandbox le 04/09.

Le lead avait donc inventé une cause. L'outil de coût n'avait pas pu tourner : la session
était lancée depuis le dossier personnel, et il cherchait les transcriptions sous le chemin du
projet. Les chiffres d'horloge ont été écrits sous l'étiquette « relevé cout-agents ».

## Ce qui a été décidé et fait (PR `docs/attentes-et-liste-blanche`)

1. **Liste blanche de référence complétée** (`BOUCLE-AGENTS.md` § 2.4, `cadrer.md` étape 7) :
   commande de lancement et de build, `git show`, `sort`, `echo`, `lsof`, `ps`, `kill`,
   `pkill`, `sleep`, `curl`. Avec la règle : une commande composée n'est autorisée que si
   chacun de ses morceaux l'est.
2. **Les quatre fiches de la boucle** (`tdd-writer`, `verifier`, `testeur`, `correcteur`) et
   le gabarit disent l'autre côté de la règle : une commande par appel, sans `sleep`, `curl`
   ni `echo` autour ; refusée, elle se note et on continue.
3. **`cout-agents.py`** : trois durées (horloge, actif, attente), la commande avant chaque
   attente de plus de cinq minutes, et la recherche des transcriptions par leur `cwd` — le
   projet ou ses worktrees, d'où que la session ait été lancée. Vérifié sur crm-workday
   (27 agents trouvés, contre zéro avant) et sur le sandbox (66, contre 51).
4. **`run` étape 7** : lire la colonne attente avant d'écrire une cause. **`sync`** : les
   heures réelles sont le temps actif de l'outil, jamais l'horloge ; un chiffre non mesuré
   s'écrit « estimé » et n'entre pas dans la médiane.
5. **`decoupeur`** : la taille se juge en lignes, sur ce que la dernière livraison du projet a
   coûté ; un écran avec API, migration et e2e fait rarement moins de 1 000 lignes ; dans le
   doute, la taille au-dessus. Cinq livraisons sur cinq étaient sous-estimées.
6. **`BOUCLE-AGENTS.md`** remis d'accord avec l'après-midi du 04/09 (le correcteur a tourné en
   run réel) et le 05/09 : deux leçons ajoutées, compteur du backlog n° 10 à deux features
   terminées et deux en cours sur deux projets.

## Ce qui n'a pas été fait, et pourquoi

- La leçon « couper la première livraison d'une feature » : abandonnée, elle reposait sur la
  lecture fausse.
- Le testeur à trois écrans au plus, et la lecture des tâches isolées ouvertes pour ne pas
  re-signaler un défaut connu (le défaut des contrôles à 32 px l'a été trois fois sur
  crm-workday) : à faire, pas dans cette PR.
- Le clic décalé du navigateur piloté quand la fenêtre est zoomée, et le test instable qui
  se diagnostique sur la ligne exacte du run : leçons de crm-workday encore à porter.
- Le backlog n° 10 reste fermé. Les agents sont prêts ; le lead ne l'est pas tant qu'il écrit
  des causes sans lire les trous.

## Prochaines étapes

1. Merger la PR, puis `/pilot update` sur crm-workday et le sandbox.
2. Dans crm-workday : la ligne 2.1a de la calibration passe à 81 minutes réelles (fait dans
   le dépôt du projet, avec la PR de 2.1b).
3. `run` de la livraison 2.1b sur crm-workday. Attendu : moins d'une heure d'horloge, zéro
   attente. C'est le test des corrections de cette PR.
4. Puis deux producteurs en parallèle sur la première feature qui s'y prête.
