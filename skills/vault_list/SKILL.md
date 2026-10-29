---
name: vault_list
description: List School.fun public/isolated vault pools (APR, TVL, status). Use when the user asks about vaults or liquidity pools. No alphaScore.
---

# vault_list

Maps to School.fun **Vault** page. Read-only for P0.

## Inputs
None required.

## Outputs
Array of `{ pool, apr, tvl, operator? }`

No `alphaScore`. That field belongs on `alpha_radar` (kuant tokens), not vaults.

## Rules
- Read-only. Deposits are P1 (`vault_deposit` + Privy).
- Prefer live vault data; if unavailable, say so.
