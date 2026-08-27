# Session 2026-08-27 (3) — Circuit complet, FORGE absorbé

## Décisions prises

- Un seul cadre : le pilotage. FORGE disparaît comme nom et comme cadre séparé ;
  ses étapes de tête (cadrage, découpage, pauses) et sa rétro passent en Partie B,
  ses étapes GENERATE/EVALUATE/DELIVER sont remplacées par la boucle agents.
- Merge humain à chaque livraison, partout. Mode autonome supprimé. Le curseur
  bougera (un merge par feature) seulement avec disjoncteur de budget + validation
  de bout en bout.
- Les producteurs ne lisent pas de fichiers de phase : MISSION.md + CLAUDE.md.
- `/pilotage next` doit router depuis les statuts Linear (comme /gsd:next), et
  chaque commande propose la suivante.
- Parallèle seulement si la disjonction est décidée au découpage ; sinon série.

## Fait

- PR #1 sur AlanZien/gestion-projet (branche docs/circuit-complet) : Partie B
  réécrite, BOUCLE-AGENTS.md enrichi (vidéo Factory), source ajoutée, CLAUDE.md.

## À faire ensuite (ordre)

1. Relecture et merge de la PR #1 par Cédric.
2. `~/.claude/CLAUDE.md` global : retirer la section « Workflow FORGE », garder les
   niveaux de profondeur sous une autre forme ; décider du sort des projets FORGE
   existants (weme-studio ?).
3. Skill `pilotage` : `init` cadre (PRD), `feature` ajoute le contrat de validation
   et la disjonction au découpage, `next` route par statut, chaque commande propose
   la suivante ; une commande ou instruction qui lance la boucle.
4. Test de bout en bout sur pilotage-sandbox avec la feature Facturation.
5. Backlog BOUCLE-AGENTS.md §5, en commençant par le disjoncteur de budget.
