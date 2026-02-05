#!/bin/bash

# DIR Configuration
VID_DIR="$HOME/Videos/livewall"


if [ ! -d "$VID_DIR" ]; then
    notify-send "Error" "$VID_DIR not found."
    exit 1
fi

# Get video list to wofi
SELECTION=$(ls "$VID_DIR" | grep -E "\.(mp4|mkv|mov|webm)$" | wofi --dmenu --prompt "Pilih Live Wallpaper..." --width 400 --height 300)

# Selecting video file
if [ -n "$SELECTION" ]; then
    # Stop current livewallpaper
    pkill mpvpaper
    
    # Start mpvpaper
    mpvpaper -o "--hwdec=vaapi --vo=gpu --no-audio --override-display-fps=24 --loop" "*" "$VID_DIR/$SELECTION" &
    # mpvpaper -o "no-audio --loop" "*" "$VID_DIR/$SELECTION" &
    

    sleep 0.5
    
    # Reload Sway configuration
    swaymsg reload
    
    notify-send "Wallpaper Diganti" "Sway direload & playing: $SELECTION"
fi
