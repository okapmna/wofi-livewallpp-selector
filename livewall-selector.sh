#!/bin/bash

# DIR Configuration
VID_DIR="$HOME/Videos/livewall"
DISABLE_STR="! DISABLE LIVE WALLPAPER"

if [ ! -d "$VID_DIR" ]; then
    notify-send "Error" "Directory $VID_DIR not found."
    exit 1
fi

LIST=$(printf "%s\n%s" "$DISABLE_STR" "$(ls "$VID_DIR" | grep -E "\.(mp4|mkv|mov|webm)$")")

SELECTION=$(echo "$LIST" | wofi --dmenu --prompt "Select Live Wallpaper..." --width 400 --height 300 --cache-file /dev/null)

if [ -z "$SELECTION" ]; then
    exit 0
fi

# Logic to turn off
if [ "$SELECTION" = "$DISABLE_STR" ]; then
    pkill mpvpaper
    swaymsg reload
    notify-send "Live Wallpaper" "Disabled"
    exit 0
fi

# video selection
pkill mpvpaper
mpvpaper -o "--hwdec=vaapi --vo=gpu --no-audio --override-display-fps=24 --loop" "*" "$VID_DIR/$SELECTION" &

sleep 0.5
swaymsg reload

notify-send "Wallpaper Updated" "Now playing: $SELECTION"
