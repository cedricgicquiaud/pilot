# Session 2026-08-27 — Reprise : la méthode « boucle agents » entre dans Gestion_projet

_Fichier de passation écrit depuis une session pilotage-sandbox. À lire en ouverture de session
dans ce dossier ; ouvrir en discussion, rien n'est encore validé pour exécution._

## D'où on vient

- 26/08 (session lancée depuis `~`) : analyse critique de deux vidéos YouTube, puis mise en
  place et rodage sur `AlanZien/pilotage-sandbox` d'une boucle agentique : agents en
  parallèle dans des git worktrees, ordre de mission `MISSION.md`, allowlist
  `.claude/settings.json`, audit par l'agent `verifier` (qui n'a pas écrit le code),
  corrections, PR, merge humain. 10 PR mergées, 2 features Linear terminées, 126 tests verts.
- 27/08 : PR #21 mergée sur pilotage-sandbox (TST-54) : gabarit `.pilot/MISSION.template.md`
  versionné + ligne « Agents en parallèle » dans son CLAUDE.md.
- Ce qui existe en mémoire globale Claude : `recette-deux-agents-paralleles` (la méthode),
  `videos-echelle-cherny-fiches-de-poste` (liens des vidéos + verdicts).
- Les analyses complètes des vidéos (~30 000 caractères) ne sont que dans le transcript
  `~/.claude/projects/-Users-cedricgicquiaud/7bd349b0-1e34-4476-8f77-76f7e7437767.jsonl`
  (messages assistant > 1500 caractères, les 6 premiers).

## Décision prise le 27/08

La méthode se travaille ici, dans `Gestion_projet` (dossier de documentation de la méthode
de pilotage). `pilotage-sandbox` reste le banc d'essai. `~/.claude/` (skill `pilot`,
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

## Ajout du 27/08 (soir) — questions ouvertes pour la méthode

- `pilot` est calibré pour l'application web avec tests. Pour couvrir d'autres types de projet, chaque projet devrait déclarer dans sa section Pilot **sa gate** (`Gate : <commande>`) et **son auditeur** (code / visuel / évals) :
  - site web : gate Playwright (comportement, accessibilité axe-core, non-régression visuelle par captures) + relecture des captures contre le cadrage visuel par le `verifier` — Playwright fournit les captures, le jugement esthétique reste une relecture ;
  - mobile : gate longue (build + simulateur), worktrees lourds, captures simulateur à outiller ;
  - skills/agents : la gate, ce sont des évals (cas qui doivent déclencher / ne pas déclencher) ; il faudrait un producteur et un auditeur « évals » (`skill-creator` en a les bases) ;
  - documents : suivi Linear seulement, pas de boucle.
- Maillon « revue visuelle » à formaliser dans BOUCLE-AGENTS.md (décision Cédric 27/08 : pas prototypé sur Carnet, à traiter au niveau méthode).
- Incident du 27/08 à documenter : PR empilées mergées dans leurs branches de base (GitHub ne re-cible que si la branche est supprimée) → règle « supprimer chaque branche après merge » ou « une PR par feature quand n = 1 ».

## Ajout du 27/08 (soir) — ce qui manque à la boucle pour une app mobile React Native (cas réel : Volt)

Ce qui tient tel quel : le pilotage (Linear, branches, PR, cadrage, découpage, sync) et le métier hors écran (TypeScript testable avec Jest → tdd-writer / verifier inchangés).

Ce qui manque, par importance :
1. **Gate composite et lente** : distinguer la gate par livraison (`tsc --noEmit` + `eslint` + `jest`, 10-60 s) de la vérification par feature (build + simulateur, minutes). À déclarer dans la section Pilot (`Gate : <commande>`).
2. **Worktrees coûteux** (node_modules + Pods par agent) : pnpm avec store partagé, ou n = 1 sans worktree pour commencer.
3. **Preuve visuelle absente** : agent qui lance l'app dans le simulateur, navigue et capture (Maestro : parcours YAML + captures ; Detox plus lourd) ; le verifier relit les captures contre le cadrage.
4. **Tests de composants** (React Native Testing Library) dans la gate : c'est là que le contrat de validation d'un écran se prouve sans simulateur.
5. **Cycle de release mobile** : branche `release` déjà prévue, mais décrire build → TestFlight / Play Console ; soumission aux stores toujours humaine ; bump de version et notes de release par agent.
6. **Secrets et allowlist** : `.env`, clés API, certificats de signature exclus des worktrees et de tout ce que l'agent lit ou pousse ; à déclarer dès `init`.

Proposition : avant de lancer la boucle sur Volt, une session de cadrage de la boucle sur ce projet (Expo ou bare ? Jest ? RNTL ? simulateur ?), section Pilot complétée, puis une première feature petite pour mesurer — comme Carnet le 26/08, avec la stack réelle. Les manques constatés alimentent BOUCLE-AGENTS.md.

## Ajout du 27/08 (soir) — Playwright pour les applications web et les sites

Décision Cédric : pas sur Carnet (bac à sable sans dépendance) ; à traiter au niveau méthode.

Ce que Playwright apporte à la boucle, et qui vaut pour les deux types :
- **Comportement** : parcours utilisateur (formulaire envoyé → confirmation, menu au clavier, temps de réponse). Tests classiques, rouges avant / verts après → tdd-writer et verifier les traitent comme du code.
- **Accessibilité** : axe-core intégré (contrastes, ARIA, titres, liens vides). Objectif, dans la gate.
- **Non-régression visuelle** : capture comparée à une référence. Dit « quelque chose a bougé », jamais « c'est laid ».
- **Captures pour l'audit** : Playwright produit les captures ; le jugement esthétique (alignements, hiérarchie, « fait template ») reste une relecture du verifier contre le cadrage visuel. C'est le maillon « revue visuelle ».

Différences :
- **Application web** (React/Next + shadcn) : gate = typecheck + lint + tests unitaires + Playwright sur les parcours critiques (pas tous les écrans : coût). Contrat de validation en deux parties : comportement (Playwright) et visuel (captures relues). Playwright en devDependency, navigateurs téléchargés une fois par worktree (~300 Mo : store partagé ou n = 1).
- **Site web** (vitrine, statique) : peu de logique, le contrat est surtout visuel et éditorial. Playwright devient la gate principale (structure, accessibilité, liens, captures par page et par largeur d'écran) ; le verifier relit les captures ; l'auditeur doit aussi vérifier le contenu (textes, images, SEO de base). Pour Webflow : pas de dépôt de code classique — la boucle s'arrête au pilotage Linear + captures.

À formaliser dans BOUCLE-AGENTS.md : section « Gate et auditeur par type de projet » (app web, site, mobile, skill, document) avec, pour chacun, la commande de gate, ce qui est prouvé par test, ce qui est relu sur capture, ce qui reste humain.
