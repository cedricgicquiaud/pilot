# Session 2026-08-24/25 — workspace Weme-Studio, NEX-7 ajustée, FORGE consolidé

## Fait

### Workspaces Linear
- Workspace renommé agentos-tracker → **weme-studio** (nom + URL ; anciennes URL
  redirigées, MCP et clé API insensibles au slug — liés à l'id interne).
- Clés API multi-workspace posées : `gm5` et `volt-app` (`linear-<slug>.env`,
  `--workspace <slug>`). Mémoire `reference-workspaces-linear` à jour.
- Greg invité dans Weme-Studio, **rôle Admin** accepté.

### Roadmap Nexus / NEX-7
- Feuille de route retrouvée : PR weme-studio/Nexus#406 (branche
  `docs/feuille-route-guemini`, **toujours ouverte**, auteur Greg,
  `tools/nexus-pdf/feuille-route-guemini.html`).
- Comparaison document ↔ roadmap : 7 écarts. Tranchés par Cédric : vocal réaligné
  (Vocal V1 → 15/12, chat = repli, décision au gel), Pennylane reste couloir Cédric,
  graphe conforme au doc (cas d'usage écrit AVANT activation), scoring hors CRM +
  anti-doublon réintégrés (2 jalons ajoutés à Surface proactivité).
- Restent ouverts avec Greg (commentaire sur NEX-7) : capacité réelle (~4 j/sem à
  confirmer), sélecteur multi-espaces (hors doc), origine des « huit actes »
  (le doc ne décrit que 3 scénarios).
- Titres des 11 features validés par Cédric et reportés dans NEX-7 :
  Nexus VPS · Contexte entreprise · Connecteur M365 · Onboarding client ·
  Graphe mémoire · Conformité et données démo · Connecteur Pennylane ·
  Multi-espaces et comptes · Alertes proactivité · Rapprochement CRM et compta ·
  Recette et répétitions. RIEN N'EST ENCORE RENOMMÉ dans les features (attente Greg).
- Message de présentation du pilotage envoyé à Greg (vocabulaire, zéro issue GitHub,
  skill embarquée, NEX-7 à relire ensemble, démo vendredi).

### Bac à sable TST reconstruit (démo vendredi)
- Team **Carnet (TST)** recréée dans Weme-Studio (init_team.py) pour la démo à Greg.
- Reconstitué depuis git AlanZien/pilotage-sandbox : 17 tâches Terminées (liens PR),
  feature « Socle et comptes » Terminée (4 jalons datés 23/08) + roadmap todo-liste
  des 4 features (Gestion des tâches En développement 2/4, Confort d'usage, Comptes
  et partage, Données partout — Planifiées, jalons 22/08→07/09). Aucune initiative.
- **Après la démo : supprimer la team TST** (libère la 2e place du plan gratuit).

### FORGE (dépôt source AlanZien/FORGE)
- PR #2 mergée : crochets Linear optionnels dans les phases (branche
  feature/linear-pilotage qui dormait en local).
- PR #3 mergée : recette = **deux catalogues + campagnes** (retour d'expérience
  Nexus généralisé) — cahier UAT.md par livraison, catalogues Tests automatisés /
  Tests manuels, verdicts uniquement en campagne aux jalons, jamais par PR.

### Nexus
- PR #418 (NEX-8) mergée : 6 fichiers de phase synchronisés avec les templates,
  spécialisations préservées (hook ruff monorepo, recette V2) ; CLAUDE.md slug
  weme-studio. Statuts NEX-8 À faire → En revue → Terminée AUTOMATIQUES (preuve
  du circuit, à montrer à Greg).
- Incident CI : 3 CVE fraîches chromadb 0.5.23 (CVE-2026-45830/-45831/-45833),
  aucun correctif en 0.5.x, montée 1.x = client + serveur ensemble (verrou
  documenté dans pyproject). PR #419 (NEX-9) mergée : `--ignore-vuln` ciblés et
  commentés dans ci.yml. **NEX-10 « Migrer Chroma en 1.x »** créée (Haute,
  bloquée par rien, à prioriser avec Greg ; retirera les exemptions).

