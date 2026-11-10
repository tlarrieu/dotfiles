# shellcheck shell=bash
# Shared by the rofi pickers (rofi-github). Source it:
# . "$assets/lib/rofi.sh"

# Colors from the current rofi palette (see ~/.config/rofi/variant.rasi), in
# $green, $red, $yellow, $blue and $magenta (named colors when the palette
# lacks them).
# The palette has no gray: $dim and $dimmer are Pango attributes fading the
# foreground, close to the panel's fg.dim and fg.dimmer (config/awesome/colors)
rofi_dir=~/.config/rofi
rofi_variant=$(sed -n 's/^@import "\(.*\)".*/\1/p' "$rofi_dir/variant.rasi" 2>/dev/null)
rofi_color() { sed -n "s/^\s*$1:\s*\(#[0-9a-fA-F]*\);.*/\1/p" "$rofi_dir/${rofi_variant:-dark}.rasi" 2>/dev/null | head -1; }
green=$(rofi_color green) red=$(rofi_color red) yellow=$(rofi_color yellow) blue=$(rofi_color blue)
magenta=$(rofi_color magenta)
green=${green:-green} red=${red:-red} yellow=${yellow:-yellow} blue=${blue:-blue} magenta=${magenta:-magenta}
# shellcheck disable=SC2034 # for the scripts sourcing this
dim='fgalpha="60%"' dimmer='fgalpha="50%"'

# Pango attributes for each Claude agent state's face (see
# lib/claude-agents.sh), for the pickers showing agents (rofi-github): the
# panel's colors (see config/awesome/widgets/agents.lua),
# running steady instead of pulsing; agent_fallback_style for unknown states
# shellcheck disable=SC2034 # for the scripts sourcing this
declare -A agent_styles=(
  [running]="color=\"$blue\"" [done]="color=\"$green\"" [attention]="color=\"$yellow\""
  [idle]=$dim
)
# shellcheck disable=SC2034 # for the scripts sourcing this
agent_fallback_style=$dimmer

# Text made safe for rows with markup (-markup-rows)
escape() { sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' <<<"$1"; }

# How many characters a row with markup shows (its longest line): the tags
# left out, the entities (see escape) counted as one
shown_width() {
  local plain line widest=0
  plain=$(sed 's/<[^>]*>//g; s/&lt;/</g; s/&gt;/>/g; s/&amp;/\&/g' <<<"$1")
  while IFS= read -r line; do [ ${#line} -gt "$widest" ] && widest=${#line}; done <<<"$plain"
  echo "$widest"
}
