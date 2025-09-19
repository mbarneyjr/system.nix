#!/usr/bin/env bash

OPERATION=${1}

if [ -z "$OPERATION" ]; then
    echo "Usage: $0 <operation>"
    echo "Operations: increase, decrease, reset"
    exit 1
fi

if [ "$OPERATION" != "increase" ] && [ "$OPERATION" != "decrease" ] && [ "$OPERATION" != "reset" ]; then
    echo "Invalid operation: $OPERATION"
    echo "Valid operations: increase, decrease, reset"
    exit 1
fi

if [ "$OPERATION" == "reset" ]; then
    tmux resize-pane -t left -x "50%"
    exit 0
fi

CURRENT_WIDTH=$(tmux display-message -t left -p '#{pane_width}')
WINDOW_WIDTH=$(tmux display-message -t left -p '#{window_width}')
CURRENT_PERCENTAGE=$(( CURRENT_WIDTH * 100 / WINDOW_WIDTH ))

if [ "$OPERATION" == "increase" ]; then
    NEW_PERCENTAGE=$(( CURRENT_PERCENTAGE + 25 ))
    if [ $NEW_PERCENTAGE -ge 70 ]; then
        NEW_PERCENTAGE=75
    elif [ $NEW_PERCENTAGE -ge 45 ]; then
        NEW_PERCENTAGE=50
    fi
elif [ "$OPERATION" == "decrease" ]; then
    NEW_PERCENTAGE=$(( CURRENT_PERCENTAGE - 25 ))
    if [ $NEW_PERCENTAGE -le 30 ]; then
        NEW_PERCENTAGE=25
    elif [ $NEW_PERCENTAGE -le 55 ]; then
        NEW_PERCENTAGE=50
    fi
fi
tmux resize-pane -t left -x "${NEW_PERCENTAGE}%"
