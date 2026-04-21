#!/bin/bash
set -euo pipefail

cmd=$(jq -r '.tool_input.command // empty')
[[ -z "$cmd" ]] && exit 0

if [[ -f "${CLAUDE_PROJECT_DIR}/pnpm-lock.yaml" ]] && echo "$cmd" | grep -qE '^npm '; then
  echo "BLOCKED: This project uses pnpm, not npm." >&2
  exit 2
fi

exit 0
