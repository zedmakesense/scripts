#!/usr/bin/env bash

SOURCE="@DEFAULT_AUDIO_SOURCE@"

ICON_MUTED="/usr/share/icons/Papirus/48x48/status/microphone-sensitivity-muted.svg"
ICON_ON="/usr/share/icons/Papirus/48x48/status/microphone-sensitivity-high.svg"

if wpctl get-volume "$SOURCE" | grep -q '\[MUTED\]'; then
  wpctl set-mute "$SOURCE" 0
  notify-send -t 400 -i "$ICON_ON" "Microphone" "Unmuted"
else
  wpctl set-mute "$SOURCE" 1
  notify-send -t 400 -i "$ICON_MUTED" "Microphone" "Muted"
fi
