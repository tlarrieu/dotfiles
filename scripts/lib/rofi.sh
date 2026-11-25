# shellcheck shell=bash
# Shared by the rofi pickers (rofi-github). Source it:
# . "$assets/lib/rofi.sh"

# Colors from the current rofi palette (see ~/.config/rofi/variant.rasi), in
# $green, $red, $yellow, $blue, $magenta and $cyan (named colors when the
# palette lacks them).
# The palette has no gray: $dim and $dimmer are Pango attributes fading the
# foreground, close to the panel's fg.dim and fg.dimmer (config/awesome/colors)
rofi_dir=~/.config/rofi
rofi_variant=$(sed -n 's/^@import "\(.*\)".*/\1/p' "$rofi_dir/variant.rasi" 2>/dev/null)
rofi_color() { sed -n "s/^\s*$1:\s*\(#[0-9a-fA-F]*\);.*/\1/p" "$rofi_dir/${rofi_variant:-dark}.rasi" 2>/dev/null | head -1; }
green=$(rofi_color green) red=$(rofi_color red) yellow=$(rofi_color yellow) blue=$(rofi_color blue)
magenta=$(rofi_color magenta) cyan=$(rofi_color cyan)
green=${green:-green} red=${red:-red} yellow=${yellow:-yellow} blue=${blue:-blue} magenta=${magenta:-magenta}
cyan=${cyan:-cyan}
# shellcheck disable=SC2034 # for the scripts sourcing this
dim='fgalpha="60%"' dimmer='fgalpha="40%"'

# Pango attributes for each agent state's face (see
# lib/agents.sh), for the pickers showing agents (rofi-github): the
# panel's colors (see config/awesome/widgets/agents.lua),
# running and monitoring steady instead of pulsing, idle dimmer (as the rows'
# other indicators); agent_fallback_style for unknown states
# shellcheck disable=SC2034 # for the scripts sourcing this
declare -A agent_styles=(
  [running]="color=\"$blue\"" [monitoring]="color=\"$cyan\"" [done]="color=\"$green\"" [attention]="color=\"$yellow\""
  [idle]=$dimmer
)
# shellcheck disable=SC2034 # for the scripts sourcing this
agent_fallback_style=$dimmer

# Text made safe for rows with markup (-markup-rows)
# (in bash, as are the next ones: rofi-github calls them for each row's cells)
escape() {
  local text=${1//"&"/"&amp;"}
  text=${text//"<"/"&lt;"}
  printf '%s\n' "${text//">"/"&gt;"}"
}

# How many characters a row with markup shows (its longest line): the tags
# left out, the entities (see escape) counted as one
shown_width() {
  local plain line widest=0
  plain=$1
  while [[ $plain =~ \<[^\>]*\> ]]; do plain=${plain/"${BASH_REMATCH[0]}"/}; done
  plain=${plain//"&lt;"/"<"} plain=${plain//"&gt;"/">"} plain=${plain//"&amp;"/"&"}
  while IFS= read -r line; do [ ${#line} -gt "$widest" ] && widest=${#line}; done <<<"$plain"
  echo "$widest"
}
