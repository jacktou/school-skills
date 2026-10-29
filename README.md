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
- Design: [Figma 学习demo](https://www.figma.com/design/UMd2PuvLvBmfvzLiUyCSmu/%E5%AD%A6%E4%B9%A0demo)
