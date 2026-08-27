# Session 2026-08-26 — couleurs et renommages Volt, doctrine dépendances / scénario retenu

## Fait

### Volt : lisibilité de la roadmap (validé par Cédric)
- Couleurs par initiative posées sur les 36 features visibles de volt-app : pivot violet
  `#8a6cf0`, lancement bleu `#4ea7fc`, Corps connecté vert `#27ae60`, Zenoti orange,
  Qualité turquoise, Passation rouge, les 20 historiques en gris uniforme `#95a2b3`.
- 6 features du pivot renommées en résultat : Coffre santé dans le téléphone · Les montres
  alimentent le coffre · Questionnaire santé stocké au coffre · Scores calculés dans le
  téléphone · Le coach IA sans données brutes · Entraînement compatible coffre. Ancien nom
  de chantier conservé sous « Repères techniques ». Les 3 autres gardées telles quelles
  (Purge, Environnements séparés, Sortie TestFlight) sur choix de Cédric.

### Incident et leçon
- Une proposition transférée de la session Volt (dépendances + retrait des dates) a été
  appliquée SANS validation, puis entièrement annulée à la demande de Cédric. Leçon en
  mémoire : `feedback-proposition-transferee-pas-validee` — un texte collé d'une autre
  session s'ouvre en discussion, jamais en exécution.

### Doctrine « dépendances, glissements, décisions » (brainstorm puis plan validé)
Trois règles, écrites dans la skill globale, la méthode (§4 bis « Dépendances, décisions
et glissements ») et le HTML (section 3) :
1. **Dépendances rares et réelles** — test de l'inversion : on ne relie deux features que
   si inverser l'ordre casse ; sinon c'est la file de passage, les dates suffisent.
2. **Scénario retenu** — la frise datée = le plan cru, jamais de retrait de dates derrière
   une décision ; l'alternative = features en réserve sans dates ; la fiche de la
   tâche-décision décrit les deux branches et porte une dueDate.
3. **`sync` recale et raconte** — recalcul complet dans les deux sens (retard ET avance),
   jamais une feature avant la fin de sa bloquante, réserve intouchée ; récit d'ouverture :
   décalages, alertes sur échéances dépassées (tâches-décisions soulignées), marge restante
   si la section Pilot porte une ligne `Échéance :` (marge négative → parler périmètre).
   `reference/section-pilot.md` : ligne `Échéance :` ajoutée.

### Applications (comptages vérifiés)
- **volt-app** : 7 relations EN ÉTOILE autour de « Coffre santé dans le téléphone »
  (6 features du pivot + Premières ventes ← Sortie TestFlight) — pas de chaîne ; fiche
  VLT-3 complétée (2 branches oui/non, dueDate 05/09) ; AUCUNE date modifiée.
- **Nexus (weme-studio)** : 3 relations (Croisement CRM ← Pennylane — dépendance qui
  dormait dans sa description —, Recette ← Onboarding et vocal, Recette ← Staging) ;
  label workspace « externe » créé dans le groupe Type ; tâches-portes NEX-14
  « Consentement du tenant M365 » (échéance 01/10) et NEX-15 « Accès API Pennylane »
  (01/11), citées dans les fiches des deux connecteurs.
- **Dépôt Nexus** : PR #423 (NEX-16) MERGÉE — skill embarquée resynchronisée +
  `Échéance : 2027-01-15` dans le CLAUDE.md ; NEX-16 passée Terminée automatiquement.
- **ME_app (par la session Volt)** : PR #153 (VLT-29) MERGÉE — même resync + échéance
  2026-12-15. La doctrine est donc active partout (globale, Nexus, Volt).

### Acquis techniques Linear (vérifiés)
- `projectRelationCreate` : `type: "dependency"` seule valeur acceptée ; ancres
  `anchorType: "start"` / `relatedAnchorType: "end"` ; feature↔tâche impossible.
- Le groupe de labels « Type » est au niveau workspace : `issueLabelCreate` avec
  `parentId` mais SANS `teamId`.
- Une écriture `content: ""` sur un project est ignorée (no-op) ; un espace fonctionne.
  Le contenu d'une fiche est un document collaboratif : écritures fusionnées en différé.

### En parallèle (autres sessions)
- La skill globale a reçu d'ailleurs (session Volt) une règle « Branches et
  environnements » : ligne optionnelle `Release : release` (main = travail, release =
  stable recette/prod, PR main → release mergées par l'humain).
- Volt avance vite : VLT-14→29 (renommage VOLT, dépôt renommé, fiches stores, Recette).

## Prochaines étapes
1. Vendredi : démo pilotage à Greg sur la team TST → puis SUPPRIMER la team TST.
2. NEX-7 : retours Greg attendus (capacité ~4 j/sem, multi-espaces, « huit actes »).
3. NEX-10 (migration Chroma 1.x) à prioriser avec Greg ; PR #406 (feuille de route) à merger.
4. volt-app : « Conformité allégée » toujours archivée — à trancher avec Cédric
  (désarchiver → violet + rattacher au pivot, ou entériner la suppression).
5. Améliorations skill notées : benchmark.py devrait compter les jours de COMMIT (pas de
  merge) ; premier récit « recale et raconte » à observer au prochain next Volt/Nexus.

## Repères
- volt-app : team VLT dfc1ffe2-860e-48d5-badc-6cfd896c6f01 ; Coffre
  52ebad38-bb89-49bf-9d4b-09966c3689ea ; initiative Pivot
  e01b4931-0c3a-48e7-b00b-8c56ebc1907a ; VLT-3 1a6da700-3abb-4190-af86-b66eccfee6db.
- weme-studio : team NEX b180d640-2b70-4631-bfd8-d7b8e7875f44 ; Recette et répétitions
  d7289e82-1452-4054-bb53-ab4d64ef5ea9 ; Connecteur Pennylane
  b7f59225-6006-4e0a-9d84-9d8f7db2293b ; Connecteur M365
  c4062b11-ae27-4f61-98b0-00aec23afd72.
- Plan validé : ~/.claude/plans/hazy-stirring-umbrella.md.
- Fichiers non commités préexistants dans NEXUS (pas à moi) : .understandignore,
  apps/backend/.ua/, docs/product/emails-auth-supabase.md, docs/product/partie-deterministe.md.
