# Session du 15 septembre 2026 — première feature avec les fiches réécrites, boucle de contrôle allégée

Session précédente : `2026-09-14-refonte-chantier-0.md` (les sept chantiers de la refonte).

## Fait

- Reprise : les PR #44 à #57 de la refonte sont mergées ; PILOT est propre sur `main`.
- crm-workday : PR #29 (méthode à `4670749`, les six fiches réécrites) mergée à 16:32, avant
  le run. PR #30 (CRM-77, tâche isolée) mergée. Feature 3 « Les consultants Workday » cadrée
  dans une autre session : entretien par rounds, six questions au premier round, réponses
  relues ici (réserves posées sur Q3, la société de consultant dans la liste des entreprises ;
  Q4, « occupé jusqu'au » plutôt qu'« en mission » ; Q6, vérifier si les vues portent déjà
  des colonnes avant de bâtir une « liste déclarée »).
- **Run de la livraison 3.0 « Fiche personne recomposée »** (CRM-73), première mesure réelle
  du `tdd-writer` réécrit : producteur 56 min, 16 commits, une passe, contrat couvert ; quatre
  agents 1,33 h actifs, 75 M relus ; lead 15 min, 28 % des jetons. Dans la fourchette des
  livraisons L précédentes (2.5a : 1,62 h ; 2.4 XL : 1,47 h) : le +58 % du banc du 14/09 ne
  s'est pas reproduit. Réserve : refactor sans écran nouveau, le testeur a peu travaillé.
  PR #33 ouverte, auditée, recettée, trois décisions à trancher au merge.
- **PR #58 « Boucle de contrôle plus légère »** (Cédric, autre session, mergée) : quatre règles
  dans `produire.md` et `verifier.md`. Le verifier ne joue que la suite courte et lit la suite
  d'écran dans la CI ; un poste, un serveur ; repasse du testeur seulement pour un défaut
  d'écran ; pas de second audit après correction.
- Ici, branche `docs/lecons-15-09` : `.out-of-scope/second-audit-apres-correction.md`, leçon
  du 15/09 dans `BOUCLE-AGENTS.md` § 4, ce résumé. Dépôt local remis sur `main`.

## Décidé

- Pas de second audit du verifier après le correcteur : la liste fermée, le test par
  correction, la CI et le relecteur humain en tiennent lieu. Ce qui rouvrirait : un défaut
  introduit par une correction, passé en production.
- La collision de serveurs se règle côté verifier (il ne joue plus Playwright), pas côté
  testeur : l'outil de passe visuelle garde le droit de relancer le serveur du poste.

## Reste

- crm-workday : merger la PR #33 après CI verte, en répondant aux trois décisions dans la PR
  (chargeur déclaré par l'objet ; deux fichiers ouverts hors liste par le correcteur ; date et
  nombre en texte jusqu'à 3.1b). Puis `/pilot next` (sync : barème L recalculé, worktree
  `crm-workday-10` supprimé).
- **Avant le `run` de 3.1a : `/pilot update` dans crm-workday** pour recevoir `ee54505`
  (les quatre règles de la PR #58). Sa version installée est `4670749` ; sans l'update, le
  verifier rejoue Playwright sur le poste du testeur.
- 3.1a « Profil consultant » : seconde mesure du `tdd-writer` réécrit, avec écrans cette fois,
  et première mesure de la boucle allégée (cible : une L vers 50 min d'horloge).
- Sandbox : version installée `8412543`, PR #69 (fiches) toujours ouverte ; deux versions en
  retard. Pas urgent tant qu'aucun banc n'y tourne.
- Toujours ouverts depuis le 14/09 : version globale du verrou git dans `command-validator` ;
  evals Linear du sandbox à rejouer après `/mcp` sur weme-studio ; `.pi/liste-blanche.json`
  du sandbox modifié et non commité.
