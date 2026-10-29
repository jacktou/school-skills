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
- Read-only. Never places an order. Login not required.
- Before any live fill: show this preview as a **confirm card** (pair / side / size / price / fee / est_fill). Wait for explicit user「确认」; cancel stops. Aligns OKX Confirming.
- Live fills require `wallet_login` success + P1 live trade skill. Paper path: `trade_paper`.
