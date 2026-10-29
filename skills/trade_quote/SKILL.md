---
name: trade_quote
description: Read-only spot or perp quote from School.fun markets. Use when the user wants price, fee, or estimated fill before ordering.
---

# trade_quote

Maps to School.fun **Spot & Perp** quote path.

## Inputs
- `pair` (string, required) e.g. `BEM-USDC`
- `side`: `buy` | `sell` | `long` | `short`
- `size` (number, required)

## Outputs
`{ price, fee, est_fill }`

## Rules
- Read-only. Never places an order.
- Live fills require `trade_paper` (sim) or P1 live trade + Privy.
