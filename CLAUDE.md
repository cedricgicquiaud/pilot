# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Nature du dossier

Ce n'est pas un projet logiciel : il n'y a ni build, ni tests, ni dépendances.
C'est un dossier de **documentation méthodologique** (en français) décrivant
deux choses complémentaires :

1. comment **piloter** un projet de développement avec Linear (suivi), GitHub
   (code) et Claude Code (exécution) — document présentable à un client ;
2. comment **produire** en parallèle avec plusieurs agents Claude Code et une
   vérification qui tourne sans humain (la « boucle agents ») — cuisine interne.

Pas de dépôt git initialisé.

## Fichiers

| Fichier | Rôle |
|---|---|
| `PILOTAGE-LINEAR-GITHUB-CLAUDE.md` | Document de référence complet. Partie A = tronc commun (suivi Linear/GitHub) ; Partie B = le circuit d'une feature (cadrer → découper → produire → merger → apprendre), les commandes, `next`. |
| `circuit-linear-github-claude.html` | Version visuelle résumée du même contenu, page HTML autonome (CSS inline, aucune dépendance externe). Sert de support de présentation. |
| `BOUCLE-AGENTS.md` | La boucle agents : pourquoi, recette (worktrees, `MISSION.md`, allowlist, relecteur indépendant), invariants, leçons de l'essai, backlog des manques. |
| `sources/*.md` | Archives : analyses critiques des vidéos à l'origine de la boucle agents. Ne pas réécrire. |

`PILOTAGE-…md` et le HTML décrivent la même méthode : toute modification de
fond dans le Markdown (statuts, règle de nommage, vocabulaire) doit être
répercutée dans le HTML, et inversement. Le HTML est volontairement plus court
(5 sections) que le Markdown (13 sections + annexe).

`BOUCLE-AGENTS.md` s'appuie sur le pilotage (fiches Linear, nommage des
branches) sans le modifier. Il ne contient aucun nom de projet réel : le seul
exemple est le banc d'essai `pilotage-sandbox`.

## Concepts clés à respecter lors des modifications

- **Vocabulaire imposé** : Initiative = « Cap », Project Linear = « Feature »,
  Issue Linear = « Tâche ». Ne pas réintroduire le mot « projet » au sens Linear.
- **Règle centrale** : le code Linear voyage dans le nom de branche
  (`feature/<CODE>-<nom>`, `fix/<CODE>-<nom>`, `chore/<CODE>-<nom>`) et dans le
  titre de la PR. Tout le reste du document en découle.
- **Statuts de feature** dans l'ordre : À cadrer → Planifiée → En développement
  → En revue → Terminée (+ « Rétro faite » en Partie B). Les deux derniers
  passages sont posés par l'intégration GitHub de Linear, pas par Claude.
- **Partie B ne modifie jamais la Partie A** : le circuit vient remplir les cases
  définies par le tronc commun. Garder cette séparation.
- **FORGE n'existe plus** : absorbé par la Partie B (cadrage, découpage, rétro) et
  par `BOUCLE-AGENTS.md` (production, vérification, livraison). Ne pas le réintroduire.
- **Le merge est humain**, à chaque livraison. Pas de merge automatique dans les
  documents tant que le backlog n° 1 et n° 5 de `BOUCLE-AGENTS.md` ne sont pas faits.
- Ton rédactionnel : phrases courtes, tableaux, exemples concrets, pas de jargon
  non expliqué (voir les préférences globales de rédaction).

## Vérification

Pour contrôler le HTML après modification, l'ouvrir directement dans un
navigateur (`open circuit-linear-github-claude.html`) ; il ne nécessite aucun
serveur.

## Mise en œuvre

Le pilotage est implémenté par la skill globale `~/.claude/skills/pilot/`
(commandes init, roadmap, feature, next, fix, sync, benchmark). La boucle agents
s'appuie sur les agents globaux `~/.claude/agents/verifier.md` et `tdd-writer.md`,
et sur le gabarit `.pilot/MISSION.template.md` du banc d'essai.

Le dépôt `AlanZien/pilotage-sandbox` est le banc d'essai des deux méthodes.
Circuit d'évolution : on écrit ici, on teste sur le sandbox, on installe dans
`~/.claude/`. Toute évolution de la méthode doit être répercutée dans la skill
ou les agents, et inversement.
