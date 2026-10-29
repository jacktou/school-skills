---
name: wallet_login
group: auth
description: Privy custodial wallet login for School.fun agent (CLI/frontend). Skills use session/API key only — never private keys or seed phrases.
---

# wallet_login

## When to use
User needs to connect or refresh a School.fun / agent session via Privy before any live write.

## Inputs
- `provider` (const: `privy`)

## Outputs
- `session` — opaque session token / cookie handle for CLI
- `address` — wallet address if available
- `mode` — `paper` | `live`

## Rules
- Never ask for or display private keys / mnemonic.
- Paper mode does not require on-chain signing.
- Live trade/deposit requires successful Privy session first.

## CLI
`school login` → browser Privy callback → store session locally.
