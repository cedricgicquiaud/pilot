# Étalon TST-B1 « Étiquettes de contact »

L'épreuve qui sert à comparer deux versions d'une fiche d'agent (ou deux modèles) sur
`Projects/pilotage-sandbox`. Même mission, même commit de départ, un worktree par version,
le même `verifier` sur chaque copie. On compare : contrat couvert (sur 10), points
bloquants et mineurs relevés par le verifier, commits test-avant-code, tests écrits, durée
active, échanges, jetons relus (`cout-agents`).

Ce fichier est une archive : l'ordre de mission tel qu'il a été joué le 10 septembre 2026,
et les mesures obtenues. Il n'était jusqu'ici que dans un worktree non versionné du sandbox.

## Mesures de référence (10 septembre 2026, fiches de cette date)

| Version | Contrat | Bloquant | Mineurs | Commits | Tests | Lignes | Durée | Échanges | Jetons relus |
|---|---|---|---|---|---|---|---|---|---|
| `tdd-writer` sur Opus | 10/10 | 0 | 4 | 23 | 11 | 235 | 11 min | 107 | 11 M |
| `tdd-writer` sur Fable | 10/10 | 0 | 3 | 29 | 13 | 277 | 15 min | 157 | 19 M |

Branches conservées en local sur le sandbox : `bench/TST-B1-etiquettes-opus`,
`bench/TST-B1-etiquettes-fable`, `bench/TST-B1-etiquettes-codex`. Détail et décisions dans
`BOUCLE-AGENTS.md`, backlog n° 4.

## Comment rejouer

1. Sur le sandbox, un worktree par version de la fiche, au même commit de `main` :
   `git worktree add ../pilotage-sandbox-bench-<nom> -b bench/TST-B1-etiquettes-<nom> main`.
2. Poser dans chaque worktree la version de `.claude/agents/<fiche>.md` à mesurer et le
   `MISSION.md` ci-dessous à la racine.
3. Lancer le `tdd-writer` dans chaque worktree avec la même consigne, en même temps.
4. Lancer le même `verifier` sur chaque copie, contrat en main.
5. Relever les colonnes du tableau avec `cout-agents` et le rapport du verifier.

## MISSION.md joué

```markdown
# MISSION — TST-B1 Étiquettes de contact

_Ordre de mission d'une livraison de banc. Il n'y a pas de fiche Linear : tout ce que tu dois_
_savoir est ici. N'appelle pas Linear. Ne pousse pas ta branche, n'ouvre pas de PR : à la_
_clôture, commite localement, écris ton rapport et arrête-toi._

## Ta mission

- Feature : **Étiquettes de contact** — livraison 1/1 « Poser, retirer, filtrer »
- Tâches : TST-B1-a (poser et retirer une étiquette sur un contact), TST-B1-b (filtrer la
  liste des contacts par étiquette), TST-B1-c (la fiche du contact montre ses étiquettes)
- Branche : celle sur laquelle tu es (déjà créée)
- Titre de ta PR (ne pas l'ouvrir) : `TST-B1 Étiquettes de contact`

## Fichiers que tu modifies

- `src/contacts.js`
- `src/ui.js` (écrans `contacts` et `contact` seulement)
- `tests/tags.test.js` (nouveau)
- `tests/isolation.test.js` (seulement si tu ajoutes une table scopée)
- `UAT.md` (section de cette livraison seulement)

## Décisions produit déjà prises

- Une étiquette est un texte libre de 1 à 24 caractères, gardé tel que saisi (casse et accents
  conservés à l'affichage), sans espaces en début ni en fin.
- Deux étiquettes sont « les mêmes » si elles sont égales une fois la casse, les accents et
  les espaces superflus ignorés (la normalisation existe déjà dans `Contacts.filter`).
- Les étiquettes d'un espace sont l'ensemble des étiquettes portées par ses contacts : il n'y a
  pas d'étiquette « orpheline ». Le stockage est laissé au producteur.
- Poser ou retirer une étiquette demande le droit `editContacts`, qui existe déjà. Aucune
  nouvelle action de permission.
- Sur la liste des contacts, le filtre par étiquette est un `<select>` « Toutes » plus une
  option par étiquette de l'espace, triée par ordre alphabétique français ; il se combine
  avec la recherche et le filtre entreprise.
- Sur la fiche d'un contact existant, les étiquettes s'affichent sous les champs du formulaire,
  chacune avec un bouton « Retirer », et un petit formulaire « Ajouter une étiquette » ; sur
  un nouveau contact (pas encore créé), rien de tout cela.

## Contrat de validation — ce que ta livraison doit rendre vrai

1. Un membre pose une étiquette sur un contact ; le contact peut en porter plusieurs.
2. Poser une étiquette « la même » qu'une déjà portée (casse, accents, espaces ignorés) est
   refusé avec un message ; le contact garde ses étiquettes telles quelles.
3. Une étiquette vide, ou de plus de 24 caractères une fois les espaces des bords retirés, est
   refusée avec un message ; rien n'est enregistré.
4. Une étiquette se retire d'un contact ; retirer une étiquette qu'il ne porte pas ne change
   rien et ne lève pas d'erreur.
5. La liste des étiquettes de l'espace ne contient que les étiquettes encore portées par au
   moins un contact, sans doublon, triée par ordre alphabétique français.
6. Le filtre par étiquette de la liste des contacts ne garde que les contacts qui la portent,
   et se combine par intersection avec la recherche et le filtre entreprise.
7. Refus : sans le droit `editContacts`, poser ou retirer une étiquette est refusé par
   `Permissions.assert`, et rien ne change.
8. Refus : les étiquettes d'un espace sont invisibles depuis un autre espace, y compris par
   l'identifiant du contact.
9. Supprimer un contact emporte ses étiquettes : elles ne comptent plus dans la liste de
   l'espace.
10. La fiche d'un contact existant affiche ses étiquettes, chacune passée par le helper
    d'échappement, avec un bouton « Retirer » par étiquette et un formulaire d'ajout ; le
    message de refus s'affiche sous le champ avec `role="alert"`.

## Idiomes de ce projet

- Tout texte saisi par un utilisateur passe par le helper d'échappement avant toute
  insertion dans le DOM — texte ET attributs. Jamais de donnée brute dans un `innerHTML`.
- Toute action de permission passe par `Permissions.assert` avant toute lecture ou écriture ;
  `editContacts` existe.
- Toute lecture et écriture de données passe par `Data` (scopé par espace). Si tu ajoutes une
  table, elle va dans `Data.SCOPED` et dans `tests/isolation.test.js`.
- Un formulaire ne recharge pas la page ; les erreurs s'affichent sous le champ,
  `aria-invalid` et `aria-describedby` posés.

## Commande de tests

`node --test tests/*.test.js`
```
