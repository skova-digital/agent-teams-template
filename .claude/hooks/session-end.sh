#!/bin/bash
# Stop hook: session-end.sh
# Saves current working state and auto-commits at the end of each session.

HOOKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${HOOKS_DIR}/../.." && pwd)"
COMPANY_DIR="${PROJECT_ROOT}/.company"
TODOS_DIR="${COMPANY_DIR}/secretary/todos"
DATE_STR="$(date +"%Y-%m-%d %H:%M")"
mkdir -p "${TODOS_DIR}"
# Multi-tab: copy the most recently modified _working_X.md to exit_state
LATEST_WORKING=""
LATEST_TIME=0
for f in "${COMPANY_DIR}"/_working_*.md; do
  [ -f "$f" ] || continue
  MTIME=$(stat -c %Y "$f" 2>/dev/null || stat -f %m "$f" 2>/dev/null || echo 0)
  if [ "$MTIME" -gt "$LATEST_TIME" ]; then
    LATEST_TIME=$MTIME
    LATEST_WORKING=$f
  fi
done
if [ -n "$LATEST_WORKING" ]; then
  cp "${LATEST_WORKING}" "${TODOS_DIR}/_exit_state.md"
else
  echo "# Session Exit State" > "${TODOS_DIR}/_exit_state.md"
  echo "End time: ${DATE_STR}" >> "${TODOS_DIR}/_exit_state.md"
  echo "" >> "${TODOS_DIR}/_exit_state.md"
  echo "No _working_X.md found; no handoff information available." >> "${TODOS_DIR}/_exit_state.md"
fi
cd "${PROJECT_ROOT}" || exit 0
if ! git diff --quiet || ! git diff --staged --quiet; then
  git add -A
  git commit -m "wip: auto-save ${DATE_STR}"
fi
