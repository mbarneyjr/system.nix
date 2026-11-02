#!/usr/bin/env bash
set -eu

export PATH="${REX_BIN_DIR:-$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS}:$PATH"

describe_session() {
  local session_id=$1 block_id directory
  block_id=$(rex session inspect "$session_id" --json | jq -r '[.windows[].layers[].blocks[].block_id][0] // empty')
  directory=$(rex block call process -s "$session_id" -b "$block_id" 2>/dev/null | jq -r '.foreground.cwd // .ancestors[].cwd // empty' | head -n 1 || true)
  printf '%s\t%s\n' "$session_id" "${directory/#$HOME/\~}"
}

if [[ ${1:-} == --list ]]; then
  output_dir=$(mktemp -d)
  trap 'rm -rf "$output_dir"' EXIT
  index=0
  while read -r session_id; do
    index=$((index + 1))
    describe_session "$session_id" >"$output_dir/$(printf '%03d' "$index")" &
  done < <(rex ls --json | jq -r '.sessions[].session_id')
  wait
  cat "$output_dir"/*
  exit 0
fi

export FZF_DEFAULT_COMMAND="$0 --list"
exec fzf --delimiter '\t' --with-nth 2 --bind "enter:become(rex do session.select session_id={1})"
