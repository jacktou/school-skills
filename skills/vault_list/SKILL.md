---
name: vault_list
description: List School.fun public/isolated vault pools (APR, TVL, Alpha Score). Use when the user asks about vaults or liquidity pools.
---

# vault_list

Maps to School.fun **Vault** page. Read-only for P0.

## Inputs
None required.

## Outputs
Array of `{ pool, apr, tvl, alpha_score, operator? }`

## Rules
- Read-only. Deposits are P1 (`vault_deposit` + Privy).
- Prefer live vault data; if unavailable, say so.
