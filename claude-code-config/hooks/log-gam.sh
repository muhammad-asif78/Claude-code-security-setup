#!/bin/bash
set -euo pipefail

payload=$(cat)
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
cmd=$(printf '%s\n' "$payload" | jq -r '.tool_input.command // empty')
status=$(printf '%s\n' "$payload" | jq -r '.tool_response.exit_code // empty')

if [[ -n "$cmd" ]]; then
  printf '%s | exit=%s | %s\n' "$timestamp" "${status:-unknown}" "$cmd"
fi
