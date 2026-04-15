#!/bin/bash
# PreCompact hook: pre-compact.sh
# Dumps current state to compact-dumps/ before /compact runs.

HOOKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${HOOKS_DIR}/../.." && pwd)"
COMPANY_DIR="${PROJECT_ROOT}/.company"
DUMPS_DIR="${HOOKS_DIR}/../compact-dumps"
mkdir -p "${DUMPS_DIR}"
TS="$(date +"%Y-%m-%d_%H%M%S")"
DUMP_FILE="${DUMPS_DIR}/${TS}.md"
echo "# Pre-compact dump ${TS}" > "${DUMP_FILE}"
echo "" >> "${DUMP_FILE}"

# Multi-tab: dump all _current_*.md files
for f in "${COMPANY_DIR}"/_current_*.md; do
  [ -f "$f" ] || continue
  echo "## $(basename "$f")" >> "${DUMP_FILE}"
  cat "$f" >> "${DUMP_FILE}"
  echo "" >> "${DUMP_FILE}"
done

# Multi-tab: dump all _working_*.md files
for f in "${COMPANY_DIR}"/_working_*.md; do
  [ -f "$f" ] || continue
  echo "## $(basename "$f")" >> "${DUMP_FILE}"
  cat "$f" >> "${DUMP_FILE}"
  echo "" >> "${DUMP_FILE}"
done

# Multi-tab: dump all current-tasks_*.md files
for f in "${COMPANY_DIR}"/secretary/todos/current-tasks_*.md; do
  [ -f "$f" ] || continue
  echo "## $(basename "$f")" >> "${DUMP_FILE}"
  cat "$f" >> "${DUMP_FILE}"
  echo "" >> "${DUMP_FILE}"
done

# Shared file: master-tasks.md
if [ -f "${COMPANY_DIR}/secretary/todos/master-tasks.md" ]; then
  echo "## master-tasks.md" >> "${DUMP_FILE}"
  cat "${COMPANY_DIR}/secretary/todos/master-tasks.md" >> "${DUMP_FILE}"
  echo "" >> "${DUMP_FILE}"
fi

echo "pre-compact.sh: State dumped -> ${DUMP_FILE}"
