#!/bin/bash
SINK_INPUT=$(pactl list sink-inputs | grep -B 30 'application.name = "hypridle-audio"' \
             | grep -oP '(?<=Sink Input #)\d+' | tail -1)

[ -z "$SINK_INPUT" ] && { pkill -f "audio-client-name=hypridle-audio"; exit 0; }

for vol in 90 75 60 45 30 15 0; do
    pactl set-sink-input-volume "$SINK_INPUT" ${vol}%
    sleep 0.15
done

pactl set-sink-input-volume "$SINK_INPUT" 100%   # reset so the NEXT launch isn't restored muted
pkill -f "audio-client-name=hypridle-audio"
