#!/bin/sh

# swayidle-start.sh – Battery-conscious idle management for Niri on ThinkPad

# Kill any existing swayidle instance
pkill -x swayidle

# Start swayidle with layered timeouts
swayidle \
    timeout 300 'brightnessctl set 20%-' \          # After 5 min: dim screen
    resume 'brightnessctl set 60%' \               # On activity: restore brightness
    timeout 600 'swaylock' \                        # After 10 min: lock
