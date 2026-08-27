# Analyse de la vidéo « Missions » (Factory) — 27 août 2026

Source : https://www.youtube.com/watch?v=ow1we5PzK-o — Luke, ex-Block (créateur de Goose),
aujourd'hui chez Factory, qui vend « Missions » et l'outil « Droid ».

Réserve : un vendeur décrit l'échelle dont son produit est l'ascenseur. Les chiffres (mission de
16 jours, 50 % du code en tests, 90 % de couverture) viennent de ses propres données sur un
clone de Slack. Non vérifiés en ligne.

## Ce qu'il décrit

- Thèse : le goulot est l'attention humaine, pas l'intelligence.
- Cinq motifs multi-agents : délégation, créateur/vérificateur, communication directe,
  négociation, diffusion. Missions en combine quatre.
- Trois rôles : orchestrateur (planifie, produit un « contrat de validation »), workers
  (contexte neuf, une feature, commit), validateurs (« scrutiny » : tests, lint, revue ;
  « user testing » : lance l'app et clique dedans).
- Le contrat de validation est écrit **avant** le code : des centaines d'assertions,
  chaque feature en couvre certaines. « Des tests écrits après l'implémentation confirment
  des décisions, ils n'attrapent pas de bugs. »
- Handoff structuré en fin de feature : fait, non fait, commandes lancées et codes de sortie,
  problèmes, procédures respectées. Les erreurs se rattrapent aux frontières de jalons.
- **Exécution en série** : dix agents en parallèle ont échoué (conflits, doublons, décisions
  incohérentes). Un seul worker ou validateur à la fois ; parallélisme sur les lectures seules.
- « Mission control » : vue d'avancement et de budget, à la place du chat.
- Modèle par rôle (planification lente, exécution fluide, validation obéissante) ; validation
  sur un autre fournisseur pour ne pas partager les biais.
- Orchestration en ~700 lignes de prompts et de skills, logique déterministe mince, pour que
  le système s'améliore avec chaque modèle.
- L'humain reste : « you describe a goal, you scope through a conversation, you approve a
  plan, then the system handles execution ».

## Confirme notre méthode

Goulot = attention ; producteur ≠ vérificateur ; rapport structuré de fin de mission ;
orchestration en texte plutôt qu'en code ; modèle par poste ; humain au cadrage et à
l'approbation du plan.

## Contredit

Le parallélisme. Réconciliation : chez nous, la disjonction est décidée par l'humain au
découpage ; chez lui, le système découpe seul un projet entier. Règle retenue : parallèle
seulement si disjoint en amont, sinon série.

## Nouveau chez nous

1. Contrat de validation à l'échelle de la feature, écrit avant le code.
2. Validateur « testeur utilisateur » (bout en bout, pas seulement l'œil).
3. Jalons comme point de correction, tâches de suivi automatiques.
4. Vue de contrôle (avancement, budget).

Tout est reporté dans `BOUCLE-AGENTS.md` (§ 4 et backlog § 5).
