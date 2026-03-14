#!/usr/bin/env bash

if swaymsg -t get_outputs | jq -e '.[] | select(.dpms == false)' >/dev/null; then
  swaymsg 'output * dpms on'
else
  swaymsg 'output * dpms off'
fi
