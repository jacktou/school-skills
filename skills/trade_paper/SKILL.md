---
name: trade_paper
description: Local simulated School.fun trade fill (paper mode). Use for practice orders; never signs or hits chain.
---

# trade_paper

Agent/CLI-side paper mode. School.fun site has no paper switch — simulation stays local.

## Inputs
- `pair`, `side` (`buy`|`sell`|`long`|`short`), `size`

## Outputs
`{ mode: "paper", fill_price, size, pnl_sim }`

## Rules
- Never call Privy or broadcast transactions.
- Label every result clearly as paper / simulated.
- Live trading is P1 (`spot_trade` / `perp_trade`) and requires `wallet_login`.
