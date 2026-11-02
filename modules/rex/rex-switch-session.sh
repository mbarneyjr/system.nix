#!/usr/bin/env bash
set -eu

export PATH="${REX_BIN_DIR:-$HOME/Library/Application Support/com.superlogical.rex/RexServer/Versions/Current/Rex Server.app/Contents/MacOS}:$PATH"

export FZF_DEFAULT_COMMAND="rex ls --json | jq -r '.sessions[] | [.session_id, .label] | @tsv'"
exec fzf --delimiter '\t' --with-nth 2 --bind "enter:become(rex do session.select session_id={1})"
