#!/bin/bash

# This is added to ~/.config/labwc/autostart

LOCKFILE="/tmp/$(basename "$0").lock"

# Check if lockfile exists and the process is actually running
if [ -f "$LOCKFILE" ] && ps -p $(cat "$LOCKFILE") > /dev/null; then
    echo "Script is already running."
    exit 1
fi

# Create lockfile with current PID
echo $$ > "$LOCKFILE"

# Listen for udisks2 JobRemoved signals on the System Bus
dbus-monitor --system "type='signal',interface='org.freedesktop.DBus.ObjectManager',member='InterfacesRemoved'" | while read -r line; do
    # Check if the removed object is a block device (e.g., /dev/sdb1)
    if echo "$line" | grep -q "block_devices"; then
        # Use swaync-client or notify-send to alert the user
        notify-send "Safe to Remove" \
            "The drive has been successfully unmounted and powered off." \
            -i drive-removable-media \
            -a "SwayNC" \
            -u normal
    fi
done

