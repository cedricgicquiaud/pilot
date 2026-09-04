# 4 septembre 2026 — La méthode descend dans les projets

La journée devait commencer par le run complet sur la sandbox. Une question de Cédric sur le
partage avec son associé a montré que le run n'était pas la première chose à faire.

---

## Le point de départ : une question sur Greg

« Comment je partage la méthode avec mon associé, et comment on l'utilise sur un projet
commun ? »

La réponse a mis au jour un problème qu'on ne voyait pas. La méthode vivait dans `~/.claude`,
un dossier sans git. Conséquences :

- aucun historique — on ne pouvait pas dire ce qu'une fiche disait la veille ;
- aucune sauvegarde — un disque perdu emportait tout ;
- aucun moyen de la donner à quelqu'un d'autre, ni de garantir que deux personnes travaillent
  avec la même version.

Le troisième point est le plus grave sur un projet à deux. Si les six fiches d'agent diffèrent
d'une machine à l'autre, les agents ne font pas le même travail — et les deux rapports ont
l'air normal. La divergence est invisible.

## Ce qu'on a décidé

**La méthode est une dépendance du projet.** Elle vit dans le dépôt `pilot`, sous
`implementation/`, et chaque projet en porte une copie dans son `.claude/`, versionnée avec lui.

Qui clone un projet reçoit le code et la méthode dans le même geste.

Trois règles en découlent :

1. **On modifie la méthode dans le dépôt `pilot`, jamais dans un projet.** La copie d'un
   projet est écrasée à la prochaine mise à jour.
2. **`./install.sh <projet>`** pose ou met à jour la copie, et écrit `.claude/METHODE.md` avec
   la version installée.
3. **`/pilot update`** fait la même chose depuis Claude, et refuse de tourner pendant qu'une
   livraison est en cours — un agent lancé avec les anciennes fiches ne doit pas finir avec
   les nouvelles.

Un bénéfice qu'on n'avait pas cherché : l'historique d'un projet montre désormais quelle
version de la méthode a produit quel code.

## Ce que la documentation officielle a tranché

Deux vérifications, faites avant d'écrire quoi que ce soit :

- **Agents** : `.claude/agents/` (projet) l'emporte sur `~/.claude/agents/` (personnel).
- **Skills** : c'est l'inverse. « Entre niveaux, l'entreprise l'emporte sur le personnel, et le
  personnel l'emporte sur le projet. »

Cette asymétrie décide tout : garder `pilot` dans le dossier personnel aurait écrasé, en
silence, la copie de chaque projet. La skill personnelle a donc été retirée.

Troisième vérification, qui a validé le plan d'installation : un dossier de skill peut être un
raccourci vers un dossier ailleurs sur le disque, et Claude le suit.

## Ce qui a changé, dépôt par dépôt

| Dépôt | PR | Ce qui a été fait |
|---|---|---|
| `pilot` | #17, #18 | `implementation/`, `install.sh`, `/pilot update`, documents mis d'accord |
| `pilotage-sandbox` | #42, #43, #44 | Moule de mission, méthode installée, section Pilot remise au moule |
| `cedricgicquiaud.github.io` (WATIDO) | #26 | Méthode installée — le projet n'en avait aucune |
| `VOLT_app` | #182 | La skill `pilotage` du 26 août remplacée |
| `Nexus` | #427 | Idem, plus le `.gitignore` corrigé |

**Quatre projets étaient pilotés, trois n'avaient pas la bonne méthode.** WATIDO n'en avait
aucune : il s'appuyait sur la version globale, retirée le matin même. VOLT_APP et NEXUS
portaient une copie du 26 août, d'avant la boucle agents : sept commandes, aucune fiche
d'agent, aucun outil.

## Le défaut du script, et comment on l'a vu

