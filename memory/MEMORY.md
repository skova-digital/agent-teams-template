# Project Memory

> This file is an index for information that should persist across sessions.
> It integrates with Claude Code's auto memory feature and is automatically loaded at session start.
>
> **Recommended: under 200 lines** -- this is loaded into context every time, so keep only summaries and links here.
> Write details in individual files under `memory/`.

---

## Project Overview

| Item | Value |
|------|-------|
| Project name | [PROJECT_NAME] |
| Production URL | -- |
| Tech stack | -- |
| Start date | -- |

---

## Important Decisions

> Record decisions that would be costly to reverse, or that the entire team should know about.
> Manage details via links to individual files.

| Date | Decision (1-line summary) | Detail File |
|------|--------------------------|-------------|
| -- | -- | -- |

---

## User Preferences & Feedback Log

> Record repeated feedback and user preferences.
> This prevents "being told the same thing every time."

| Recorded | Content (1-line summary) | Detail File |
|----------|-------------------------|-------------|
| -- | -- | -- |

---

## Known Issues & Constraints

> Record constraints and known issues that must be kept in mind during work.

(none)

---

## Example

```markdown
## Project Overview

| Item | Value |
|------|-------|
| Project name | MyShop |
| Production URL | https://myshop.example.com |
| Tech stack | Astro v5 + Tailwind v4 + Cloudflare Pages |
| Start date | 2026-04-01 |

## Important Decisions

| Date | Decision | Detail File |
|------|----------|-------------|
| 2026-04-05 | Cart feature postponed to Phase 2 | memory/decisions/2026-04-05_cart-phase2.md |

## User Preferences & Feedback Log

| Recorded | Content | Detail File |
|----------|---------|-------------|
| 2026-04-08 | Button hover animations deemed unnecessary | -- |

## Known Issues & Constraints

- Tailwind v4: `mb-*` `py-*` spacing classes resolve to zero. Use inline styles for all spacing.
```

---

## Operating Rules for This File

1. **Index only** -- write details in individual files. This file contains only summaries + links
2. **Under 200 lines** -- if approaching the limit, move old records to individual files
3. **Update timing** -- immediately after an important decision, immediately after receiving feedback
4. **Delete cautiously** -- something that "seems unnecessary now" may be referenced later
