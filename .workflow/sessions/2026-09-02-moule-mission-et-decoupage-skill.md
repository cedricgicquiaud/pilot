# Session du 2 septembre 2026 — Le partage fiche / mission, et la skill découpée

Suite directe du 1er septembre, qui avait réécrit les cinq fiches d'agent. La journée a servi à
réparer ce que cette réécriture avait laissé à moitié fait, puis à traiter les gabarits et la
skill elle-même.

## La fiche `correcteur`

L'agent qui corrige les défauts après l'audit **n'avait aucune fiche**. `run` parlait d'« un
agent correcteur », le backlog citait `afix` et `aaudit` : aucun des trois n'existait dans
`~/.claude/agents/`. C'était pourtant le seul agent à toucher au code après l'audit, donc celui
qui a le plus de raisons de contourner un test qui résiste.

**Décision : une fiche séparée, pas un mode de `tdd-writer`.** Les risques ne sont pas les mêmes
— le producteur part d'une page blanche et peut contourner un test ; le correcteur part d'un
code qui tourne et sa tentation est d'**élargir la liste**. Et sur les 180 lignes de
`tdd-writer`, le correcteur n'aurait utilisé que cinq.

`correcteur.md`, 95 lignes, quatre règles : la liste est fermée ; le test d'abord quand le
défaut est testable ; **sans test quand le défaut est visuel, mais il l'écrit dans son rapport**
(section « Corrigé sans test » distincte de « Corrigé avec un test ») ; une seule passe, et
l'échec est prévu — la PR partira marquée non mergeable.

## Le partage entre la fiche et la mission

Le 1er septembre avait ajouté douze règles dans `tdd-writer.md`. Elles étaient **déjà dans
`MISSION.template.md`** : le geste n'avait été fait qu'à moitié.

**Pourquoi le doublon existait** : à l'essai du 26/08, les producteurs étaient des Claude
génériques, sans fiche. `MISSION.md` était le seul papier qu'on leur donnait. La fiche
`tdd-writer` est arrivée ensuite, mais sans les invariants de la boucle (backlog n° 6, resté
ouvert). Les règles ont migré vers un fichier qui existait déjà, et personne n'a nettoyé
l'original.

**La règle retenue** : *la fiche dit la règle, `MISSION.md` donne la valeur.* La fiche pose la
contrainte et nomme le trou ; la mission le remplit.

| La fiche dit | La mission donne |
|---|---|
| Tu ne modifies que les fichiers de ta liste | la liste |
| Lance la commande de tests | la commande |
| PR titrée `<CODE>-<n> <titre>` | le code, le numéro, le titre |

Le moule passe de 65 à 51 lignes, en **gagnant** deux sections qui manquaient depuis toujours :
les **décisions produit** déjà tranchées, et le **texte des phrases du contrat** — jusque-là
`MISSION.md` ne portait que leurs numéros, ce qui rendait le contrôle de couverture impossible
pour le `verifier`, qui n'a aucun accès à Linear.

**Un piège évité** : le mode « session indépendante » (pane), que `BOUCLE-AGENTS.md` recommande
pour les producteurs, ne charge **aucune fiche** — c'est un Claude ordinaire. Vider le moule
l'aurait laissé sans règles. La parade est écrite dans la skill et dans le § 2.5 : un pane se
lance par `claude --agent tdd-writer`.

Une consigne orpheline a été récupérée au passage : *« relire ton diff contre les idiomes, ligne
par ligne »* n'existait que dans le moule ; elle est passée dans la clôture de `tdd-writer`.

## La recherche

Backlog n° 13, jamais écrit. **Tranché en deux moitiés :**

**Au PRD, systématiquement.** `init` lance la skill `research-assistant` avant l'entretien — ce
qui existe, les standards du domaine, les règles extérieures qui s'imposent. Le document va dans
`.pilot/recherche.md`. Sans question préalable : au moment du PRD personne ne sait encore rien,
et une supposition posée là se paie sur toute la roadmap.

**Au cadrage d'une feature, rien** (décision de Cédric). Les questions y sont internes au
produit, pas externes. `WebSearch` et `WebFetch` ont été retirés des outils du `contradicteur`.

## Les quatre gabarits Linear

Trois manques de fond, en plus du style :

