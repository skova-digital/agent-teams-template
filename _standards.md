# Common Rules (_standards.md)

Defines common rules that all departments must follow.

---

## 1. File Naming Conventions

### Design Documents / Specifications

```
YYYY-MM-DD_[project-name]_spec_[handler-id].md

Examples:
2026-04-11_landing-page-renewal_spec_A.md
2026-04-11_contact-form-fix_spec_B.md
```

### Task Files

```
current-tasks.md         ← Active task details (always kept up to date)
master-tasks.md          ← Full task list (by priority, all statuses)
archive/YYYY-MM.md       ← Completed task archive (monthly)
```

### Session Management Files

```
_current_A.md – _current_C.md  ← Session info per handler (6-hour expiry)
_working_A.md – _working_C.md  ← Handoff cards per handler (updated at session end)
_exit_state.md           ← Session exit state (used for next restoration)
_session-restore.md      ← Session restore report (generated at start)
memory/MEMORY.md         ← Project memory index (≤200 lines)
```

Session management file naming rules:
- Files starting with underscore (`_*.md`) are system files
- When editing manually, record the last update timestamp
- Handler identifiers: single letter A–E

### Work Orders

```
wo_[project-name]_[date].md

Example:
wo_landing-page-renewal_20260411.md
```

---

## 2. Task Status Definitions

| Status | Meaning |
|--------|---------|
| `Pending` | Not yet started. Request received but work has not begun |
| `In Progress` | Currently being worked on |
| `Review Pending` | Implementation complete. Awaiting Reviews department check |
| `Rejected` | Issues found in review, corrections needed |
| `Completed` | Review approved. User has been notified |
| `On Hold` | Work temporarily paused due to external factors |
| `Cancelled` | Work cancelled. Reason must be recorded |

### When to Update Status

- **Starting work**: `Pending` → `In Progress`
- **Work finished**: `In Progress` → `Review Pending`
- **Review result received**: Approved → `Completed`, Rejected → `Rejected`
- **Resuming after rejection**: `Rejected` → `In Progress`

---

## 3. Inter-Department Handoff Rules

### Required for Every Handoff

1. **Create a work order** — Follow the format in `_collaboration-flow.md` with background, work content, and completion conditions
2. **List related file paths** — Include paths to design docs, specs, and source files to reference
3. **State prerequisites and constraints** — Explicitly note constraints like "this library cannot be used" or "this file must not be changed"
4. **Get acknowledgment** — Confirm the receiving department understands before moving on

### Handoff Prohibitions

- Handoff via conversation only (without a work order) — always write a work order
- Handoff with vague completion conditions — "make it nice" is prohibited. Write specific pass/fail criteria
- Requesting without a deadline — always include priority and deadline (write "no deadline" if none)

---

## 4. Security Fundamentals

### Definition of Confidential Information

"Confidential information" in this project refers to the following. Add project-specific items to `CLAUDE.md`.

- Authentication credentials (API keys, tokens, passwords, etc.)
- Personal information (names, addresses, email addresses, etc.)
- Business secrets (contract details, pricing, etc.)
- Unreleased product information

### Confidential Information Handling Principles

During AI Agent Teams work, follow these principles:

1. **Principle of least privilege** — Only access information needed for the task; do not read unnecessary information
2. **Do not include in output** — Do not write confidential information directly in work orders or task records ("Set the API key" is OK; writing the key value is not)
3. **Report if in doubt** — If there's a possibility of handling confidential information unintentionally, stop work and report to Secretary/CEO

---

## 5. Communication Principles

### Inter-Department Communication Style

- **Be concise** — Keep background to a minimum. Prioritize work content and completion conditions
- **Lead with conclusions** — "Done. The changes are in ○○." Conclusion first
- **Report problems early** — Report obstacles as they occur, even if unresolved

### When to Escalate

Stop work and consult CEO or Advisor in these situations:

- Requirements have multiple interpretations and the correct one is unclear
- Meeting completion conditions requires work outside your authority
- An unexpected risk (data loss, production impact, etc.) is discovered
- Work time exceeds 2x the initial estimate

---

## 6. Pre-Commit Security Checklist

Verify the following before committing:

- [ ] No hardcoded API keys, passwords, or tokens
- [ ] User input validation is appropriate
- [ ] Error messages do not contain confidential information
- [ ] No known vulnerabilities in new dependencies
- [ ] No SQL injection, XSS, or similar vulnerabilities
