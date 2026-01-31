#!/bin/bash

# This is added to ~/.config/labwc/autostart.

LOCKFILE="/tmp/$(basename "$0").lock"

# Check if lockfile exists and the process is actually running
if [ -f "$LOCKFILE" ] && ps -p $(cat "$LOCKFILE") > /dev/null; then
    echo "Script is already running."
    exit 1
fi

# Create lockfile with current PID
echo $$ > "$LOCKFILE"

# Initialize Notification ID
NID=0

# Monitor UDisks2 for property changes
dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.Properties',member='PropertiesChanged'" | while read -r line; do
    if [[ "$line" == *"org.freedesktop.UDisks2.Filesystem"* ]]; then
        sleep 1
        
        LAST_MOUNT=$(findmnt -n -r -o TARGET,SOURCE | grep -E '/media|/run/media' | tail -1)
        
        if [ -n "$LAST_MOUNT" ]; then
            MOUNT_PATH=$(echo "$LAST_MOUNT" | awk '{print $1}')
            DEV_NODE=$(echo "$LAST_MOUNT" | awk '{print $2}')
            LABEL=$(lsblk -no LABEL "$DEV_NODE")
            [ -z "$LABEL" ] && LABEL="Disk"

            # -p prints the ID, -r replaces the previous notification
            NID=$(notify-send -p -r "$NID" -i drive-harddisk \
                "Drive Mounted via Disks" \
                "Label: $LABEL\nPath: $MOUNT_PATH")
        fi
    fi
done

