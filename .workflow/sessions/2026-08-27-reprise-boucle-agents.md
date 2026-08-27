# Session 2026-08-27 — Reprise : la méthode « boucle agents » entre dans Gestion_projet

_Fichier de passation écrit depuis une session pilotage-sandbox. À lire en ouverture de session
dans ce dossier ; ouvrir en discussion, rien n'est encore validé pour exécution._

## D'où on vient

- 26/08 (session lancée depuis `~`) : analyse critique de deux vidéos YouTube, puis mise en
  place et rodage sur `AlanZien/pilotage-sandbox` d'une boucle agentique : agents en
  parallèle dans des git worktrees, ordre de mission `MISSION.md`, allowlist
  `.claude/settings.json`, audit par l'agent `verifier` (qui n'a pas écrit le code),
  corrections, PR, merge humain. 10 PR mergées, 2 features Linear terminées, 126 tests verts.
- 27/08 : PR #21 mergée sur pilotage-sandbox (TST-54) : gabarit `.pilotage/MISSION.template.md`
  versionné + ligne « Agents en parallèle » dans son CLAUDE.md.
- Ce qui existe en mémoire globale Claude : `recette-deux-agents-paralleles` (la méthode),
  `videos-echelle-cherny-fiches-de-poste` (liens des vidéos + verdicts).
- Les analyses complètes des vidéos (~30 000 caractères) ne sont que dans le transcript
  `~/.claude/projects/-Users-cedricgicquiaud/7bd349b0-1e34-4476-8f77-76f7e7437767.jsonl`
  (messages assistant > 1500 caractères, les 6 premiers).

## Décision prise le 27/08

La méthode se travaille ici, dans `Gestion_projet` (dossier de documentation de la méthode
de pilotage). `pilotage-sandbox` reste le banc d'essai. `~/.claude/` (skill `pilotage`,
agents `verifier`, `tdd-writer`) est la cible d'installation, pas le lieu de travail.

## Proposé, non encore validé

1. `git init` dans `Gestion_projet` + premier commit de l'existant (aucun historique aujourd'hui).
2. Un second document `BOUCLE-AGENTS.md` à côté de `PILOTAGE-LINEAR-GITHUB-CLAUDE.md`
   (lecteurs différents : le pilotage se présente à un client, la boucle agents est la
   cuisine interne). Contenu de départ : recette, gabarit MISSION, synthèse des vidéos,
   conclusion opérationnelle, backlog des manques.
3. Mettre à jour `CLAUDE.md` de ce dossier : deux documents, rôle du bac à sable.

## Backlog des manques à combler avant d'industrialiser

- Disjoncteur de budget tokens par poste.
- Modèle et effort déclarés par poste (exécutant docile / relecteur contradicteur).
- Banc d'essai maison pour recruter un modèle sur un poste.
- Maillon « revue visuelle » (captures navigateur) dans la boucle.
- Fiche `producteur` permanente (boucle hors session, « niveau 3 »).
- Élaguer les consignes accumulées tous les six mois.

## En attente côté pilotage-sandbox

Choix de Cédric : livraison « Interface propre » (CSS seul) et/ou feature Facturation
(dernière du MVP, 5 livraisons), et/ou tâches isolées TST-49 à TST-53.
