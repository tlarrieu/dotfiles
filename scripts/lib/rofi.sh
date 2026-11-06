# shellcheck shell=bash
# Shared by the rofi pickers (rofi-github, rofi-agents). Source it:
# . "$assets/lib/rofi.sh"

# Colors from the current rofi palette (see ~/.config/rofi/variant.rasi), in
# $green, $red, $yellow and $blue (named colors when the palette lacks them).
# The palette has no gray: $dim and $dimmer are Pango attributes fading the
# foreground, close to the panel's fg.dim and fg.dimmer (config/awesome/colors)
rofi_dir=~/.config/rofi
rofi_variant=$(sed -n 's/^@import "\(.*\)".*/\1/p' "$rofi_dir/variant.rasi" 2>/dev/null)
rofi_color() { sed -n "s/^\s*$1:\s*\(#[0-9a-fA-F]*\);.*/\1/p" "$rofi_dir/${rofi_variant:-dark}.rasi" 2>/dev/null | head -1; }
green=$(rofi_color green) red=$(rofi_color red) yellow=$(rofi_color yellow) blue=$(rofi_color blue)
green=${green:-green} red=${red:-red} yellow=${yellow:-yellow} blue=${blue:-blue}
dim='fgalpha="60%"' dimmer='fgalpha="50%"'

# Text made safe for rows with markup (-markup-rows)
escape() { sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g' <<<"$1"; }
