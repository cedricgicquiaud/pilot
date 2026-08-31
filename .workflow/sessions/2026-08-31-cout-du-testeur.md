# Session du 31/08/2026 — Ce que coûte le testeur, et ce qu'il rapporte

## Point de départ

Doute de Cédric : ouvrir Chrome pour les tests visuels semble long et lourd en
ressources. Demande d'un rapport chiffré sur les dernières tâches exécutées.

## Ce qui a été mesuré

Source : les transcripts `~/.claude/projects/**/subagents/*.jsonl`, 28 passages de
`testeur` sur trois projets (WATIDO, pilotage-sandbox, PILOT), du 28 au 31/08.

- **Chrome n'est pas lent.** Ouvrir un onglet et charger la page : ~6 s. Latence
  médiane d'une action : moins de 2 s. Sur les écarts entre événements, p50 = 1,7 s,
  p95 = 6,3 s ; seuls 6 écarts sur 6 824 dépassent 90 s, et ce sont des attentes
  humaines (dont 2 h 20 sur `atest-TB1`).
- **Le coût est le nombre d'allers-retours.** Un testeur : ~92 appels navigateur,
  141 requêtes au modèle, 10,8 M jetons relus. Un producteur : 68 requêtes, 4,2 M.
  Un `verifier` : 20 requêtes, 0,7 M. Les testeurs pèsent les deux tiers des jetons
  relus de toute la boucle (301 M sur ~447 M).
- **Coût par case de recette**, la bonne unité : 0,5 min et 3–5 appels sur les
  livraisons simples ; **1,9 à 2,5 min et 23 à 31 appels, soit 3,5 à 4,4 M jetons**,
  sur sandbox et PILOT. Écart de 1 à 5 selon l'application.
- **Une capture ajoute ~1 790 jetons** au contexte (médiane mesurée) contre ~510
  pour un résultat texte, et reste relue à chaque tour suivant.

## Ce qui a été trouvé, et c'est la vraie leçon

Sur ~115 cases déroulées : 108 constatées. Les rares refus portaient souvent sur une
case mal rédigée (« rebuild > 30 s » alors qu'il prend 7 s), pas sur un défaut.

**Tous les défauts réels — huit — venaient de la colonne « vu hors cahier »** :
contour de sélection invisible (lien `inline` autour d'un SVG `block`, boîtes 0 × 0),
bloc de couleur étiré sur toute la hauteur d'une carte, bouton fixe par-dessus le menu
à 375 px, débordement horizontal, titre caché sous une barre fixe, logos coupés à
1280 × 720, lien annoncé absent. Aucun visible dans les tests, tous verts, ni dans le
diff lu par `verifier`. Environ une correction sur cinq de la boucle en vient, et
chacune a été verrouillée ensuite par un test (`afix-F4-L2`, `afix-F4-L3`,
`afix-L1d`, `afix-L2b`, `afix-F2-L2`).

Conclusion : le rejeu du cahier coûte tout et ne rapporte rien ; le coup d'œil coûte
peu et rapporte tout.

## Décisions

1. **Le testeur ne joue plus le cahier.** Passe visuelle fixe et bornée : 1280 px,
   375 px, parcours clavier, thème sombre, console. Budget dur : 12 min, 40 actions,
   8 captures. Liste explicite de ce qu'il cherche, tirée des huit défauts trouvés.
   Constater par le texte de la page, la capture ne servant que de preuve.
2. **`UAT.md` devient le cahier de recette de l'humain** (décision de Cédric), déroulé
   à la main avant mise en ligne. Le producteur continue de l'écrire, non coché, pour
   un lecteur qui ne connaît pas le code. Aucun agent ne le joue.
3. Le merge reste humain ; rien n'a changé de ce côté.

## Contre-épreuve

Nouvelle fiche rejouée sur `pilotage-sandbox`, écran Agenda : **8 minutes, 33 actions,
6 captures** contre 22 à 36 min et ~290 actions pour l'ancienne. Sept défauts remontés.
Trois confirmés dans le code sans navigateur : `grep -c focus src/style.css` = 0,
`@media` uniquement pour l'impression, et les deux champs au fond gris sont les seuls
`<select>` du formulaire. L'agent a écarté seul un faux positif (bouton « coupé » qui
n'était qu'un artefact de capture, position mesurée à l'appui). Limites du passage :
tableau de bord non atteint (budget épuisé, d'où le relèvement à 8 captures), thème
sombre non vu faute de bascule dans l'application.

## Fichiers touchés

- `BOUCLE-AGENTS.md` : schéma § 2.2, fiche « Testeur utilisateur », leçon du 31/08,
  backlog n° 5 tranché. PR #11.
- Hors dépôt : `~/.claude/agents/testeur.md` réécrit (137 → 113 lignes, ancienne
  version dans le scratchpad de la session) ; `~/.claude/skills/pilot/SKILL.md`,
  `reference/MISSION.template.md`, `evals/evals.json` (l'éval n° 3 validait l'ancien
  comportement et aurait noté à contresens).

## Prochaines étapes

1. **Captures durables** (backlog n° 12), devenu le maillon faible : les captures du
   testeur sont des identifiants de session, pas des fichiers. Maintenant que la passe
   visuelle est tout son travail, la capture *est* le rapport — elle doit s'écrire dans
   un dossier du dépôt pour être jointe à la PR.
2. `pilotage-sandbox/.pilot/MISSION.template.md` : copie locale encore à l'ancienne
   version, à resynchroniser depuis la skill au prochain `/pilot run`.
3. Défauts du bac à sable (aucun style de focus, aucune adaptation mobile) : laissés
   en l'état comme matière d'entraînement. À corriger le jour où le sandbox sera montré.
4. PR #39 et #40 du bac à sable toujours ouvertes, en attente du merge humain.
