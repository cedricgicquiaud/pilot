# CLAUDE.md

Guide de travail dans ce dépôt.

## Nature du dossier

Ce n'est pas un projet logiciel : ni build, ni tests, ni dépendances. C'est un dossier de
**documentation méthodologique** (en français) qui décrit deux choses complémentaires :

1. comment **piloter** un projet avec Linear (suivi), GitHub (code) et Claude Code
   (exécution) — présentable à un client ;
2. comment **produire** en parallèle avec plusieurs agents, et vérifier sans humain
   (la « boucle agents ») — cuisine interne.

Dépôt git : branche de travail `main`, développement sur branches `docs/…`. Le merge est
humain, comme partout ailleurs.

## Fichiers

| Fichier | Rôle |
|---|---|
| `PILOTAGE-LINEAR-GITHUB-CLAUDE.md` | Document de référence complet. Partie A = tronc commun (suivi Linear/GitHub) ; Partie B = le circuit d'une feature, les commandes, `next`. |
| `circuit-linear-github-claude.html` | Version visuelle résumée, page autonome (CSS inline, aucune dépendance). Support de présentation. |
| `BOUCLE-AGENTS.md` | La boucle agents : pourquoi, les briques, les invariants, les leçons de chaque essai, le backlog des manques. Journal de bord autant que méthode. |
| `sources/*.md` | Archives : analyses critiques des vidéos à l'origine de la boucle. **Ne pas réécrire.** |
| `.workflow/sessions/` | Compte rendu de chaque session : ce qui a été fait, décidé, et ce qui reste. |

`PILOTAGE-…md` et le HTML décrivent la même méthode : toute modification de fond dans l'un
(statuts, nommage, vocabulaire) doit passer dans l'autre. Le HTML est volontairement plus
court — 5 sections, contre 24 pour le Markdown.

`BOUCLE-AGENTS.md` s'appuie sur le pilotage sans le modifier. Il ne cite aucun projet réel :
le seul exemple est le banc d'essai `pilotage-sandbox`.

## Ce qu'il ne faut pas casser

- **Vocabulaire imposé**, quatre étages plus un :
  Team = **Projet** (mois) · Project Linear = **Feature** (semaines) · Milestone = **Livraison**,
  soit une PR (jours) · Issue = **Tâche** (heures). Initiative = **Cap**, facultatif.
  Ne jamais dire « projet » pour un Project Linear : c'est une feature.
- **Règle centrale** : le code Linear voyage dans le nom de branche (`feature/<CODE>-<nom>`,
  `fix/…`, `chore/…`) et dans le titre de la PR. Tout le reste en découle.
- **Statuts de feature**, dans l'ordre : À cadrer → Planifiée → En développement → En revue
  → Terminée → Rétro faite. **C'est Claude qui les pose, jamais GitHub** — l'intégration
  GitHub ne fait avancer que les statuts de *tâche*.
- **Partie B ne modifie jamais la Partie A** : le circuit remplit les cases définies par le
  tronc commun. Garder cette séparation.
- **FORGE n'existe plus** : absorbé par la Partie B et par `BOUCLE-AGENTS.md`. Ne pas le
  réintroduire.
- **Le merge est humain, à chaque livraison.** C'est là que tu réponds aux décisions que les
  agents ont refusé de trancher : enchaîner sans répondre, c'est les laisser deviner tes
  réponses. La condition d'ouverture est écrite au backlog n° 10 de `BOUCLE-AGENTS.md`.
- **Ton rédactionnel** : phrases courtes, une idée par phrase, un exemple plutôt qu'une
  définition, aucune phrase qui puisse se lire de deux façons.

## Vérification

Pour contrôler le HTML après modification, l'ouvrir dans un navigateur
(`open circuit-linear-github-claude.html`) ; aucun serveur n'est nécessaire.

## Mise en œuvre

La méthode est implémentée dans `~/.claude/` : la skill `pilot`, six fiches d'agent, cinq
moules, deux outils. **L'inventaire complet est au § 6 de `BOUCLE-AGENTS.md`** — un seul
endroit le tient à jour.

**Toute évolution se répercute des deux côtés** : ce qui change ici doit changer dans
`~/.claude/`, et inversement. Un document qui décrit ce que la skill ne fait plus est pire
que pas de document. On écrit ici, on teste, on installe.
