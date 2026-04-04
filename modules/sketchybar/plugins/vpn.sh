#!/usr/bin/env bash

VPN=$(scutil --nc list | grep Connected | sed -E 's/.*"(.*)".*/\1/')
if [[ $VPN != "" ]]; then
  sketchybar --set vpn \
    drawing=on \
    label="$VPN"
else
  sketchybar --set vpn drawing=off
fi
