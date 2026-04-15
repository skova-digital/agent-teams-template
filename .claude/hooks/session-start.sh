#!/bin/bash
# SessionStart hook: session-start.sh
# Generates a task restore report at the start of each session.

HOOKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${HOOKS_DIR}/../.." && pwd)"
COMPANY_DIR="${PROJECT_ROOT}/.company"

if [ ! -d "${COMPANY_DIR}" ]; then
  echo "session-start: .company/ directory not found. Please check your setup."
  exit 0
fi

TODOS_DIR="${COMPANY_DIR}/secretary/todos"
RESTORE_FILE="${TODOS_DIR}/_session-restore.md"

DATE_STR="$(date +"%Y-%m-%d %H:%M")"
mkdir -p "${TODOS_DIR}"
echo "# Session Restore Report" > "${RESTORE_FILE}"
echo "" >> "${RESTORE_FILE}"
echo "Generated: ${DATE_STR}" >> "${RESTORE_FILE}"
echo "" >> "${RESTORE_FILE}"
if [ -f "${TODOS_DIR}/_exit_state.md" ]; then
  echo "## Previous Exit State" >> "${RESTORE_FILE}"
  cat "${TODOS_DIR}/_exit_state.md" >> "${RESTORE_FILE}"
  echo "" >> "${RESTORE_FILE}"
fi
if [ -f "${TODOS_DIR}/master-tasks.md" ]; then
  echo "## Incomplete Tasks (from master-tasks.md)" >> "${RESTORE_FILE}"
  grep -E "(In Progress|Pending)" "${TODOS_DIR}/master-tasks.md" >> "${RESTORE_FILE}" || echo "(none)" >> "${RESTORE_FILE}"
  echo "" >> "${RESTORE_FILE}"
fi
# Multi-tab: pick the most recently modified _working_X.md as the handoff card
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
  WORKING_NAME=$(basename "$LATEST_WORKING")
  echo "## Handoff Card (from ${WORKING_NAME})" >> "${RESTORE_FILE}"
  cat "${LATEST_WORKING}" >> "${RESTORE_FILE}"
  echo "" >> "${RESTORE_FILE}"
fi
echo "session-start.sh: Task restore report generated -> ${RESTORE_FILE}"
