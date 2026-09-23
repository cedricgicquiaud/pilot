# Session du 23 septembre 2026 — le CRM s'arrête, Jev entre au backlog

Session précédente : `2026-09-21-seuil-xl-et-compteur.md`.

## État à la fermeture

- **Le CRM Workday est arrêté.** Dépôt GitHub archivé (lecture seule, PR et rapports d'audit
  conservés), dossier local, conteneur Postgres et volume supprimés.
- **Ses mesures vivent ici** : `sources/mesures-crm-workday/` (barème, roadmap, seize comptes
  rendus, README de provenance), PR #68 mergée.
- **Backlog n° 16 ajouté** (Jev comme outil de tri), PR #67 mergée le 21/09.
- Les trois dossiers du banc 1 (`banc-pocock`, `banc-pocock-avant`, `banc-omc`) sont à la
  corbeille ; `~/Desktop/banc-outils/` et `~/.claude-omc` sont conservés.
- **Le banc 2 n'a pas démarré** : les quatre documents sont prêts depuis le 21/09, l'ordre de
  passage n'est pas tiré.

## Ce qui a été décidé

1. **Arrêter le CRM** (Cédric). Deux raisons : la place Linear était nécessaire ailleurs, et le
   projet a enchaîné les livraisons sans recette, ce qui laisse un doute sur le rendu — un doute
   sans importance pour un terrain d'épreuve, mais qui retire l'intérêt de continuer.
2. **Ne pas faire la recette de 4.2b et 4.2c.** Elle aurait mesuré un rattrapage de six semaines,
   pas la PR #63. Conséquence assumée : **la PR #63 reste sans preuve**.
3. **Ne pas produire 4.2d.** Conséquence : le **barème XL reste à 7,5 h** sans l'arbitrage prévu
   entre les deux familles de mesure (1,5 h par horloge d'un producteur unique, 3,28 h par la
   ligne « Par livraison » de `cout-agents`, qui donnerait 16,4 h par feature).
4. **L'absence de recette sur le CRM n'est pas un constat sur la méthode** (correction de Cédric).
   Le projet servait à éprouver la boucle, pas à livrer ; sur un projet réel comme VOLT, la
   recette humaine se fait après chaque feature et elle est efficace. Précision à porter un jour
   dans `BOUCLE-AGENTS.md` : la recette est humaine, après chaque feature, sur un projet réel ;
   sur un banc de méthode, on l'écarte et on le dit.
5. **Le banc 2 passe devant** les réglages fins. Il éclaire la moitié de la méthode jamais jugée,
   le cadrage. Prix accepté : le seuil XL et les tâches par situation restent sans terrain jusqu'au
   prochain projet réel.

## Jev (backlog n° 16)

Exploré longuement avant d'être rangé au backlog. Ce qu'il faut retenir :

- Accessible **sans la liste d'attente**, par OpenRouter en bêta (`typesafe/jev-1.13`).
- Il ne remplace aucun agent : il ne rédige pas. Il devient un outil qu'un agent appelle, comme
  `passe-visuelle`.
- Places retenues, par ordre : passe exploratoire à côté du `testeur` ; tri « déjà connu /
  nouveau » des défauts ; carte « contrat → tests » pour le `verifier` ; tri d'une CI rouge.
- Écarté : dans les suites de tests (non déterministe), et dans toute décision qui laisse passer.
- Beaucoup d'idées d'application hors méthode ont été examinées puis abandonnées : le terrain est
  déjà occupé (tri d'annonces, veille d'appels d'offres, missions freelance, migration Workday),
  ou le volume est trop faible pour que sa vitesse et son prix comptent.

## Reste

- Les deux teams Linear à archiver ou supprimer : `CRM` (gm5), `BAN` (VOLT-APP, connexion
  `linear-volt-app` en échec 404 le 23/09).
- Les PR #52 et #53 du CRM restent ouvertes sur un dépôt archivé, donc immergeables ; leur contenu
  est déjà ici.
- Trois branches locales à nettoyer un jour dans ce dépôt : `docs/session-21-09`,
  `docs/decision-rester-sur-le-cloud`, `fix/cout-agents-journal-hors-ordre`.

## Prochaine commande

Le banc 2, dans une session neuve : tirer l'ordre de passage (`journal/ordre.md`), créer les trois
dépôts, lancer le premier bras.
