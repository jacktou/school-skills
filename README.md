# school-skills

School.fun AI agent skills — mapped to site modules (Alpha Research / Spot&Perp / Vault), not GMGN clones.

## P0 IDs (frozen)
`wallet_login` (Privy auth, CLI/frontend) · `alpha_radar` · `alpha_transcript` · `token_security` · `trade_quote` · `trade_paper` · `vault_list`

## Layout
- `skills.json` — machine contract for CLI / MCP
- `skills/<id>/SKILL.md` — agent-facing skill bodies (P0 skeletons landed)

## Social fields (`alpha_transcript.social`)
`x_mentions_24h` · `narrative_tags` · `kol_handles` · `sentiment` — omit when no evidence.

## Companions
- CLI: `school-cli` (Worker)
- Design: [Figma 学习demo](https://www.figma.com/design/UMd2PuvLvBmfvzLiUyCSmu/%E5%AD%A6%E4%B9%A0demo)
