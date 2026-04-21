#!/bin/bash

stdin_data=$(cat)

IFS=$'\t' read -r current_dir model_name cost duration_ms < <(
  echo "$stdin_data" | jq -r '[
    .workspace.current_dir // "unknown",
    .model.display_name // "Unknown",
    (try (.cost.total_cost_usd // 0 | . * 100 | floor / 100) catch 0),
    (.cost.total_duration_ms // 0)
  ] | @tsv'
)

folder_name=$(basename "$current_dir")
git_branch=$(git -C "$current_dir" branch --show-current 2>/dev/null)

seconds=$((duration_ms / 1000))
printf '[%s] %s' "$model_name" "$folder_name"
if [ -n "$git_branch" ]; then
  printf ' | %s' "$git_branch"
fi
printf '\n$%s | %ss\n' "$cost" "$seconds"
