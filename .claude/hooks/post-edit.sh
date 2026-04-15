#!/bin/bash
# PostToolUse (Edit|Write) hook: post-edit.sh
# Auto-commits file changes after each edit.

HOOKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${HOOKS_DIR}/../.." && pwd)"
cd "${PROJECT_ROOT}" || exit 0
if ! git diff --quiet || ! git diff --staged --quiet; then
  TIME_STR="$(date +"%H:%M")"
  git add -A
  git commit -m "wip: auto-save ${TIME_STR}" --quiet
fi
