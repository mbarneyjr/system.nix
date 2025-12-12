#!/usr/bin/env bash

selected=$(tmux list-sessions '-F#S' | fzf)
tmux switch-client -t "$selected"