**`install.sh` supprimait ce qui appartenait au projet.** Il alignait `.claude/agents/` et
`.claude/skills/` en entier sur la méthode, avec `rsync --delete`. Sur VOLT_APP, il a effacé
`expo-deployment`, `react-native-best-practices`, `supabase-postgres-best-practices` et les
dix fiches `agent-os/`.

Rien n'était commité : tout a été restauré. Le script corrigé n'aligne plus que les dossiers
qui lui appartiennent, un par un. Pour les fiches d'agent, qui vivent à plat à côté de celles
du projet, il tient leur liste dans `METHODE.md` — une fiche qui sortirait de la méthode peut
être retirée sans toucher aux autres.

**Ce qu'on ne peut pas garantir** : WATIDO a été installé avant la correction. Son `.claude/`
ne contenait que `settings.json` d'après le dépôt distant, mais des fichiers non versionnés
ont pu disparaître sans trace.

**La leçon.** Un script d'installation qui aligne un dossier partagé détruit ce qu'il n'a pas
posé. La règle : n'aligner que ce qu'on a soi-même créé, et tenir la liste de ce qu'on a posé
pour savoir quoi retirer.

## Deux découvertes en chemin

**NEXUS ignorait `.claude/` en bloc**, comme outillage personnel. Mais huit fichiers y avaient
été ajoutés de force — les hooks, les règles du projet, la skill `create-connector`. Ce que
l'équipe devait partager était là, mais invisible à git. Le `.gitignore` ignore maintenant par
défaut et ré-inclut nommément ce qui se partage.

**Une branche antérieure à l'installation n'a pas la méthode.** C'est la conséquence directe
du choix : elle est versionnée avec le projet. NEXUS, ramené sur sa branche `chore/NEX-16`,
n'avait plus ni fiches ni skill. Ça vaudra pour les six branches ouvertes de VOLT_APP et les
huit de NEXUS, jusqu'à ce qu'elles soient à jour de `main`.

## Le test cassé de NEXUS

La PR #427 a révélé un test en échec : `test_garde_comptage_introuvable_refuse_puis_self_heal`.
Il protège contre un chiffre inventé dans un rapport client.

Vérifié : **il échoue aussi sur `main`, sans aucune modification.** Le CI backend ne tourne que
sur les pull requests, et il n'y avait pas eu de PR sur NEXUS depuis le 27 août. Le code n'a
pas bougé — une dépendance a dû changer. Le CI Dependabot du 29 août avait échoué lui aussi,
sans que personne le voie.

**La leçon.** Un CI qui ne tourne que sur les PR laisse la branche principale sans surveillance
dès qu'on ne merge rien pendant une semaine. Les tâches programmées de NEXUS passaient au vert
tous les matins : elles ne lancent pas les tests unitaires.

À ouvrir en fiche Linear sur NEXUS.

## La dette n° 3, réglée

Les six fiches d'agent ont été repassées aux deux règles d'écriture adoptées après leur
rédaction : montrer plutôt que définir, une phrase une seule lecture. Treize changements,
validés un par un. Les trois plus utiles :

- `tdd-writer` : « Refactoriser pour justifier la phase produit du code plus mauvais » — on lit
  « la phase produit » comme un groupe nominal avant de comprendre que « produit » est le verbe ;
- `verifier` : « Confiance minimale : 8 sur 10 » remplacé par un test applicable — saurais-tu
  montrer la faille à quelqu'un qui te contredit ? Aucun agent ne pouvait s'auto-noter sur une
  échelle qu'on ne lui donnait pas ;
- `decoupeur` : le barème S, M, L, XL lui était demandé sans jamais lui dire où il était écrit.

Aucune règle de fond n'a changé, seulement la façon de la dire.

## Le premier run complet

Feature « Tableau de bord » sur le sandbox, deux livraisons de taille S produites l'une après
l'autre. Tout a été revérifié à la main, hors de la boucle, plutôt que cru sur parole.

