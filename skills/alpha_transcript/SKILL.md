---
name: alpha_transcript
description: School.fun Alpha scorecard / transcript for one token. Use when the user asks for Alpha score details, milestones, or narrative for a named token or CA.
---

# alpha_transcript

Maps to School.fun **Alpha Research** scorecard / transcript, not GMGN.

## Inputs
- `ca` (string) **or** `name` (string) — one required

## Outputs
`{ symbol, ca?, alphaScore, milestones[], narrative?, social? }`

`alphaScore` matches `alpha_radar` (kuant). Always bind to the same chain as the CA — do not copy a trending row from another chain. If radar/lookup misses (`hit:false` / not in pool), say so and leave score null/omit — do not invent.

`social` is optional: `{ x_mentions_24h, narrative_tags[], kol_handles[], sentiment }`. Omit or null fields when no evidence.

## Rules
- Read-only. No wallet, no signing.
- Prefer live School.fun / kuant data; if unavailable, say so.
- Never fabricate social metrics.