### Gabarit de description de PR (déployé aux 4 étages)
- Nouveau gabarit « livraison d'abord » : ligne Feature/livraison, Ce qui change
  (fonctionnel), Comment, Preuve (du constaté, jamais de cases), Hors périmètre,
  Closes. Jamais de copie des fiches (Linear les déplie sous la description).
- Méthode : section « La description de PR : le gabarit » dans
  PILOTAGE-LINEAR-GITHUB-CLAUDE.md (§7) + HTML + skill pilot (globale).
- FORGE PR #4 (08-deliver étape 5 + templates/.github/PULL_REQUEST_TEMPLATE.md
  + install.sh copie .github) ; Nexus PR #420 (NEX-11) ; sandbox PR #9 (TST-18).
- Gabarit des fiches : déjà couvert par les templates de team Linear (init).

### Gabarits d'issues et filet de compte (cascade complète)
- FORGE PR #5 : `templates/.github/ISSUE_TEMPLATE/` (tache.md au moule
  Problème/Action/Terminé quand, bug.md constaté/attendu/reproduire) +
  install.sh les copie. Pour les projets NON pilotés.
- Skill pilotage (globale) : `init` étape 6 pose PULL_REQUEST_TEMPLATE + un
  `ISSUE_TEMPLATE/config.yml` qui neutralise les issues GitHub et renvoie vers
  la team Linear. Méthode §7 mise à jour (skill embarquée Nexus PAS resynchronisée
  pour ça — init ne s'y rejoue pas ; à embarquer dans une future sync).
- Dépôts `.github` créés (publics, mêmes gabarits génériques, Closes #n) :
  AlanZien/.github et weme-studio/.github — hérités par tout dépôt sans gabarits
  propres. Cascade : piloté (init) > FORGE (install) > nu (filet de compte).
- Reporté par Cédric à plus tard : CONTRIBUTING.md, profile/README.md de
  weme-studio, SECURITY.md, workflow-templates.

### Pilot Volt (workspace volt-app, team VLT, dépôt maisonepigenetic-lgtm/ME_app)
- init joué : team VLT, PR #147 (CLAUDE.md, calibration, gabarits) et #148 (skill embarquée,
  .mcp.json linear-volt-app) mergées, VLT-1/2 fermées AUTO (circuit prouvé, y c. rattrapage
  rétroactif par édition de PR quand l'intégration est branchée après coup).
- Croisement 5 sources : git (129 PR + 127 commits directs janv.→avril), issues GitHub
  A1-E4 (fermées NOT_PLANNED 13/08 → docs 56/57), docs/04_ROADMAP + 56 + 57 + 58 (étude
  VOLT Key), Asana « Performers » (114 tâches, échéances fraîches), inventaire code (agent).
- Calibration corrigée : benchmark.py FAUX sur ce dépôt (ne voit que les jours de merge) →
  recalcul commits : 95 jours actifs (3,2/sem), 5 h/jour, S 0,11/M 0,28/L 2,24/XL 8 h.
  À corriger dans la skill : benchmark devrait compter les jours de COMMIT.
- Créé dans Linear volt-app : 3 initiatives (Lancement restreint 12/09, Pivot VOLT Key
  05/12, Corps connecté = réserve), 37 features (20 Terminées dates réelles janv.→août +
  17 à venir dont « Tout s'appelle VOLT » en tête), 15 jalons, 11 tâches isolées.
  Plan séquentiel (1 chantier principal à la fois) : Lancement restreint (25/08→12/09) →
  Zenoti (14/09→03/10) → Pivot 9 semaines (05/10→05/12) → Passation (05/01→15/01, départ
  de Cédric le 15/01). FTMS + Notifications = réserve non datée. Décision VOLT Key : 05/09.
- Asana à passer en lecture seule puis archiver une fois la bascule confirmée.
- 26/08 : couleurs par initiative posées (36 features, historique en gris) ; 6 features du
  pivot renommées en résultat (Coffre santé dans le téléphone, etc.), ancien nom conservé
  sous « Repères techniques ». « Conformité allégée » trouvée ARCHIVÉE (ajustement manuel
  de Cédric ? non tranché).

### Dépendances, glissements et décisions (26/08) — doctrine validée et déployée
- Premier jet appliqué PAR ERREUR sans validation puis entièrement annulé (leçon en
  mémoire : une proposition transférée d'une autre session n'est pas une validation).
  Brainstorm ensuite, plan validé par Cédric (plans/hazy-stirring-umbrella.md).
- Doctrine (skill globale + méthode §4 bis + HTML) : **dépendances rares et réelles**
  (test de l'inversion : on ne relie que si inverser casse) ; **scénario retenu** (la
  frise datée = le plan cru, jamais de retrait de dates derrière une décision ;
  l'alternative = réserve sans dates ; fiche de la tâche-décision décrit les 2 branches,
  avec dueDate) ; **sync recale et raconte** (contrainte des bloquantes, récit des
  décalages, alertes échéances dépassées, marge restante si ligne `Échéance :` dans la
  section Pilot — marge négative = parler périmètre). section-pilot.md : ligne
  `Échéance :` optionnelle.
- Acquis techniques : `projectRelationCreate` type `dependency` uniquement (ancres
  start/end) ; feature↔tâche impossible dans Linear ; Linear ignore `content: ""`
  (un espace fonctionne) ; groupe de labels « Type » = workspace (parentId sans teamId).
- Appliqué volt-app : 7 relations EN ÉTOILE autour de « Coffre santé dans le téléphone »
  (6 features du pivot + Premières ventes ← Sortie TestFlight) — pas de chaîne ; fiche
  VLT-3 complétée (2 branches, dueDate 05/09) ; AUCUNE date modifiée.
- Appliqué Nexus (weme-studio) : 3 relations (Croisement CRM ← Pennylane [écrit dans sa
  description], Recette ← Onboarding et vocal, Recette ← Staging) ; label workspace
  « externe » (groupe Type) ; tâches-portes NEX-14 Consentement tenant M365 (01/10) et
  NEX-15 Accès API Pennylane (01/11), citées dans les fiches des 2 connecteurs ;
  PR #423 (NEX-16) : skill embarquée resynchronisée + `Échéance : 2027-01-15` dans
  CLAUDE.md — à merger par Cédric.
- Reste : resync skill embarquée ME_app + `Échéance : 2026-12-15` (terrain de la session
  Volt) ; « Conformité allégée » toujours archivée (non tranché).

## Prochaines étapes
1. Attente retour Greg sur NEX-7 (3 points ouverts + reformulations) → appliquer
   les renommages, clore NEX-7.
2. Vendredi : démo pilotage sur team TST (montrer aussi stateHistory de NEX-8) ;
   après → supprimer la team TST.
3. Prioriser NEX-10 (migration Chroma) avec Greg ; NEX-2→6 toujours À faire.
4. Faire merger la PR #406 (feuille de route) — document de référence de la roadmap.
5. Côté Greg : git pull Nexus + `/mcp` à sa première session.

## Repères
- Workspace weme-studio ; team NEX b180d640-2b70-4631-bfd8-d7b8e7875f44 ;
  team TST 05617389-cab4-4166-b514-f44af376ca3d ; initiative MVP
  33b78273-27a7-40dc-95c8-616803b9f684.
- Feature Socle et comptes 4b09694e-9ed9-46a6-a00b-d612436059fb ;
  Gestion des tâches 66ffdbda-673c-4ea3-a6be-046765cb64ef.
- Fichiers non commités préexistants dans NEXUS (pas à moi) :
  .workflow/BACKLOG.md, .understandignore, apps/backend/.ua/.
