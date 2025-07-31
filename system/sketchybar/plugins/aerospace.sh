#!/usr/bin/env bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set "$NAME" drawing=on background.drawing=on
else
    sketchybar --set "$NAME" background.drawing=off
    if [[ -z "$(aerospace list-windows --workspace "$1")" ]]; then
      sketchybar --set "$NAME" drawing=off
    fi
fi
