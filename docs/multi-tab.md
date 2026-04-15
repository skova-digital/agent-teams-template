# Multi-Tab Operation Guide (Advanced)

How to run multiple Claude Code sessions simultaneously for parallel work.

## Overview

Normally, you give instructions to the Secretary in a single Claude Code session (1 tab). When you want to work on multiple tasks in parallel, you can run multiple tabs, each operating as a different handler.

Example:
- Handler A: Implementing a demo site
- Handler B: Drafting sales emails
- Handler C: Organizing documentation

## Setup

### 1. Handler-Specific Files

The template includes `_current_A/B/C.md` and `_working_A/B/C.md` out of the box. If you need additional handlers (D, E), create files in the same format.

```
.company/
├── _current_A.md    <- Handler A session info (included in template)
├── _current_B.md    <- Handler B session info (included in template)
├── _current_C.md    <- Handler C session info (included in template)
├── _working_A.md    <- Handler A handoff card (included in template)
├── _working_B.md    <- Handler B handoff card (included in template)
├── _working_C.md    <- Handler C handoff card (included in template)
└── ...
```

To add Handler D and beyond, copy an existing file and update the handler name (D/E) in both the filename and contents.

### 2. Task Lists Are Also Per-Handler

```
secretary/todos/
├── current-tasks_A.md
├── current-tasks_B.md
├── current-tasks_C.md
└── master-tasks.md    <- Shared across all handlers (unchanged)
```

`master-tasks.md` is shared across all handlers. Use the "Department" column in each task to track who is responsible.

### 3. Handler Assignment Flow at Session Start

When Claude Code starts in each tab, the Secretary:

1. Checks `_current_A.md` through `_current_E.md` in order
2. Assigns an unused handler (file doesn't exist or has expired)
3. Creates/updates `_current_X.md` with the assigned handler name
4. Operates as the assigned handler for the rest of the session

### 4. Hook Support

For multi-tab operation, hooks also need to be handler-aware.

To determine the handler in `session-start.sh` and `session-end.sh`:
- Compare modification times of `_current_A.md` through `_current_E.md`, treating the most recent as "current handler"
- Or set the `AGENT_TAB` environment variable to specify explicitly

```bash
# Example: specify handler via environment variable
export AGENT_TAB=B
claude
```

### 5. Conflict Prevention Between Tabs

Conflicts occur when multiple tabs edit the same file simultaneously.

Rules:
- Each handler edits only their own `_working_X.md` and `current-tasks_X.md`
- `master-tasks.md` is edited only by the Secretary (other departments read-only)
- Do not edit the same source file in two tabs simultaneously (divide work at the task level)

### 6. Git Operation Notes

- `post-edit.sh` auto-commits in each tab, which can cause conflicts
- Resolve conflicts manually when they occur
- **Important**: Run `git push` from only one tab

## When Multi-Tab Is Useful

| Situation | Recommendation |
|-----------|---------------|
| Single task | One tab is sufficient |
| 2-3 independent tasks in parallel | Multi-tab is effective |
| Organization has grown to 10+ departments | Multi-tab recommended |
| Team usage (multiple people) | Each person uses a different handler |

## Troubleshooting

### Handler Collision

If a `_current_X.md` expiry (6 hours) has passed, that handler can be reused. If it hasn't expired, use a different handler.

### Frequent Git Conflicts

Temporarily disable auto-commits from `post-edit.sh` and switch to manual commits. Comment out the PostToolUse hook in `settings.json` to disable it.
