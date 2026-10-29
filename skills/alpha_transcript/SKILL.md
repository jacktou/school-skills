---
name: alpha_transcript
description: School.fun Alpha scorecard/transcript for one token by contract address or name. Use for Alpha detail, milestones, narrative, or security context for a single token.
---

# alpha_transcript

Maps to School.fun **Alpha Research** transcript / scorecard.

## Inputs
Provide exactly one of:
- `ca` (string) — contract address
- `name` (string) — token name or symbol

## Outputs
`{ symbol, ca, alpha, milestones[], narrative, social? }`

### social (optional, XBot fields)
Only fill when evidence exists; otherwise omit or null:
- `x_mentions_24h`
- `narrative_tags[]`
- `kol_handles[]` (handles with evidence only)
- `sentiment`: `bull` | `mixed` | `bear`

## Rules
- Read-only.
- Never invent KOL handles, mention counts, or sentiment.
- Pair with `token_security` when the user asks about risk flags.
