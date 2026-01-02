#!/usr/bin/env bash
set -euo pipefail

HYPR_CONF="${HYPR_CONF:-$HOME/.config/hypr/config/binds.conf}"
ROFI_PROMPT="${ROFI_PROMPT:-Control Center}"
ROFI_THEME_STR="${ROFI_THEME_STR:-window { height: 650px; width: 980px; }}"

trim() { sed 's/^[[:space:]]*//; s/[[:space:]]*$//'; }

get_mod_val() {
  local v=""
  v="$(grep -E '^\$mainMod[[:space:]]*=' "$HYPR_CONF" 2>/dev/null | head -n1 | cut -d'=' -f2- | trim || true)"
  [[ -n "$v" ]] || v="$(grep -E '^\$mod[[:space:]]*=' "$HYPR_CONF" 2>/dev/null | head -n1 | cut -d'=' -f2- | trim || true)"
  echo "$v"
}

MOD_VAL="$(get_mod_val)"

subst_mod() {
  local s="$1"
  [[ -n "$MOD_VAL" ]] || {
    echo "$s"
    return
  }
  s="${s//\$mainMod/$MOD_VAL}"
  s="${s//\$mod/$MOD_VAL}"
  echo "$s"
}

join_commas() {
  local out="" part
  for part in "$@"; do
    part="$(printf '%s' "$part" | trim)"
    [[ -n "$part" ]] || continue
    if [[ -z "$out" ]]; then out="$part"; else out="$out, $part"; fi
  done
  printf '%s' "$out"
}

# Map [GROUP] -> Nerd Font icon (change to your taste)
icon_for_group() {
  local g="$1"
  case "$g" in
  WM) printf '' ;;    # window manager / layout
  APP) printf '' ;;   # apps/launcher/terminal
  WS) printf '󰙯' ;;    # workspaces
  SYS) printf '󰍹' ;;   # system/power/lock/session
  SHOT) printf '' ;;  # screenshot/camera
  CLIP) printf '󰕍' ;;  # clipboard
  MOUSE) printf '󰗼' ;; # mouse actions
  *) printf '󰋼' ;;     # fallback
  esac
}

# Extract group token like WM from a label like: [WM] Focus left
extract_group() {
  local label="$1"
  # match [SOMETHING]
  if [[ "$label" =~ ^\[[[:space:]]*([A-Za-z0-9_+-]+)[[:space:]]*\] ]]; then
    printf '%s' "${BASH_REMATCH[1]}"
  else
    printf ''
  fi
}

declare -a DISPLAY_LINES=()
declare -a RUN_CMDS=()

while IFS= read -r line; do
  [[ "$line" =~ ^[[:space:]]*bind[a-zA-Z]*[[:space:]]*= ]] || continue

  # Comment label (text after #)
  local_comment=""
  if [[ "$line" == *"#"* ]]; then
    local_comment="$(printf '%s' "${line#*#}" | trim)"
  fi

  # RULE: only show bindings that have a comment
  [[ -n "$local_comment" ]] || continue

  # strip comment & prefix
  raw="${line%%#*}"
  raw="$(printf '%s' "$raw" | sed 's/^[[:space:]]*bind[a-zA-Z]*[[:space:]]*=[[:space:]]*//' | trim)"
  [[ -n "$raw" ]] || continue

  IFS=',' read -r -a fields <<<"$raw"
  ((${#fields[@]} >= 3)) || continue

  mod="$(printf '%s' "${fields[0]}" | trim)"
  key="$(printf '%s' "${fields[1]}" | trim)"
  dispatcher="$(printf '%s' "${fields[2]}" | trim)"

  args=""
  if ((${#fields[@]} > 3)); then
    args="$(join_commas "${fields[@]:3}")"
    args="$(printf '%s' "$args" | trim)"
  fi

  mod_disp="$(subst_mod "$mod")"
  [[ -n "$mod_disp" ]] || mod_disp="(none)"

  # Build run cmd
  if [[ "$dispatcher" == "exec" ]]; then
    [[ -n "$args" ]] || continue
    run="$args"
  else
    if [[ -n "$args" ]]; then
      run="hyprctl dispatch \"$dispatcher\" \"$args\""
    else
      run="hyprctl dispatch \"$dispatcher\""
    fi
  fi

  # Add group icon based on [GROUP] prefix in comment
  grp="$(extract_group "$local_comment")"
  ic="$(icon_for_group "$grp")"

  # Make it look like a control center line
  # Example: SUPER + Q      [WM] Close active window
  DISPLAY_LINES+=("<b>${mod_disp} + ${key}</b>   ${ic}  <i>${local_comment}</i>")
  RUN_CMDS+=("$run")
done <"$HYPR_CONF"

((${#DISPLAY_LINES[@]} > 0)) || exit 0

choice_idx="$(
  printf '%s\n' "${DISPLAY_LINES[@]}" |
    rofi -dmenu -i -markup-rows -p "$ROFI_PROMPT" \
      -theme-str "$ROFI_THEME_STR" \
      -format 'i' || true
)"

[[ -n "$choice_idx" ]] || exit 0
cmd="${RUN_CMDS[$choice_idx]}"

# exec commands may use pipes/subshells; run in shell
bash -lc "$cmd"
