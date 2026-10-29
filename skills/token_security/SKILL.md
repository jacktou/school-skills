---
name: token_security
description: School.fun security flags for a token contract (renounced, blacklist, tax, top10). Use before trading or when the user asks if a token is safe.
---

# token_security

Maps to School.fun Alpha card security labels.

## Inputs
- `ca` (string, required)

## Outputs
`{ renounced, blacklist, tax, top10 }` where `top10` is top-10 holder percent.

## Rules
- Read-only.
- If a flag is unknown, say unknown — do not guess.
- Does not equal investment advice; only surface on-chain / site flags.
