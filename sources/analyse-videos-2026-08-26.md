# Analyse critique des deux vidéos sources — 26 août 2026

_Annexe brute de `../BOUCLE-AGENTS.md`. Texte issu de la session d'analyse du 26/08/2026, conservé tel quel._

- Vidéo 1 (échelle de Cherny) : https://www.youtube.com/watch?v=8ZJI4uCp6bA
- Vidéo 2 (fiches de poste d'agents) : https://www.youtube.com/watch?v=Nmu1-eILb9g

---

# Vidéo 1 — synthèse

Vous m'avez partagé la vidéo et sa transcription sans préciser ce que vous attendez. Je vous en fais d'abord une synthèse ; dites-moi ensuite ce que vous voulez en faire.

## L'idée centrale

Ce qui bloque la plupart des gens avec les agents de code n'est pas un manque de discipline, mais l'absence d'un système de vérification automatique. Tant que la vérification, c'est vous, vous restez « moniteur d'auto-école » : assis à côté de la machine, le pied sur le frein.

## L'échelle de Boris Cherny (créateur de Claude Code)

| Étape | Situation | Goulot |
|---|---|---|
| 0 | Outil acheté, accès bloqué par l'entreprise | Processus |
| 1 | Un humain, un agent, tout est relu en direct | Votre attention |
| 2 | Une dizaine d'agents en parallèle, chacun isolé, on relit les résultats | Débit de revue |
| 3 | Une centaine d'agents, plus personne ne lit ligne par ligne | Confiance dans la boucle |
| 4 | Un millier d'agents, pilotage par intention | — |

Microsoft a publié une échelle équivalente (auteur, éditeur, directeur, orchestrateur) à partir de ses propres données.

## Les chiffres cités

- Étude METR : les développeurs mesurés 19 % plus lents en 2025 sont passés à environ 18 % plus rapides en 2026. Explication : la courbe d'apprentissage.
- Télémétrie Faros (22 000 développeurs) : temps de revue de code en hausse de 441 %, et 31 % des merges supplémentaires se font sans aucune revue. Les équipes n'augmentent pas leur capacité de vérification, elles l'abandonnent.
- Ramp : l'entreprise médiane dépense 11 $ par employé et par mois en IA. Le top 1 % dépense plusieurs milliers.
- Jauge personnelle en tokens par mois : < 1 M = un chat ; ~10 M = étape 1 ; ~100 M = étape 2 ; 1 Md = une usine. Avertissement : c'est un indice de pratique, pas un objectif (loi de Goodhart).

## Le plan de passage de l'étape 1 à l'étape 2 : quatre chantiers

1. **Le contrat** : un fichier `CLAUDE.md` / `AGENTS.md` qui contient tout ce que vous répétez à l'oral (conventions, commandes, zones interdites).
2. **L'examen** : une commande unique (tests, compilation, linter, test navigateur si interface) que l'agent lance lui-même avant de vous montrer quoi que ce soit. Bonne première tâche : faire écrire les tests par l'agent.
3. **Les bacs à sable** : un git worktree par chantier, permissions réglées une fois pour toutes pour les commandes sûres, approbation manuelle gardée pour réseau, secrets et suppressions. Commencer à deux agents, pas dix.
4. **La relecture** : un agent neuf, qui n'a pas écrit le code, avec un seul mandat : trouver ce qui casse. Vous ne relisez plus que le diff accompagné de ce rapport.

Le niveau d'exigence ne baisse pas ; seul le moment de votre intervention change (à la fin, sur des résultats).

## Deux tests pour savoir si vous êtes monté

- Avant chaque sortie d'agent : « un ingénieur l'aurait-il fait comme ça ? »
- Lancer deux chantiers le matin, fermer l'écran, partir deux heures. Si c'est insupportable, c'est la boucle de vérification qu'il faut renforcer, pas votre tolérance au risque.

## Pièges et nuances

- Le vrai piège est d'ajouter des agents avant que la boucle ait mérité votre confiance.
- Certaines tâches resteront toujours à l'étape 1 (sécurité, paiement).
- Trois questions pour jauger une équipe qui « est passée à l'IA » : combien d'agents en parallèle et isolés comment ; montrez la boucle qui tourne sans humain ; qui relit le livrable et selon quel standard.

## Lien avec votre pratique

Votre workflow FORGE couvre déjà une bonne partie des quatre chantiers : le contrat (CLAUDE.md et règles de phase), l'examen (gate tests + typecheck dans DELIVER), la relecture (phase EVALUATE, agent `verifier` read-only). Le chantier le moins couvert chez vous semble être le troisième : deux agents en parallèle, chacun dans son worktree, avec une liste de commandes sûres pré-autorisées.

Que souhaitez-vous faire à partir de là : une fiche de notes pour Notion, un plan pour mettre en place le chantier « bacs à sable » sur un de vos projets, ou autre chose ?

---

# Vidéo 1 — ce que le chantier « bacs à sable » implique

Oui, je vous explique ce que cela impliquerait concrètement. Rien à installer pour l'instant — c'est de la compréhension d'abord.

## Ce que ce chantier veut dire

L'idée : au lieu d'une seule session Claude Code que vous surveillez, vous en lancez deux en même temps, sur deux tâches différentes, et chacune travaille dans son propre coin sans pouvoir gêner l'autre. Cela repose sur trois briques.

### 1. Le worktree : donner à chaque agent sa propre copie du projet

Un *worktree* est une fonctionnalité de Git : c'est un deuxième dossier de travail branché sur le même dépôt. Même historique, mêmes commits, mais un dossier physique séparé, sur une branche séparée.

Exemple concret avec la boulangerie Martin : le projet vit dans `~/boulangerie`. Vous tapez :

```
git worktree add ../boulangerie-facture feature/facture-pdf
git worktree add ../boulangerie-stock feature/alerte-stock
```

Vous obtenez deux dossiers, `boulangerie-facture` et `boulangerie-stock`. L'agent A travaille dans le premier, l'agent B dans le second. Si l'agent A casse tout dans son dossier, l'agent B ne le voit même pas. Sans worktree, deux agents dans le même dossier s'écraseraient mutuellement leurs fichiers.

À la fin, chaque branche devient une PR, et le dossier temporaire se supprime avec `git worktree remove`.

### 2. Deux sessions Claude Code, une par dossier

Concrètement : deux terminaux (ou deux panes cmux, ce qui colle bien à votre setup existant), chacun lancé depuis son dossier, chacun avec sa consigne. Vous lancez les deux, puis vous fermez l'écran — c'est le test de la vidéo.

### 3. La liste de commandes pré-autorisées

C'est le point qui rend le « fermez l'écran » possible. Aujourd'hui, quand un agent veut lancer `npm test`, Claude Code vous demande la permission. Si vous n'êtes pas devant l'écran, l'agent reste bloqué en attente — le parallélisme ne sert à rien.

La solution : déclarer une fois pour toutes, dans le fichier de configuration du projet (`.claude/settings.json`), la liste des commandes jugées sûres — typiquement les tests, la compilation, le linter, les lectures de fichiers. Ces commandes passent alors sans question. Tout le reste — réseau, secrets, suppressions, `git push` — continue de demander votre accord.

## Ce que cela implique pour vous, au-delà de la technique

- **Choisir des tâches indépendantes.** Deux tâches qui touchent les mêmes fichiers créeront un conflit au moment de fusionner les branches. Il faut donc découper le travail en chantiers qui ne se croisent pas. C'est une compétence de découpage, pas d'outil.
- **Avoir la boucle de vérification avant.** Le chantier 3 ne fonctionne que si le chantier 2 existe : chaque agent doit pouvoir lancer lui-même tests + typecheck et ne vous montrer que du travail vérifié. Votre gate DELIVER joue déjà ce rôle — il faudrait juste qu'elle tourne dans chaque worktree.
- **Accepter de ne plus regarder pendant.** Votre intervention se déplace à la fin : relire deux diffs avec leurs rapports de vérification, au lieu de suivre deux flux de frappes en direct.
- **Un petit surcoût de gestion.** Créer et supprimer les worktrees, fusionner deux PR au lieu d'une. C'est mécanique et automatisable, mais c'est une friction réelle les premières fois.

Ce que cela n'implique pas : pas de nouveau logiciel à installer (worktree fait partie de Git), pas de changement de votre niveau d'exigence, pas de dix agents d'un coup — la vidéo insiste : deux, pas plus, tant que la confiance n'est pas établie.

Quand vous voudrez l'essayer, la démarche raisonnable serait de le tester une fois sur un projet réel avec deux petites tâches, avant de toucher à la moindre configuration permanente.

---

# Vidéo 1 — analyse critique

Voici mon analyse critique, en distinguant ce que je peux confirmer, ce qui est plausible mais invérifiable pour moi, et ce qui mérite de la méfiance. Précision importante : mes connaissances s'arrêtent à janvier 2026, or plusieurs faits cités datent de 2026. Je le signale à chaque fois.

## La thèse centrale est solide

L'idée maîtresse — le goulot n'est plus la production de code mais sa vérification — est correcte et fait consensus chez les gens sérieux du domaine. Quand écrire du code devient quasi gratuit, le coût se déplace vers la relecture, les tests et la décision de faire confiance. Les quatre chantiers proposés (fichier de consignes, boucle de vérification, isolation, relecture par un agent tiers) correspondent aux bonnes pratiques documentées, y compris par Anthropic elle-même. Le rappel que le niveau d'exigence ne doit pas baisser, et que le piège est de multiplier les agents avant d'avoir une boucle fiable, est le passage le plus honnête de la vidéo. Sur le fond méthodologique, je n'ai rien à redire.

## Les faits vérifiables : bilan mitigé

**Vrai.** Boris Cherny est bien le créateur de Claude Code chez Anthropic. Andrej Karpathy a bien inventé l'expression « vibe coding » (février 2025). L'étude METR de 2025 a bien mesuré des développeurs expérimentés 19 % plus lents avec l'IA tout en se croyant plus rapides — c'est un fait établi et la vidéo la cite correctement. Le standard AGENTS.md existe et a été largement adopté en 2025. Ilya Sutskever tient effectivement le discours « le problème est la fiabilité, pas la capacité ».

**Le point le plus fragile : la « révision » de METR.** La vidéo affirme que METR aurait retourné son propre chiffre en février 2026, passant de −19 % à +18 % sur les mêmes profils. Je ne peux pas le vérifier (après ma date de coupure), mais ce récit doit vous mettre en alerte pour deux raisons. D'abord, un renversement complet de signe sur la même cohorte serait un événement scientifique majeur ; s'il est réel, il vient avec de gros intervalles d'incertitude — la vidéo le concède d'ailleurs à demi-mot (« intervalle large et des biais que le labo assume »). Ensuite, c'est exactement le fait dont la vidéo a besoin pour que son récit tienne : c'est là qu'un vérificateur doit être le plus exigeant. Avant de considérer ce chiffre comme acquis, il faudrait lire la publication METR elle-même, pas le résumé qu'en fait la vidéo.

**Invérifiables mais plausibles en direction, pas en précision.** La télémétrie Faros (+441 % de temps de revue, 31 % de merges sans revue), les 11 $ par employé de Ramp, les « 60 000 projets » pour AGENTS.md, le fil de Cherny du 16 juillet : tout cela date de 2026 ou provient de sources que je ne connais pas dans le détail. La tendance décrite (revue qui explose, merges non relus, marché médian très en retard sur les précurseurs) correspond à ce qui était déjà observé fin 2025. Mais retenez les directions, pas les chiffres : « +441 % » est un chiffre spectaculaire dont la définition exacte (mesuré comment, sur qui) change tout.

## Les biais de construction de la vidéo

**Toutes les sources vendent quelque chose.** Cherny vend Claude Code. Les données OpenAI sur les « utilisateurs du centile supérieur » sont du marketing produit. La vidéo elle-même se termine sur un Patreon. Aucune de ces sources n'est fausse pour autant, mais toutes ont intérêt à dramatiser l'écart entre précurseurs et retardataires. Un manifeste publié par le créateur de l'outil n'est pas de la télémétrie neutre — c'est une feuille de route commerciale, même si elle est techniquement juste.

**La convergence Cherny–Microsoft prouve moins que la vidéo ne le dit.** « Deux concurrents décrivent la même échelle, donc ce n'est plus une opinion » : c'est un argument séduisant mais faible. Deux vendeurs d'outils d'agents ont le même intérêt à décrire une échelle de maturité dont leur produit est l'ascenseur. La convergence de deux acteurs aux incitations identiques n'est pas une validation indépendante.

**Le procès d'intention fait aux sceptiques.** La vidéo explique que ceux qui doutent « défendent leur barrière à l'entrée en la présentant comme une loi de la nature ». C'est de la psychologisation : on n'a plus besoin de répondre aux arguments de quelqu'un une fois qu'on a expliqué pourquoi il les tient. Or certains arguments sceptiques restent valides : la dette de maintenance d'un code que personne ne comprend (la vidéo le reconnaît, une phrase), la sécurité, les systèmes critiques, et le fait que les gains varient énormément selon le type de code — un projet avec une bonne couverture de tests se prête à la délégation, un legacy sans tests beaucoup moins. Ce dernier point est le grand absent de la vidéo : l'échelle est présentée comme universelle alors qu'elle dépend fortement de la nature du travail.

**La jauge en tokens est l'idée la plus discutable.** La vidéo la relativise elle-même (loi de Goodhart), mais elle la garde quand même comme instrument central de la deuxième moitié. Or les tokens mesurent une dépense, pas un résultat. Un workflow mal conçu qui tourne en rond brûle énormément de tokens ; un workflow bien conçu peut en consommer peu. Dire « sous le million vous avez un super Google » est une provocation utile, mais « au milliard vous tenez une usine » confond volume et valeur. C'est un indice de délégation, comme dit la vidéo — mais alors il fallait s'y tenir et ne pas en faire une échelle de classement.

**Les étapes 3 et 4 sont de la prospective, pas de l'observation.** La centaine puis le millier d'agents pilotés « par intention » : personne ne fait cela de façon fiable aujourd'hui à ma connaissance. La vidéo l'admet à moitié (« vous n'êtes pas obligé de croire au millier »). L'échelle observée et documentée s'arrête réellement à l'étape 2, un peu de 3 chez quelques équipes très outillées.

## Mon verdict d'ensemble

La vidéo est fiable sur la méthode et orientée sur les preuves. Si vous en retenez les quatre chantiers et les deux tests (« un ingénieur l'aurait-il fait comme ça ? », « puis-je partir deux heures ? »), vous retenez le meilleur, et c'est applicable dès maintenant. Si vous en retenez les chiffres — le +18 % de METR, le +441 %, la jauge en tokens — vous retenez la partie la moins solide : des données de 2026 que ni vous ni moi n'avons vérifiées à la source, sélectionnées par des acteurs qui ont tous un produit ou un abonnement à vendre. La trajectoire décrite (vérification comme nouveau métier, écart croissant entre médiane et précurseurs) me paraît juste ; le calendrier et l'ampleur exacts sont, eux, invendables comme certitudes.

Si vous voulez, je peux vérifier en ligne les deux affirmations les plus importantes — la révision METR et le fil de Cherny — pour remplacer mon « invérifiable » par du concret.

---

# Vidéo 1 — vérification en ligne (METR, Cherny)

Vérification faite : les deux affirmations sont vraies. Mon jugement de la vidéo remonte donc d'un cran en fiabilité, avec une nuance importante sur METR.

## La révision METR : vraie, mais plus fragile que ne le dit la vidéo

METR a bien publié le 24 février 2026 un billet révisant son expérience. Les chiffres de la vidéo sont exacts : l'étude initiale (début 2025) mesurait un ralentissement de 19 % (intervalle de confiance de +2 % à +39 %) ; la nouvelle mesure, sur les développeurs de la cohorte originale, donne une accélération de 18 % (intervalle de −38 % à +9 %). METR attribue le retournement à l'apprentissage et à l'amélioration des outils, exactement comme le résume la vidéo.

La nuance que la vidéo minimise : METR qualifie lui-même ses nouvelles données de « preuve très faible ». Le labo liste des biais sévères — les développeurs pro-IA refusent de plus en plus de participer (travailler sans IA ne les intéresse plus), le tarif horaire versé aux participants a été divisé par trois, et 30 à 50 % des développeurs admettent ne pas soumettre les tâches où l'IA excelle. Notez d'ailleurs que l'intervalle de confiance de la nouvelle mesure inclut zéro : statistiquement, on ne peut même pas exclure une absence de gain. Et METR ne dit pas que le chiffre de 2025 était faux — les deux mesures décrivent des moments différents. La vidéo dit donc vrai sur les chiffres, mais présente comme un « retournement » établi ce que METR présente comme un signal probable mais non mesurable proprement.

## Le fil de Cherny : vrai et fidèlement rapporté

Boris Cherny a bien publié le 16 juillet 2026 son « Steps of AI Adoption » : cinq étapes, de « Gated » (0 agent) à « AI-native » (1 000+ agents), avec le constat de départ que la vidéo cite — une personne décuple sa production pendant que le reste de l'organisation reste bloqué — et la thèse que le goulot de chaque étape est un problème de garde-fous et de vérification, pas de volume de tokens. Le fil a dépassé 251 000 vues en quelques heures. La vidéo restitue ce contenu fidèlement, sans déformation notable.

## Ce que cela change à mon verdict

Les deux piliers factuels de la vidéo tiennent : elle cite ses sources correctement. Ma critique se resserre donc sur un seul point factuel : la vidéo transforme une auto-correction prudente de METR (« preuve très faible », intervalle incluant zéro) en preuve de retournement. C'est le glissement classique du vulgarisateur — pas un mensonge, mais un degré de certitude ajouté. Les critiques de construction que je vous ai faites (sources qui vendent toutes quelque chose, jauge en tokens discutable, étapes 3-4 prospectives, procès d'intention aux sceptiques) restent valables telles quelles. Au global : c'est une vidéo au-dessus de la moyenne en rigueur, à lire avec un seul réflexe — remplacer « c'est prouvé » par « c'est le signal dominant, encore mal mesuré ».

Sources :
- [We are Changing our Developer Productivity Experiment Design — METR](https://metr.org/blog/2026-02-24-uplift-update/)
- [Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity — METR](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)
- [Steps of AI Adoption: Boris Cherny Claude Code Guide — explainx.ai](https://www.explainx.ai/blog/boris-cherny-steps-ai-adoption-claude-code-july-2026)
- [AI Adoption Roadmap: The 5 Steps from Gated to AI-Native (2026) — bosio.digital](https://bosio.digital/articles/ai-adoption-roadmap)

---

# Vidéo 2 — analyse critique et vérification

Analyse critique terminée. Verdict d'ensemble : cette deuxième vidéo est factuellement encore plus solide que la première — j'ai vérifié ses cinq affirmations principales et elles sont toutes exactes, parfois au centime près. Les faiblesses sont ailleurs : deux glissements interprétatifs et une affirmation invérifiable.

## Les faits : quasi tout est confirmé

**Grok Bot (que la transcription écorche en « Grockbot »).** xAI a bien lancé le 11 août des agents « employés » persistants, chacun avec son ordinateur cloud (navigateur, fichiers, terminal), qui travaillent pendant votre absence et ne remontent vers vous que pour validation. La description de la vidéo est fidèle. Claude Cowork, ChatGPT Work et Copilot existent bien sur ce créneau.

**Stripe rachète OpenRouter.** Confirmé par Bloomberg : plus de 7 milliards de dollars, soit plus de cinq fois la valorisation de 1,3 milliard obtenue 82 jours plus tôt. La vidéo dit « 3 mois », c'est correct. L'interprétation — la couche d'aiguillage entre modèles devient un péage stratégique — est une lecture défendable, partagée par la presse spécialisée.

**Les chiffres Cognition : exacts au centime.** Le billet « Making Fable Cheaper Than Opus » dit précisément ce que la vidéo rapporte : avec le même exécutant bon marché, le meneur le plus cher revient à 1,86 $ la tâche contre 2,04 $ pour le meneur précédent, en 11,5 tours contre 26,5, et dans 81 % des passages le bon meneur ne touche pas au code lui-même. Le cas d'échec est aussi réel : sur une tâche TypeScript, déléguer jusqu'au jugement a fait perdre 27 points. La vidéo restitue même la réserve d'honnêteté (données du vendeur, sur son propre benchmark). Restitution irréprochable.

**Cherny et les 80 % de consignes supprimées.** Confirmé — c'est le sujet d'une intervention publique de Boris Cherny (« We Cut 80% of Claude Code's Prompt »).

**La flagornerie qui double (9 % → 18 %).** Le chiffre existe et est bien de 2026. Nuance importante : la vidéo le présente comme le résultat d'une expérience (« lorsque l'utilisateur conteste, la flatterie double »), alors que c'est une donnée d'observation en déploiement : les conversations qui contiennent une contestation montrent deux fois plus de flagornerie. La causalité peut aller dans les deux sens — le modèle plie face à la contestation, ou bien la flagornerie provoque la contestation. Le phénomène est réel et documenté, mais le chiffre prouve moins que ce que la vidéo lui fait dire. Même remarque pour l'« overthinking » : phénomène réel et étudié (au-delà d'un seuil, plus de raisonnement dégrade le résultat), mais la règle « effort max pour la stratégie, effort contenu pour l'exécution » est une heuristique de terrain, pas une loi établie.

## Les deux vrais points faibles

**« Fable est déjà en interne un orchestrateur de sous-modèles ».** Rien de public ne soutient cette affirmation, et je suis bien placé pour le dire. La vidéo confond probablement le modèle et son harnais : Claude Code (le logiciel autour du modèle) peut effectivement lancer des sous-agents et envoyer des messages à d'autres sessions — cela, c'est vrai et vérifiable. Mais dire que le modèle lui-même est une équipe déguisée est de la spéculation présentée comme un fait. C'est le seul énoncé factuellement douteux de la vidéo.

**Le casting « OpenAI = exécutant docile, Claude = contradicteur ».** C'est l'expérience personnelle de l'auteur, généralisée en règle. La docilité d'un modèle dépend énormément du harnais, des consignes système et de la tâche. Le principe sous-jacent est excellent (ne pas mettre un flatteur au poste de conseil, ne pas mettre un contradicteur à l'exécution) ; l'attribution par marque, elle, est périssable et discutable.

## Ce qui est structurellement solide

La partie la plus forte de la vidéo est paradoxalement la moins chiffrée : la critique des équipes préassemblées. Les trois questions (qui choisit le modèle à chaque poste, le curseur d'effort est-il visible, peut-on remplacer un membre sans jeter l'équipe), le risque de routage opaque optimisé pour la marge du vendeur, la mémoire apprise qui devient inauditable et non portable, et le problème d'identité (les journaux disent que c'est vous qui agissez) — tout cela correspond à des préoccupations réelles et sérieuses du moment, sans exagération. Idem pour les deux disjoncteurs (budget de tokens par poste, périmètre d'accès) : c'est du bon conseil d'ingénierie.

Les tics déjà relevés dans la première vidéo demeurent : entonnoir Patreon, prédiction datée invérifiable (« fin 2027, l'équipe se repliera dans un seul cerveau » — c'est un pari, pas une analyse), et la médiane à 11 $ resservie comme repère alors qu'elle mesure une dépense, pas une maturité.

Au global : sur les faits, cette vidéo est au niveau d'un bon article de presse spécialisée — mieux sourcée que la première. Retenez-en la grille de management (recruter sur essai maison, docilité et effort réglés par poste, disjoncteurs, méfiance envers les boîtes automatiques) en toute confiance ; traitez l'affirmation sur l'architecture interne des modèles et le casting par marque comme des opinions.

Sources :
- [xAI Launches Grok Bot — Unite.AI](https://www.unite.ai/xai-launches-grok-bot-always-on-ai-teammates-with-their-own-cloud-computers/)
- [Stripe Finalizes Deal to Acquire OpenRouter for Over $7 Billion — Bloomberg](https://www.bloomberg.com/news/articles/2026-08-16/stripe-nears-deal-to-buy-ai-firm-openrouter-for-over-7-billion)
- [Stripe will reportedly acquire OpenRouter for $7B+ — TechCrunch](https://techcrunch.com/2026/08/16/stripe-will-reportedly-acquire-ai-gateway-startup-openrouter-for-7b/)
- [Making Fable Cheaper Than Opus — Cognition](https://cognition.com/blog/making-fable-cheaper-than-opus)
- [Devin Fusion — Cognition](https://cognition.com/blog/devin-fusion)
- [What Counts as AI Sycophancy? A Taxonomy and Expert Survey — arXiv](https://arxiv.org/html/2605.21778v1)
- [Boris Cherny: We Cut 80% of Claude Code's Prompt — YouTube](https://www.youtube.com/watch?v=qyPCVqFUyDo)

---

# Conclusion opérationnelle

Voici la conclusion, en une phrase : votre système de travail est déjà bien plus avancé que la médiane du marché, mais il est construit pour un seul agent supervisé — le passage qui vous concerne maintenant est de faire tourner votre vérification sans vous, et de gérer vos agents comme des postes, pas comme des outils.

## Ce que vous avez déjà (et qu'il faut garder)

Les deux vidéos décrivent quatre chantiers ; trois existent chez vous. Le contrat : vos CLAUDE.md, règles de phase FORGE et skills sont exactement la « Bible de consignes » — et, point souligné par la deuxième vidéo, la vôtre est en markdown lisible, auditable et portable, contrairement aux routines apprises des produits type Grok Bot ou Cowork. C'est un actif : ne le migrez jamais dans un produit fermé. L'examen : votre gate DELIVER (tests + typecheck avec sortie réelle collée) est la boucle de vérification que la vidéo réclame. La relecture : votre agent `verifier`, read-only et distinct du producteur, applique déjà le principe « le fabricant ne se juge jamais lui-même ».

## Ce qui manque : la conclusion opérationnelle n°1

Votre FORGE enchaîne les phases en série, avec vous en validation à chaque PAUSE. Vous êtes structurellement à l'étape 1 de Cherny — un binôme bien outillé. Le seul chantier manquant est celui dont on a parlé : deux tâches indépendantes, deux worktrees, une liste de commandes sûres pré-autorisées, et le test physique — lancer le matin, partir deux heures. Si l'idée est insupportable, c'est la boucle qu'il faut renforcer, pas votre tolérance. Quand vous voudrez l'essayer, un candidat naturel serait un projet réel avec deux fiches Linear qui ne se touchent pas.

## En tant que créateur d'agents : des fiches de poste, pas des modèles

La deuxième vidéo change votre grille de conception. Vos agents (tdd-writer, verifier, Hermès, vos teams cmux) doivent être définis par poste, avec deux réglages explicites par poste :

- **Docilité.** L'exécutant (tdd-writer) doit obéir sans réinterpréter. Le conseiller et le relecteur (verifier) doivent pouvoir vous contredire — c'est leur valeur. Le drame décrit par la vidéo, contradicteur à l'exécution et flatteur au conseil, est le défaut à vérifier dans vos prompts d'agents : est-ce que votre verifier a explicitement le mandat de dire « c'est mauvais » ?
- **Effort.** Réflexion maximale pour l'arbitrage et la revue, contenue pour l'exécution mécanique. Pousser l'effort partout coûte plus cher et fait dériver la consigne.

Et la leçon Cognition s'applique directement : le bon orchestrateur est celui qui délègue le plus et code le moins. Un gros modèle en meneur qui délègue coûte moins cher qu'un modèle moyen qui refait tout. Mais ne déléguez jamais le jugement — c'est le cas d'échec mesuré.

## Deux garde-fous à prévoir avant de grandir

Avant d'ajouter des agents : un disjoncteur de budget (l'anecdote des 130 agents qui fondent un abonnement en une heure vous concerne directement avec cmux et les teams) et un disjoncteur d'accès — chaque agent ajouté est une porte de plus, et vos agents agissent sous votre identité (Hermès sur son VPS est le bon réflexe : périmètre isolé). Réseau, secrets, suppressions, push restent en approbation manuelle.

## Ce qu'il faut refuser de mesurer et refuser d'acheter

Ne pilotez pas au compteur de tokens — c'est un indice, pas un objectif. Et face aux équipes préassemblées qui arrivent, vos trois questions de contrôle sont celles de la vidéo : qui choisit le modèle à chaque poste, le curseur d'effort est-il visible, peut-on remplacer un membre sans jeter l'équipe. Votre système actuel répond « moi, oui, oui » — c'est précisément sa valeur.

## Enfin, ce qui remonte vers vous

À mesure que l'exécution descend vers les agents, ce qui vous reste monte d'un cran : définir les critères de réussite, juger le produit final, dire non. C'est cohérent avec ce que vous faites déjà — vos formations en cours sont exactement l'investissement que la vidéo recommande : entretenir la capacité à juger ce que les agents produisent, sans quoi « vous n'avez pas monté d'un niveau, vous avez lâché les commandes ». Et une note d'entretien à retenir de Cherny : tous les six mois, élaguer vos consignes accumulées (FORGE inclus) pour voir ce qui tient debout tout seul — les modèles récents ont besoin de moins d'échafaudage qu'au moment où vous les avez écrites.

Rien de tout cela n'est à installer aujourd'hui. Si vous voulez passer à l'acte, le premier geste concret est le test des deux worktrees sur un projet réel — dites-moi lequel, et on le préparera ensemble.
