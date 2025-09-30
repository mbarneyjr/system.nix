#!/usr/bin/env bash

# {
#   "hook_event_name": "Status",
#   "session_id": "abc123...",
#   "transcript_path": "/path/to/transcript.json",
#   "cwd": "/current/working/directory",
#   "model": {
#     "id": "claude-opus-4-1",
#     "display_name": "Opus"
#   },
#   "workspace": {
#     "current_dir": "/current/working/directory",
#     "project_dir": "/original/project/directory"
#   },
#   "version": "1.0.80",
#   "output_style": {
#     "name": "default"
#   },
#   "cost": {
#     "total_cost_usd": 0.01234,
#     "total_duration_ms": 45000,
#     "total_api_duration_ms": 2300,
#     "total_lines_added": 156,
#     "total_lines_removed": 23
#   }
# }

input=$(cat)
version=$(echo "$input" | jq -r '.version')
model_id=$(echo "$input" | jq -r '.model.id')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd')

echo "Claude Code ${version} | Model: $model_id | Cost: $cost USD"