| Constat attendu | Résultat |
|---|---|
| Le test rouge commité avant le code | **validé** — douze cycles, aucune exception |
| Le `verifier` relance les tests lui-même | **validé** — 308 tests relancés par un tiers, tous verts |
| Une décision de fond remonte | **validé** — quatre décisions, aucune tranchée en chemin |
| Le `correcteur` fait sa passe unique | **non déclenché** — aucun défaut à corriger |
| Les transitions annoncées au fil | vu par Cédric pendant le run |

Aucun test désactivé ni affaibli : les diffs de tests ne contiennent que des ajouts.

**32 minutes de travail réel pour un barème qui en prévoyait 30, et 12 minutes d'attente du
merge humain.** Le goulot d'étranglement n'est plus l'agent.

**Le chiffre de la journée** : le `testeur` passe de 26 minutes à 3, de 401 échanges à 36, de
46 M de jetons relus à 1 M, de 296 appels navigateur à zéro. La cause n'est pas qu'il
réfléchisse mieux — c'est qu'un outil prend les captures et les mesures à sa place. Le
producteur, lui, n'a pas gagné une minute : la réécriture de sa fiche l'a rendu plus fiable,
pas plus rapide.

## Ce que le run a corrigé dans la méthode

**Un chevauchement d'une seule ligne reste un chevauchement.** Les deux livraisons ajoutaient
chacune une balise `<script>` à `index.html`. Le découpage les disait indépendantes — vrai de
leur code, faux de leur merge. La fiche du `decoupeur` déclare maintenant ce contact, et son
rendu porte une ligne « Produite après ».

**Un worktree se crée quand son producteur démarre**, pas au début du run. La consigne disait
« depuis `main` à jour » : vrai à la création, faux après le premier merge.

**Le `testeur` peut compléter l'amorce de recette.** Sa fiche couvrait l'amorce absente, pas
l'amorce incomplète. Il a écrit hors dépôt les données qui manquaient et l'a dit — c'était le
bon comportement, sa fiche ne le prévoyait pas.

## Le banc du `correcteur`

C'était le dernier agent jamais éprouvé. Six pièges, cinq passés, tous vérifiés à la main.

Le plus dur est passé : la duplication marquée « non retenu » se trouvait à deux lignes de sa
correction, dans un fichier qu'il avait le droit de modifier. Il ne l'a pas touchée.

Le sixième a échoué, sur le motif même de la vidéo qui a lancé ce travail. Le rapport disait
« le bouton n'a pas le bon état au survol », sans dire lequel. Il a écrit un bleu plus foncé,
plausible, présenté comme une correction ordinaire — sans jamais dire que personne ne lui avait
indiqué la couleur attendue.

Sa fiche disait pourtant « ne devine pas ». Elle ne suffisait pas : la règle n'avait pas de cas
nommé, et son autre moitié — « arrête-toi s'il te manque une information » — était impraticable
avec quatre défauts encore à traiter. Elle nomme maintenant le cas.

**La leçon vaut au-delà de cet agent : une règle qui n'a pas de cas nommé ne s'applique pas.**

## Ce qui reste

- **Une feature au compteur sur les quatre ou cinq** que réclame le backlog n° 10, et sur un
  seul projet. « Portail client » et « Automatisations » attendent sur le sandbox, toutes deux
  à cadrer — elles solliciteront le `contradicteur` et le `decoupeur`, que ce run n'a pas
  éprouvés en conditions réelles.
- **Le `correcteur` n'a jamais tourné en run réel.** Il faut une livraison qui produise un vrai
  défaut.
- **VOLT_APP, NEXUS et WATIDO** gardent une méthode d'avant les corrections du soir. Un
  `/pilot update` les remettra à niveau, sans urgence tant qu'aucune feature n'y est découpée.
- **Les sections 1, 2, 3 et 5 du HTML**, jamais relues au style.
- **Le test cassé de NEXUS**, et la question du CI qui ne surveille pas `main`.
