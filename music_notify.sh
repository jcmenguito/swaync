#!/bin/bash

# Use playerctl to follow metadata changes (works for gapless/track transitions)
playerctl metadata --format '{{title}} - {{artist}}' --follow | while read -r metadata; do
    # Get details for the notification
    title=$(playerctl metadata title)
    artist=$(playerctl metadata artist)
    album=$(playerctl metadata album)
    art_url=$(playerctl metadata mpris:artUrl | sed 's/file:\/\///')

    # Send notification to SwayNC
    # -i provides the album art if available
    # -h string:x-canonical-private-synchronous:music replaces the previous music notification
    notify-send -a "Music" -i "$art_url" -h string:x-canonical-private-synchronous:music \
        "$title" "$artist\n<i>$album</i>"
done

