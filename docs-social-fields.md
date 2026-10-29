# alpha_transcript.social field口径 (XBot)

Optional object on `alpha_transcript`. No evidence → omit field or set null. Never fabricate.

| Field | Type | Meaning |
|-------|------|---------|
| x_mentions_24h | integer \| null | X/Twitter mentions in last 24h with evidence |
| narrative_tags | string[] | Narrative labels supporting $1M→$10M growth story |
| kol_handles | string[] | KOL handles only when buy/mention evidence exists |
| sentiment | bull \| mixed \| bear \| null | Aggregate tone; null if insufficient data |
