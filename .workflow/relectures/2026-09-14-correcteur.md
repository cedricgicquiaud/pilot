# Relecture de `agents/correcteur.md` avec la grille (14 septembre 2026)

Version relue : `main` à `8412543` (960 mots). Fiche déjà courte : la relecture resserre et
aligne, elle ne déplace rien.

| Bloc | Question | Décision |
|---|---|---|
| Frontmatter | réglages | Garder (`opus`, 80 tours, décision du 10/09). |
| Qui tu es, qui travaille à côté | identité | Garder. |
| Aucune question, « ne devine pas », liste blanche, français, signature, phrase d'avancement | garde-fous ; Q5 | Garder resserrés ; la négation « ne devine pas » tombe, la cible positive reste. |
| La liste est fermée ; ce que tu vois d'autre ; défaut trop vague | cœur du métier ; Q4 : « ce défaut va dans Non corrigé avec la question » est le fini-quand du cas | Garder tel quel, resserré. |
| Le test d'abord quand testable ; sans test quand visuel | étapes | Garder ; renvoi à `tests.md` pour la forme du test (Q6). |
| « Ce que tu ne fais jamais » (modifier un test, désactiver, masquer le symptôme) | garde-fous ; Q5 | Garder, précédés de la cible positive : traiter la cause. |
| Une seule passe, trois tentatives | Q4 : compteur observable | Garder. |
| Ce que tu rends | format montré | Garder tel quel. |
| Ce qui n'est pas ton travail | refus | Garder. |

## Q3, phrases sans effet supprimées

- « Ce n'est pas un échec » : rassure le lecteur ; la phrase suivante (la PR partira non
  mergeable, l'humain tranchera) suffit à l'agent.
- « Un défaut qui disparaît de l'écran sans avoir été corrigé revient ailleurs, plus tard, et
  sans personne pour faire le lien » : redit « masquer le symptôme au lieu de traiter la cause ».

## Épreuve

Pas de banc propre à cet agent : il se mesure à la prochaine livraison de crm-workday où le
`verifier` ou le `testeur` rendront des défauts. Même liste fermée, même exigence du test
avant la correction ; la relecture n'a changé aucune règle.
