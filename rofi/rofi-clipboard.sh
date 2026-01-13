#!/usr/bin/env bash
set -euo pipefail

# Use rofi-wayland if available
ROFI="${ROFI:-rofi}"

# Show list -> decode selected -> copy back to clipboard
sel="$(
  cliphist list \
  | $ROFI -dmenu -i -p "Clipboard" \
      -display-columns 2 \
      -no-custom
)" || exit 0

[ -z "${sel}" ] && exit 0

# Decode and put back to clipboard
# --trim-newline helps avoid adding an extra newline
printf '%s' "$sel" | cliphist decode | wl-copy --trim-newline

# Optional: auto paste into focused app (uncomment if you want)
# wtype -M ctrl -k v -m ctrl
