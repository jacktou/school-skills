---
name: alpha_radar
description: List School.fun Alpha Research tokens that entered the $1M+ pool. Use when the user asks for radar, new $1M entries, or Alpha pool movers.
---

# alpha_radar

Maps to School.fun **Alpha Research** ($1M+ pool), not GMGN.

## Inputs
- `min_mcap` (number, default 1000000)
- `limit` (integer, default 20, max 50)

## Outputs
Array of `{ symbol, ca?, mcap, alpha, tags[] }`.

## Rules
- Read-only. No wallet, no signing.
- Prefer live School.fun / Alpha Research data; if unavailable, say so — do not invent tokens.
- Sort by most recent pool entry when possible.
