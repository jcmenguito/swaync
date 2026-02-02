#!/bin/bash

# Log file for debugging
LOG="/tmp/gapless_notify.log"

# Automatically find the player name starting with 'g4music' or 'com.github'
PLAYER=$(playerctl -l | grep -E 'g4music|com.github.neithern' | head -n 1)

if [ -z "$PLAYER" ]; then
    echo "Gapless player not found" >> $LOG
    exit 1
fi

echo "Starting listener for $PLAYER" >> $LOG

# Use --follow to catch track changes
playerctl --player="$PLAYER" metadata --format '{{title}} - {{artist}}' --follow | while read -r SONG_INFO; do
    notify-send -a "Gapless" -i "audio-x-generic" "Now Playing" "$SONG_INFO"
    echo "Notified: $SONG_INFO" >> $LOG
done

