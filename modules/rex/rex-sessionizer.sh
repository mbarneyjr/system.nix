#!/usr/bin/env bash
set -eu

export PATH="${REX_BIN_DIR:-$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS}:$PATH"

if [[ $# -eq 0 ]]; then
  export FZF_DEFAULT_COMMAND="printf '%s\n' \"\$HOME/system.nix\"; find ~/dev/temp ~/dev/personal ~/dev/work/*/* -mindepth 1 -maxdepth 1 -type d 2>/dev/null"
  exec fzf --bind "enter:become($0 {})"
fi

selected=$1
name=$(basename "$selected")
session_id=$(rex ls --json | jq -r --arg name "$name" '.sessions[] | select(.label == $name) | .session_id')

if [[ -z $session_id ]]; then
  session_id=$(rex new "$name" -c "$selected" --json | jq -r .session_id)
fi

rex "do" session.select session_id="$session_id"
