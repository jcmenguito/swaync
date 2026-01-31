#!/bin/bash
# Get current volume and mute status (using wpctl for Pipewire)
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "MUTED")

if [ "$is_muted" = "MUTED" ]; then
    notify-send -e -h string:x-canonical-private-synchronous:volume \
        -u low -i audio-volume-muted "Muted"
else
    notify-send -e -h string:x-canonical-private-synchronous:volume \
        -h int:value:"$volume" -u low -i audio-volume-high "Volume: ${volume%.*}%"
fi
