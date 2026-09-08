# 8 septembre 2026 — Les livraisons 2.2 et 2.3 relues, et le serveur passe à l'outil

Après le merge de la PR #29, mise à jour posée dans les deux projets (sandbox PR #60,
crm-workday PR #14). En chemin, crm-workday avait avancé de deux livraisons la veille au soir,
avec les fiches d'avant : 2.2 (PR #12, 2 h 15 d'horloge) et 2.3 (PR #13, 3 h 35). Relecture des
transcriptions.

## Ce que 2.2 et 2.3 ont montré

- **La liste des fichiers d'une mission ne couvrait pas le contrat**, deux fois. Une phrase
  demandait un écran que la liste du lead n'ouvrait pas. Le producteur a signalé et s'est
  arrêté, ce qu'on lui demande, puis a été relancé avec le périmètre élargi. Le lead l'a vu
  lui-même à 2.3 : « la même faute qu'en 2.2 sous une autre forme ».
- **Le producteur relancé a ouvert un second cycle** : nouvel audit, nouvelle recette, une
  correction. Le lead l'a décidé seul, et c'était juste : le code du contrat 6 n'avait jamais
  été relu. La règle ne le prévoyait pas.
- **Le testeur de 2.3 est resté bloqué 44 puis 53 minutes sur `kill <pid>`** du serveur
  `npm run dev` qu'il avait lancé en tâche de fond. `kill` était dans la liste blanche : ce
  n'était pas une permission. Le résultat du `kill` est arrivé avec la notification de fin de
  la tâche de fond. Deux cas, même forme ; `pkill -f` n'a jamais bloqué. Mécanisme non élucidé,
  reproduction impossible sans arrêter le serveur de Cédric.
- Le lead a failli écrire une fausse cause (« attente de permission ») et s'est repris seul :
  « `kill` est déjà dans la liste blanche, je corrige avant d'écrire une fausse cause ». La
  règle du 07/09 a servi.

## PR `docs/serveur-par-l-outil`

1. **L'outil de passe visuelle lance et arrête le serveur** (`--serveur "npm run dev"`) : dans
   son propre groupe de processus, attend que l'URL réponde (60 s), fait la passe, arrête tout
   le groupe. Si l'URL répond déjà, il ne touche à rien. Testé sur le sandbox : lancé et
   arrêté, port libre après ; serveur externe respecté ; serveur muet, sortie en erreur.
2. **Le testeur ne lance ni n'arrête jamais un serveur.** La consigne du lead porte la commande
   `Lancer l'app`.
3. **`produire.md`** : la liste des fichiers se déduit du contrat, phrase par phrase ; un
   producteur relancé ouvre un second cycle, audit puis une correction. Le moule de mission le
   rappelle sous « Fichiers que tu modifies ».
4. **`cout-agents.py`** distingue un agent **bloqué** sur une commande d'un agent **en veille**
   après son rapport. Sur crm-workday : 7,8 h bloqué, 10,4 h de veille, 10,6 h de travail.
5. **`BOUCLE-AGENTS.md`** : la leçon des trois livraisons.

## Compteur

Backlog n° 10 : deux features terminées, deux en cours ; crm-workday à quatre livraisons sur
neuf pour la feature 2. Le run 2.1b a tenu ses deux chiffres ; 2.2 et 2.3 ont tourné avec les
fiches d'avant, ce qui les exclut de la mesure.

## Reste

Après le merge : `/pilot update` sur crm-workday avant 2.5a. Puis deux producteurs en parallèle
sur une feature qui s'y prête (le lead a proposé 2.5a dès la PR de 2.3 ouverte : c'est le
tuilage, pas le parallèle, et il a eu raison de le dire).
