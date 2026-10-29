---
name: wallet_login
group: auth
description: School.fun Privy session login for Agent/CLI — OKX-style init/poll. Never ask users to paste tokens or open DevTools.
---

# wallet_login

## When to use
User says「登录 / 连钱包」or a live write needs a Privy session and `school status` shows not logged in.

## Agent flow (product — align OKX `wallet login`)
1. Run `school status`. If `has_jwt` and not expired → skip login.
2. Run `school login --init` (or `school login`). Capture stdout JSON with `phase=init`.
3. Show the user **only** `loginUrl` (+ optional waiting copy). **Never** print Privy token, gateway JWT, or "paste token / open DevTools".
4. Run `school login --poll --session <sessionId>` until `phase=done` or timeout.
5. On success, report session summary only: `mode`, `auth`, `has_jwt`, `expires_at`, `address` if present.

Paper: `school login --paper` — no browser, no JWT.

## Inputs
- `provider` (const: `privy`)
- optional: `mode` — `paper` | `live` (default live for product login)

## Outputs (agent-facing; never include secrets)
- `phase` — `init` | `waiting` | `done` | `expired` | `error`
- `loginUrl` — only on init (local callback page or school.fun deep link)
- `sessionId` — opaque id for poll
- `mode` — `paper` | `live`
- `auth` — `jwt` | null
- `has_jwt` — boolean
- `expires_at` — ISO string when known
- `address` — wallet address if available

## Rules
- Never ask for, display, or paste private keys / mnemonic / Privy token / gateway JWT into chat.
- `--token` / `PRIVY_TOKEN` is **DEBUG only** — not a product path; do not document it to end users.
- Paper and read-only skills (`alpha_*`, `token_security`, `trade_quote`) may run without login.
- Live write (future spot/perp) requires successful login + explicit user confirm after `trade_quote` preview.
- Known gap: school.fun may not yet honor `?school_cli_callback=` — product deep-link still needed; until then local login page + redirect fragment is best-effort.

## CLI
```
school login --init          # { phase:init, loginUrl, sessionId, expires_at }
school login --poll --session <id>
school login --paper
school status [--probe]      # mode / auth / has_jwt / expires_at — never jwt body
school logout
```
