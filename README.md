# Agent Teams Template

A template for managing long-term projects with Claude Code through session management and role separation.

> 🇯🇵 [日本語版はこちら / Japanese version](https://github.com/skova-digital/agent-teams-template-ja)

> **Note**: This template was simplified from a production environment where a non-engineer operates AI Agent Teams. While based on a battle-tested system, bugs may remain from the templating process. If you find issues, please let us know via [Issues](https://github.com/skova-digital/agent-teams-template/issues).

---

## Why This Template Exists

When running long-term projects with Claude Code, you hit three walls:

1. **Memory loss on compact** — Every time `/compact` or context compression runs, you need to re-explain "where you left off"
2. **Multi-session / multi-tab state management is hard** — Changes made in Tab A are unknown to Tab B
3. **Quality varies between sessions** — The same types of mistakes repeat; quality checks depend on manual human effort

**Before**: After compact, every session starts with "what was I doing again?" Quality checks are purely manual.

**After**: Session restore files are auto-generated, letting you resume exactly where you left off. The Advisor runs review → fix → re-review cycles, ensuring quality until LGTM is achieved.

---

## Prerequisites

This template uses `Task` to invoke multiple departments (agents), resulting in **high token consumption**.

> The author operates on Max 20x plan, but heavy use of advisor review cycles and multi-department collaboration can hit token limits.

| Plan | Viability |
|------|-----------|
| Max 20x | Frequent multi-department invocation is possible. Advisor review cycles may consume significant tokens |
| Max 5x | Usable, but advisor review cycles and multi-department collaboration can reach token limits quickly |
| Pro | Single task routing works. Heavy department collaboration hits limits fast |
| Free | Claude Code itself is not available |

**Starting minimal**: You don't need all 8 departments. Start with just Secretary + Engineering + Reviews (3 departments). Simply delete the `CLAUDE.md` files of departments you don't need. No additional setup required.

---

## What Changes

### Session Management System

Restore previous state even after compact.

```
At session end:
  Update _working_X.md → Copy to _exit_state.md → Update _session-restore.md

At next session start:
  Read _session-restore.md → Understand previous state → Report to user
```

| File | Purpose | Updated When |
|------|---------|-------------|
| `_current_A.md` – `_current_C.md` | Records each tab's handler | Session start / handler change |
| `_working_A.md` – `_working_C.md` | Carries over work status and next steps | Session end |
| `memory/MEMORY.md` | Persists important project-wide information | Important decisions / feedback |
| `secretary/todos/master-tasks.md` | Manages all tasks by priority | Task added / completed |
| `secretary/todos/_exit_state.md` | Saves state at session end | Session end |
| `secretary/todos/_session-restore.md` | Restores state at next session start | Session end (updated for next restore) |

### Convergence Review (Automated Quality Assurance)

The Advisor department runs "review → fix → re-review" cycles, ensuring quality until LGTM.

```
Run convergence review with the advisor
```

Just say this, and the advisor will verify across 3 layers (fact-check, logic-check, risk-check), repeating until no issues remain.

### Multi-Tab Operation

Run up to 3 tabs simultaneously for parallel work. Declare `Handler A`, `Handler B`, or `Handler C` in each tab, and independent state files manage each. See the [Multi-Tab Operation Guide](docs/multi-tab.md) for details.

### 8 Department Roles

Each department has roles, permissions, and behavioral guidelines defined in its `CLAUDE.md`, and does not intervene outside its scope.

| Department | Role Summary | Main Permissions |
|-----------|-------------|-----------------|
| Secretary | Reception, task routing, session management | Read-only. No implementation or editing |
| CEO | Policy decisions, department assignment, final approval | Instructions to all departments |
| Creative | Translates requirements into design docs at implementation-ready granularity | Create/update design docs |
| Engineering | Implements based on design docs. Reports technical constraints to CEO | Create/edit source code |
| Research | Library selection, competitive analysis, research reports | Read + WebSearch + Write to research/ |
| Reviews | Verifies implementation meets design doc completion conditions. Approves or rejects | Read-only (correction instructions only) |
| HotFix | Rapidly processes minor/emergency fixes that don't need design docs | Limited editing (≤3 files, ≤30 min) |
| Advisor | Independent consultant. Reviews important decisions from multiple perspectives | Read-only (recommendations only) |

---

## Setup

### Placement

Place all files from this template in your project's `.company/` directory.
Running `claude` from the project root will automatically load `.company/CLAUDE.md`.

```
your-project/
├── .company/          ← Place this template's contents here
│   ├── CLAUDE.md
│   ├── _standards.md
│   ├── secretary/
│   │   └── ...
│   └── ...
├── src/               ← Your project's source code
└── package.json
```

### Step 1. Copy the Repository

```bash
# Clone this repo (or download ZIP) and place in your project
cp -r agent-teams-template/.company /path/to/your-project/
```

### Step 1.5. Set the Project Name

Replace `[PROJECT_NAME]` with your project name in all files.
It appears in CLAUDE.md, each department's CLAUDE.md, and `memory/MEMORY.md`.

Bulk replace (Linux/Mac):
```bash
find . -name "*.md" -exec sed -i 's/\[PROJECT_NAME\]/YourProjectName/g' {} \;
```

Bulk replace (Windows PowerShell):
```powershell
Get-ChildItem -Recurse -Filter "*.md" | ForEach-Object { (Get-Content $_.FullName) -replace '\[PROJECT_NAME\]', 'YourProjectName' | Set-Content $_.FullName }
```

### Step 2. Initialize Session Management Files (Optional)

If you want session handoff across sessions, use the files described in "Session Management System" above. They are all provided as empty templates, designed to be filled in as you use them.

### Step 3. Configure Hooks (Optional)

To automate session management and protection rules, set up hooks in the `.claude/` directory.

#### 3a. Create settings.json

```bash
cp .claude/settings.json.example .claude/settings.json
```

Place `.claude/settings.json` in the `.claude/` directory at the project root.

> **Note**: Hook command paths are relative. Claude Code executes hooks with the project root as the current directory.

#### 3b. Hook Script Functions

| Hook | Script | Purpose |
|------|--------|---------|
| SessionStart | `session-start.sh` | Generates task restore report at session start |
| Stop | `session-end.sh` | Saves work state and auto-commits at each turn end (state is saved periodically during session) |
| PreCompact | `pre-compact.sh` | Dumps state to backup file before `/compact` |
| PostToolUse (Edit\|Write) | `post-edit.sh` | Auto-commits after file edits (wip: auto-save) |
| PreToolUse (Edit\|Write\|Bash) | `infra-guard.sh` | Prevents unintended edits to `.claude/settings*.json` and `.claude/hooks/` |

#### 3c. Compact Dump Exclusion

```bash
# .gitignore is pre-configured in this repo
# .claude/compact-dumps/ is automatically excluded
```

#### 3d. Using Without Hooks

The core AI Agent Teams features (department collaboration, task management) work fine without hooks. Hooks are purely session management helpers.

### Step 4. Multi-Tab Operation (Optional)

To run multiple Claude Code sessions simultaneously for parallel work, see the [Multi-Tab Operation Guide](docs/multi-tab.md).

### Step 5. Customize Department CLAUDE.md Files

Adjust each department's role descriptions to fit your project as needed. Delete entire directories for departments you don't need.

### Step 6. Start Using with Claude Code

Run `claude` from the project root directory and request tasks from the Secretary.

```
Secretary: Change the CTA button text on the top page
```

---

## Usage

### At Session Start

When you launch Claude Code, first declare your handler:

```
Handler B
```

The Secretary updates `_current_B.md`, restores the previous work state from `_working_B.md`, and reports. Up to 3 tabs (Handlers A–C) can run simultaneously.

### Requesting Tasks

Just instruct the Secretary in natural language:

```
Change the CTA button text on the top page
```

The Secretary routes to the appropriate department.

> **Note**: Routing accuracy isn't perfect. If routed to the wrong department, specify directly: "Route that to Engineering."

### Requesting Advisor Review

When important decisions or quality checks are needed:

```
Have the advisor review this
```

The Advisor performs 3-layer verification (fact-check, logic-check, risk-check) and issues LGTM / Conditional LGTM / NG.

Common review patterns:

```
Run convergence review with the advisor  → Cycles fix→re-review until no issues remain
Run 3-layer review                       → Single pass of fact/logic/risk check
```

> **Note**: "Convergence review" repeats review → fix → re-review until LGTM. Recommended when you want quality assurance.

### Specifying a Department Directly

To route to a specific department:

```
Route to Engineering
```

```
Have Research investigate this
```

The Secretary issues a Task to the specified department.

### Ending a Session

When finishing work, tell the Secretary:

```
Update the handoff
```

The Secretary updates:
- `_working_X.md` (handoff card: current work, completed, next to do)
- `_exit_state.md` (exit state)
- `current-tasks_X.md` (task progress)

If hooks are configured, git commit and state save happen automatically.

> **Note**: Even if you close Claude Code without explicitly ending, the Stop hook (if configured) auto-saves state. However, the handoff card content may be insufficient, so explicit ending is recommended.

---

## Customization

### Adding a Department

Just instruct Claude Code:

```
"Add a Marketing department.
 Role is competitive analysis and content planning, no source code editing permissions needed."
```

Claude Code will automatically:

- Create `marketing/CLAUDE.md` (with role, permissions, behavioral guidelines)
- Add to the routing table in `CLAUDE.md`
- Set up collaboration flows with other departments as needed

> If the result doesn't match your intent, see [Adding Manually](#adding-manually-advanced-reference) below.

If you use the Advisor department, consider requesting review for significant additions (complex permissions or potential role overlap):

```
"Have the advisor review the marketing department addition proposal."
```

### Removing a Department

Just instruct Claude Code:

```
"Remove the Marketing department."
```

Claude Code will automatically:

- Delete the target directory
- Remove the row from the routing table in `CLAUDE.md`
- Update other departments' CLAUDE.md files that referenced the deleted department

### When to Add Departments

- When a specific type of work starts recurring
- When an existing department's workload grows too large
- When role boundaries become unclear

### Adding Manually (Advanced, Reference)

If you prefer to add departments manually without Claude Code:

1. Create `your-department/` directory
2. Write role, permissions, and behavioral guidelines in `your-department/CLAUDE.md`
3. Add the new department to the routing table in `CLAUDE.md`

To remove:

1. Delete the target directory
2. Remove the row from the routing table in `CLAUDE.md`

---

## Model Selection

Each department can specify a model via the `Task` `model` parameter:

| Model | Use Case | Cost |
|-------|----------|------|
| `opus` | Deep reasoning (advisor review, strategy brainstorming) | High |
| `sonnet` | Regular work (secretary, engineering, reviews, etc.) | Medium |
| `haiku` | Minor fixes, template-based work | Low |

Recommended model assignments (not hardcoded in department CLAUDE.md files):

- **Advisor**: `opus` (directly impacts review quality)
- **Secretary, Engineering, Reviews, Research**: `sonnet` (balanced)
- **HotFix**: `haiku` (lightweight is sufficient)

---

## Directory Structure

```
.company/                        ← Recommended placement for this template
├── README.md                    ← This file
├── CLAUDE.md                    ← Organization definition (main file)
├── _standards.md                ← Common rules
├── _collaboration-flow.md       ← Inter-department collaboration flow
├── _current_A.md                ← Handler A session management
├── _current_B.md                ← Handler B session management
├── _current_C.md                ← Handler C session management
├── _working_A.md                ← Handler A handoff card
├── _working_B.md                ← Handler B handoff card
├── _working_C.md                ← Handler C handoff card
├── memory/
│   └── MEMORY.md                ← Project memory (persistent info)
├── secretary/
│   ├── CLAUDE.md
│   └── todos/
│       ├── current-tasks_A.md   ← Handler A active tasks
│       ├── current-tasks_B.md   ← Handler B active tasks
│       ├── current-tasks_C.md   ← Handler C active tasks
│       ├── master-tasks.md      ← Full task list (by priority)
│       ├── _exit_state.md       ← Session exit state
│       ├── _session-restore.md  ← Session restore report
│       └── archive/             ← Completed task archive
├── ceo/
│   ├── CLAUDE.md
│   └── decisions/               ← CEO decision memos
├── creative/
│   └── CLAUDE.md
├── engineering/
│   └── CLAUDE.md
├── research/
│   └── CLAUDE.md
├── reviews/
│   └── CLAUDE.md
├── hotfix/
│   └── CLAUDE.md
└── advisor/
    ├── CLAUDE.md
    └── adr/                     ← ADR (Architecture Decision Records)
```

---

## Acknowledgments & References

This template's design was informed by the following projects and documentation:

- [Everything Claude Code (ECC)](https://github.com/affaan-m/everything-claude-code) — A comprehensive collection of Claude Code skills, agents, and hooks. Significantly influenced this template's hook design and session management approach
- [Claude Code Official Documentation](https://docs.anthropic.com/en/docs/claude-code) — Refer here for Claude Code hook specifications, Task features, and CLAUDE.md specifications

---

## License

MIT License

Copyright (c) 2026 skova-digital

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
