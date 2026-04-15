#!/bin/bash
# PreToolUse (Edit|Write|Bash) hook: infra-guard.sh
# Protects .claude/settings*.json and .claude/hooks/ from unintended edits.
# Delegates all judgment to infra-guard-logic.js via Node.js.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGIC_FILE="${SCRIPT_DIR}/infra-guard-logic.js"

if ! command -v node &> /dev/null; then
  echo "infra-guard: Node.js not found. Infra guard is skipped." >&2
  exit 0
fi

exec node "${LOGIC_FILE}"
