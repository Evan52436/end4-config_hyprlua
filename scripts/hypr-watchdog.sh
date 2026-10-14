#!/bin/bash

# Listen to Hyprland's event socket
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do
    # Check if the event is a monitor disconnecting
    if [[ "$line" == monitorremoved* ]]; then
        # An external monitor was unplugged! Force the laptop screen to wake up.
        # If the screen is already on, Hyprland will safely ignore this.
        hyprctl keyword monitor "eDP-1,preferred,auto,1"
    fi
done
