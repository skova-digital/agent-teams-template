# Inter-Department Collaboration Flow (_collaboration-flow.md)

---

## Standard Flow (New Projects)

```
User submits request
    ↓
[Secretary] Task reception & routing decision
    ↓
  ┌─────────────────────────────────────────┐
  │ Policy undecided?     YES → [CEO] Policy │
  │                            decision      │
  │                                          │
  │ Design doc needed?    YES → [Creative]   │
  │                            Create spec   │
  └─────────────────────────────────────────┘
    ↓
[Engineering] Implementation
    ↓
[Reviews] Quality check
    ↓ (rejection returns to Engineering)
[Secretary] Completion report → User
```

---

## Shortcut Flows

### Minor Fixes (HotFix)

```
User submits request ("quick fix", "urgent")
    ↓
[Secretary] HotFix assessment (≤3 files, ≤30 minutes)
    ↓
[HotFix] Fix & verify
    ↓
[Self-check] HotFix department confirms completion conditions (Reviews not needed)
    ↓
[Secretary] Completion report → User
```

If the fix exceeds HotFix scope, switch to the standard flow.

### Consultation / Investigation Only (No Implementation)

```
User submits request ("What do you think?", "Investigate")
    ↓
[Secretary] Routes as investigation
    ↓
[Advisor] or [CEO] Investigates & responds
    ↓
[Secretary] Reports results → User
```

### Technical Research / Library Selection

```
User submits request ("Research", "Compare", "Which library?")
    ↓
[Secretary] Routes as research
    ↓
[Research] Investigates & creates report
    ↓
[Secretary] Reports results → User
```

---

## Escalation Rules

### Who to Consult When Stuck

| Situation | Consult |
|-----------|---------|
| Requirements interpretation is unclear | CEO |
| Unsure if technically feasible | Engineering → if still unclear, CEO |
| Considering a high-risk change | Advisor |
| Departments disagree | CEO → if still unresolved, Advisor |
| Unsure about urgency vs. priority balance | CEO |

### When CEO Is Unavailable

If a CEO session cannot be started, the Secretary follows this fallback flow:

1. Report the situation to the user and ask for direction
2. Assign departments according to the user's instructions

---

## Work Order Format (With Example)

```markdown
## Work Order

- Requester: Secretary
- Assignee: Engineering
- Handler: A
- Project: Change CTA button text on top page
- Priority: Medium
- Deadline: 2026-04-15

### Background & Purpose
Feedback indicated the CTA button text is unclear. Changing to a more specific expression.

### Work Content
Change the CTA button text in `src/pages/index.html`
from "Learn More" to "Book a Free Consultation".

### Completion Conditions
- Button text has been changed
- Button link destination has not changed
- Button displays correctly on mobile

### Related Files
- Design doc: None (minor change)
- Target file: `src/pages/index.html`
```

---

## Estimated Time Per Phase

| Phase | Minor | Medium | Major |
|-------|-------|--------|-------|
| Secretary reception & routing | 5 min | 10 min | 15 min |
| CEO policy decision | — | 15 min | 30 min |
| Creative (design doc) | — | 1–2 hours | half day–1 day |
| Engineering (implementation) | ≤30 min | 2–4 hours | 1–several days |
| Reviews | 15 min | 30 min | 1 hour |
| Secretary completion report | 5 min | 5 min | 5 min |

*These are rough estimates and will vary significantly depending on project complexity.*

---

## Important Notes

### No Direct Cross-Department Orders

Even if the user says "tell Engineering directly," the Secretary routes the task and records it. This ensures visibility into who is handling what at all times.

### No Skipping Reviews

Reviews cannot be skipped for reasons like "it's urgent" or "it's minor." For HotFix cases, the HotFix department performs self-check (completion condition verification only) instead of going through the Reviews department.
