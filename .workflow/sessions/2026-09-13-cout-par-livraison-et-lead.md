# Session du 13 septembre 2026 — le coût par livraison et la taxe de coordination

## Fait

- Analyse d'une vidéo sur la loi de Brooks appliquée aux agents (essai Cursor, cinq règles de
  vie ; expériences Anthropic ; incident OpenAI). Verdict : `pilot` couvre découper, trancher,
  garder ; manquaient le coût du lead et un chiffre par livraison.
- Relevé de coût : une ligne par livraison (tous agents, corrections et repasses comprises)
  et une ligne par run pour le lead, lue dans le journal de sa session. Sur crm-workday, le
  lead pèse 16 à 24 % des jetons ; 19 % sur le tour à deux producteurs.
- Fiche du verifier : vérifie que chaque décision produit de la mission est appliquée.
- Backlog n° 14 dans `BOUCLE-AGENTS.md`. Doc : `produire.md` étape 7, `suivre.md`.

## Reste

- Merge, puis `/pilot update` sur les deux projets.
- crm-workday : 2.6a rendue le 10/09, feature 2 complète à sa merge ; « run fini » à relever.
- « Trois producteurs » se décide après le tour 2, sur la part du lead et la jauge.

## Décidé — portage et modèles locaux (13/09, après-midi)

- Question posée : porter `pilot` hors de Claude Code (Pi, pi.dev), avec des LLM locaux, sur
  un Mac ou un VPS. Analyse faite, rien construit.
- Pi : portage faisable (fiches d'agent au même format via l'extension `subagent`, skills au
  même standard, événement `tool_call` pour la liste blanche, journal JSONL documenté). Coûte
  environ une semaine, surtout Linear sans MCP et le lecteur de coûts. Point ouvert : accès
  aux modèles par clé d'API, hors abonnement.
- Local : le Mac actuel (M1 Pro, 16 Go) ne tient qu'un testeur. Le palier utile est 128 Go de
  mémoire unifiée ; les rôles de relecture restent sur le meilleur modèle cloud quoi qu'il
  arrive. Un VPS sans GPU ne sert qu'à héberger la boucle, pas le modèle.
- **Décision : rester sur le cloud.** Rouvrir seulement si un client exige que le code ne
  sorte pas (serveur GPU dédié, facturé au client), si la facture devient le frein (d'abord un
  modèle ouvert par API pour le testeur, via Pi), ou à plusieurs runs par jour. Dans les trois
  cas, l'épreuve TST-B1 sur le sandbox décide du modèle, comme pour les bancs précédents.
