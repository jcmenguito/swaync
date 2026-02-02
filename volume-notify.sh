#!/bin/bash

# This the latest volume notification script I use. Google AI
# aided in writing this script

# 1. Adjust volume
if [ "$1" == "up" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0
else
    wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
fi

# 2. Source session environment so notify-send can find your display/bus
# This is required for notifications to work when triggered from Waybar
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# 3. Get volume and send notification
VOL_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
VOLUME=$(echo "$VOL_RAW" | awk '{print int($2 * 100)}')
IS_MUTE=$(echo "$VOL_RAW" | grep -o "MUTED")

if [ -n "$IS_MUTE" ]; then
    notify-send -h string:x-canonical-private-synchronous:vol -u low "Muted"
else
    # The 'vol' ID ensures the notification updates in place instead of stacking
    notify-send -h string:x-canonical-private-synchronous:vol -h int:value:"$VOLUME" -u low "Volume: ${VOLUME}%"
fi
