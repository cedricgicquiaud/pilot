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

## Après-midi — l'épreuve des deux heures, préparée

Cédric voulait tester la parallélisation, puis a demandé si l'enchaînement des livraisons
sans merge ne serait pas plus utile. J'ai d'abord proposé l'enchaînement ; il a objecté que ça
touchait trop de choses pour une méthode qui marche. Relecture des sources : Cherny prescrit
« deux chantiers le matin, fermer l'écran, partir deux heures » ; le tableau des écarts dit
encore « non fait tel quel » ; l'enchaînement est le backlog n° 10, prévu sous conditions, dont
la vue en direct (n° 9) qui manque toujours. Décision : l'épreuve des deux heures dans sa
forme d'origine, sans toucher au merge humain par livraison.

**Ce que le sandbox n'avait pas appris** : deux worktrees d'une application avec serveur et
base partagent le port, les deux bases et le journal des migrations.

- `pilot`, PR `docs/deux-producteurs` : un paragraphe dans `produire.md` (un poste par
  worktree, une migration au plus par paire), la ligne `Poste par worktree :` dans le modèle
  de section Pilot, une phrase dans la fiche du découpeur (le journal des migrations est un
  contact). Aucune règle ne change.
- crm-workday, PR `chore/deux-postes` : `npm run dev` et les tests d'écran lisent le port de
  `APP_URL` dans `.env.local` ; postes A (3001, `crm_a`, `crm_test_a`) et B (3002, `crm_b`,
  `crm_test_b`), bases créées ; `Agents en parallèle : 2`. Vérifié depuis un worktree sur le
  poste A : 171 tests unitaires, serveur sur 3001, 70 tests d'écran, le 3000 et `crm` intacts.
  Appris : Next refuse un `node_modules` en lien symbolique ; la base du poste se migre par
  `npm run db:migrate`.

**Suite** : merge des deux PR, le découpeur recoupe les quatre livraisons restantes de la
feature 2 pour deux agents, Cédric valide la paire, `run`, écran fermé, deux heures.

## Soir — l'outil rechargeait la mauvaise page

La session de crm-workday, en faisant `/pilot update`, a signalé que les deux défauts notés la
veille n'en faisaient qu'un : après l'amorce, l'outil rechargeait la page courante et non l'URL
demandée. Sur un écran protégé, le premier chargement redirige vers `/connexion`, l'amorce y
ouvre la session, et le rechargement rejoue `/connexion`, gestes compris. Ma correction de la
veille (« reload » au lieu de « goto », pour les URL à fragment) avait créé ce cas.

Décision (Cédric) : corriger avant 2.5b, sinon l'épreuve des deux heures aurait mesuré deux
testeurs photographiant la page de connexion.

PR `fix/passe-visuelle-recharge-l-url-demandee` :
- après l'amorce, passage par une page vide puis chargement de l'URL demandée : vrai
  chargement, y compris sur une URL à fragment, et sur l'URL voulue après une redirection ;
- l'outil compare le chemin obtenu au chemin demandé et écrit « ÉCRAN INATTENDU : /connexion au
  lieu de /entreprises », code de sortie 1 ; la fiche du testeur dit d'en faire une limite ;
- prouvé sur crm-workday, poste A, depuis un worktree (base `crm_a` remise à neuf, compte de
  recette créé) : ancien outil → image de la connexion ; corrigé → liste des entreprises avec les
  trois sociétés de l'amorce ; sans amorce → « ÉCRAN INATTENDU » ; palette ouverte par
  `--touche Meta+K --saisie acm --attendre "[cmdk-list]"` sur l'écran protégé → image de la
  palette remplie.

Noté pour crm-workday : un poste neuf a besoin de `npm run seed:admin` en plus de la migration,
sinon l'amorce ne peut pas ouvrir de session. À écrire dans sa section Pilot par la session du
projet.

## Nuit — ce qui n'aurait pas dû remonter jusqu'à Cédric

Le découpeur a recoupé les quatre livraisons restantes pour deux agents : 2.5b ∥ 2.6b, puis 2.4,
puis 2.6a, en déplaçant la clause « fusionner » de la phrase 31 vers 2.6a, seule façon de
rendre la paire sûre. Cédric a validé. Mais avant de lancer, il a dû dicter deux choses au lead
qu'il n'aurait pas pu trouver seul : le compte de recette du poste B, et l'endroit où graver la
décision sur l'historique à la suppression. Sa question : « est-ce que ça va arriver à chaque
fois ? » Non, si la méthode apprend. PR `docs/controle-de-poste` :

- **Contrôle de poste avant tout producteur** (`produire.md`) : le lead prépare le poste selon la
  recette de la section Pilot, puis le vérifie par la commande du testeur sur un écran protégé.
  « ÉCRAN INATTENDU » ou serveur muet : on prépare et on recommence. Aucun producteur sur un
  poste non contrôlé.
- **La ligne `Poste par worktree` porte la recette** du poste (modèle de section Pilot) :
  dépendances, migration, compte de recette.
- **Une décision de cadrage amendée se grave** dans la fiche Linear, au découpage (`cadrer.md`)
  comme pendant un run (`produire.md`), avec « amende la décision n° X ». La règle existait pour
  les décisions prises au merge.

Principe donné à Cédric : une question de produit, il répond ; une question technique, ou une
commande qu'il se retrouve à dicter, c'est un trou dans la méthode et la réponse est « écris la
règle ».