- `template-feature.md` n'avait **ni section Livraisons ni Repères techniques**, que la skill
  demande pourtant. Et il entretenait une confusion entre le contrat de validation (le détail,
  pour les agents) et le « Terminé quand » (le résumé, pour l'humain) — la différence est
  maintenant écrite dans les deux sections.
- `template-tache.md` ne rappelait pas la **règle du refus**, que la skill exige.
- `template-bug.md` acceptait un test qui ne prouve rien : il doit désormais avoir **échoué avant
  la correction**, et l'historique doit le montrer.
- `section-pilot.md` mélangeait onze valeurs et quatre définitions déjà présentes dans la skill.
  Les définitions sont parties ; les valeurs sont rangées en « posé par `init` » et « selon le
  projet », chaque ligne facultative disant ce qu'on perd sans elle.

Tous portent maintenant des exemples plutôt que des définitions.

## La skill découpée

597 lignes chargées à chaque commande, dont l'essentiel inutile pour la commande en cours.

| Fichier | Lignes | Chargé quand |
|---|---|---|
| `SKILL.md` | **276** | À chaque déclenchement |
| `reference/cadrer.md` | 151 | Avant `init`, `roadmap`, `feature` |
| `reference/produire.md` | 130 | Avant `run` |
| `reference/suivre.md` | 85 | Avant `next`, `fix`, `sync`, `benchmark` |

`SKILL.md` garde ce qui sert toujours — principe, vocabulaire, règles dures, outils, statuts,
circuit — plus un tableau par phase : ce que fait chaque commande, et sur quoi elle s'arrête.

Le risque du découpage est nommé en tête, en impératif : *« Lis le fichier avant d'exécuter la
commande — ne travaille jamais de mémoire »*. Un fichier qu'on ne lit pas est un fichier ignoré.

## Trois règles de rédaction, désormais valables partout

Demandées explicitement, après plusieurs « je ne comprends rien » sur des explications empilées :

1. **Phrases courtes, une idée par phrase.**
2. **Montrer plutôt que définir** — un exemple de trois mots vaut mieux qu'une définition de deux
   lignes, un contre-exemple vaut mieux qu'une nuance.
3. **Une phrase, une lecture** — si elle peut se comprendre de deux façons, elle sera comprise de
   la mauvaise.

Les deux dernières manquaient à `AGENT.template.md` ; elles y sont. Les trois sont en mémoire.

## Autres décisions

- **`Agent` reste retiré du `verifier`.** Il lançait trois sous-analyses en parallèle. Le cas où
  elles serviraient — un diff de plus de mille lignes — est traité par sa fiche comme une
  anomalie, pas comme un mode de travail. Outiller ce cas reviendrait à le rendre confortable.
- **Le mot « poste » a disparu** des documents du dépôt (22 occurrences dans `BOUCLE-AGENTS.md`,
  1 dans `SKILL.md`). Le principe fondateur a été reformulé : *« Un agent se recrute, il ne
  s'installe pas »*.
- **Backlogs n° 6 et n° 13 marqués faits**, avec la preuve du banc d'essai pour le n° 6.

## Fichiers touchés

Hors dépôt, dans `~/.claude/` :
- `agents/correcteur.md` (nouveau), `tdd-writer.md`, `contradicteur.md`
- `skills/pilot/SKILL.md` (597 → 276), `reference/cadrer.md`, `produire.md`, `suivre.md` (nouveaux)
- `skills/pilot/reference/MISSION.template.md`, `AGENT.template.md`, `template-feature.md`,
  `template-tache.md`, `template-bug.md`, `section-pilot.md`

Dans le dépôt : `BOUCLE-AGENTS.md` (§ 2.2, 2.3, 2.5, backlogs 6 et 13, vocabulaire).

Page de référence publiée et tenue à jour : « La chaîne pilot ».

## Prochaines étapes

1. **La revue de style des trois fichiers de référence.** Le découpage n'a pas réécrit le
   contenu : ils portent le texte d'origine, avec ses lourdeurs. Chacun fait moins de 150 lignes,
   donc se corrige au lieu de se subir.
2. **Puis `PILOTAGE-LINEAR-GITHUB-CLAUDE.md` (573 l.) et le HTML (224 l.)**, qui doivent rester
   synchronisés. Attention : ces deux-là s'adressent à un humain qui ne connaît pas la méthode.
   Le ton change — il faut convaincre, pas commander.
3. **`BOUCLE-AGENTS.md`** (419 l.), déjà entamé.
4. **Le `CLAUDE.md` du dépôt** (71 l.), court.
5. Resynchroniser `.pilot/MISSION.template.md` dans le sandbox.
6. Les six fiches d'agent ont été écrites avant les deux nouvelles règles de rédaction. À
   repasser à cette grille quand le reste sera fini.
