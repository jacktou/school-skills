# school-skills

School.fun AI agent skills — mapped to site modules (Alpha Research / Spot&Perp / Vault), not GMGN clones.

## P0 IDs (frozen)
`wallet_login` (Privy auth, CLI/frontend) · `alpha_radar` · `alpha_transcript` · `token_security` · `trade_quote` · `trade_paper` · `vault_list`

## Auth UX (OKX Agentic Wallet style)
- Product path: Agent runs `school login --init` → user opens `loginUrl` → Agent `poll` → local gateway JWT.
- Chat shows **login link + waiting / connected** only — never paste token, never DevTools.
- `school status` → `mode` / `has_jwt` / `expires_at` (no secret body).
- Paper: `school login --paper`. Read-only skills work without login.
- Writes: `trade_quote` preview card first; user must explicitly confirm before any live sign.

## Layout
- `skills.json` — machine contract for CLI / MCP
- `skills/<id>/SKILL.md` — agent-facing skill bodies (P0 skeletons landed)

## Social fields (`alpha_transcript.social`)
`x_mentions_24h` · `narrative_tags` · `kol_handles` · `sentiment` — omit when no evidence.

## Companions
- CLI: `school-cli` (Worker) — `1fbe7dc`+ login init/poll
- Frontend (deep-link): [Building-Orderbook-DEX-Frontend-V2](https://github.com/MoonPum/Building-Orderbook-DEX-Frontend-V2) — PR [#2](https://github.com/MoonPum/Building-Orderbook-DEX-Frontend-V2/pull/2) merged (`7d96cc4`); await live Privy e2e
- DEX backend (`POST /v1/auth/privy`): [Building-Orderbook-DEX-V2](https://github.com/MoonPum/Building-Orderbook-DEX-V2)
- Other API (kuant/webapp, not CLI callback): [ak47-webapp-api](https://github.com/MoonPum/ak47-webapp-api)
- Design: [Figma 学习demo 登录四屏](https://www.figma.com/design/UMd2PuvLvBmfvzLiUyCSmu/%E5%AD%A6%E4%B9%A0demo?node-id=69-2)
