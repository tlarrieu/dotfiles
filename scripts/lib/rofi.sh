# shellcheck shell=bash
# Shared by the rofi pickers (rofi-github, rofi-pass). Source it:
# . "$assets/lib/rofi.sh"

# Colors from the current rofi palette (see ~/.config/rofi/variant.rasi), in
# $green, $red, $yellow, $blue, $magenta and $cyan (named colors when the
# palette lacks them), and $fg (empty then).
# The palette has no gray: $dim and $dimmer are Pango attributes fading the
# foreground, close to the panel's fg.dim and fg.dimmer (config/awesome/colors)
rofi_dir=~/.config/rofi
rofi_variant=$(sed -n 's/^@import "\(.*\)".*/\1/p' "$rofi_dir/variant.rasi" 2>/dev/null)
rofi_color() { sed -n "s/^\s*$1:\s*\(#[0-9a-fA-F]*\);.*/\1/p" "$rofi_dir/${rofi_variant:-dark}.rasi" 2>/dev/null | head -1; }
green=$(rofi_color green) red=$(rofi_color red) yellow=$(rofi_color yellow) blue=$(rofi_color blue)
magenta=$(rofi_color magenta) cyan=$(rofi_color cyan)
# shellcheck disable=SC2034 # for the scripts sourcing this
fg=$(rofi_color fg) bg=$(rofi_color bg)

# Color <from> blended into color <to> (both #rrggbb) by <percent>%: an
# opaque one looking like <from> at that opacity on <to>, without the darker
# spots a translucent one leaves where glyphs overlap
# Usage: blend <from> <to> <percent>
blend() {
  local i out='#' from to
  for i in 1 3 5; do
    from=$((16#${1:i:2})) to=$((16#${2:i:2}))
    out+=$(printf '%02x' $(((from * $3 + to * (100 - $3) + 50) / 100)))
  done
  echo "$out"
}
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

# Key hints: <key>=<what it does>…, the keys dimmer than what they do. Sets
# hint_marks (each hint's markup) and hint_widths (its width, in characters)
# for hints_bar
hints() {
  local hint nbsp=$'\xc2\xa0' text mark
  hint_marks=() hint_widths=()
  for hint; do
    # No break within a hint, its key and its words held together (no-break
    # spaces)
    text=${hint#*=}
    mark="<span $dim>$(escape "<${hint%%=*}>")</span>$nbsp$(escape "${text// /$nbsp}")"
    hint_marks+=("$mark") hint_widths+=("$(shown_width "$mark")")
  done
}

# The hints (see hints), as lines fitting <width> characters of the bar's
# font: broken between hints by hand, so that no separator (a dot, dimmer
# still) ends a line, as it would where rofi wraps them
# Usage: hints_bar <width>
hints_bar() {
  local i out='' line=0 separator=' <span fgalpha="35%">•</span> '
  for i in "${!hint_marks[@]}"; do
    if [ "$line" -gt 0 ] && [ $((line + 3 + hint_widths[i])) -gt "$1" ]; then
      out+=$'\n' line=0
    fi
    [ "$line" -gt 0 ] && out+=$separator line=$((line + 3))
    out+=${hint_marks[$i]} line=$((line + hint_widths[i]))
  done
  printf '%s' "$out"
}

# The message bar goes under the list, centered (theme.rasi puts it above:
# its gutter flips with it), in a smaller font (see -mesg)
# A line divides it from the list, •───…───•, 40% of the window's width (see
# divider), centered, in 60% of theme.rasi's font (a thinner row), in the
# foreground's color at 15% on the background (an opaque blend: its glyphs
# overlap a little, which would show translucent); the foreground's own when
# the palette lacks them
# shellcheck disable=SC2034 # for the scripts sourcing this
hints_layout="content { children: [inputbar, listview, textbox-divider, message]; }
  message { margin: 0.5em 1em 1em 1em; }
  textbox { horizontal-align: 0.5; }
  textbox-divider { expand: false; background-color: transparent; margin: 0.5em 0 0 0; font: \"CaskaydiaCove Nerd Font 8.7\"; horizontal-align: 0.5;${fg:+${bg:+ text-color: $(blend "$fg" "$bg" 15);}} }"

# The divider's theme (see hints_layout), for a window <width> characters wide
# Usage: hints_divider <width>
hints_divider() {
  local divider
  # 40% of the window's width (of its rows' characters, 5/3 as many in its
  # 60% font; the dots about make up for its padding's share)
  divider=$(printf '%*s' $(($1 * 2 / 3)) '') divider="•${divider// /─}•"
  # On a line of its own: rofi reads a string up to the line's last quote, so
  # it would swallow the layout's font for the divider
  printf '\n%s' "textbox-divider { content: \"$divider\"; }"
}
