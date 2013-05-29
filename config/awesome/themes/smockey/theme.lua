---------------------------
-- Smockey awesome theme --
---------------------------

theme = {}

theme.config_dir = "/home/smockey/.config/awesome/themes/smockey/"

--theme.font          = "Ubuntu Mono 11"
theme.font          = "Inconsolata Bold 10"

theme.bg_normal     = "#1A1A1A"
theme.bg_focus      = "#1673AC"
theme.bg_urgent     = "#903E0A"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#CECECE"
theme.fg_focus      = "#CECECE"
theme.fg_urgent     = "#CECECE"
theme.fg_minimize   = "#CECECE"

theme.border_width  = "1"
theme.border_normal = "#000000"
theme.border_focus  = "#27A2DA"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme.config_dir .. "/taglist/sel.png"
theme.taglist_squares_unsel = theme.config_dir .. "/taglist/unsel.png"

theme.tasklist_floating_icon = theme.config_dir .. "/tasklist/floatingw.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme.config_dir .. "/submenu.png"
theme.menu_height = "20"
theme.menu_width  = "200"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = theme.config_dir .. "/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme.config_dir .. "/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme.config_dir .. "/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme.config_dir .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.config_dir .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme.config_dir .. "/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme.config_dir .. "/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme.config_dir .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.config_dir .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme.config_dir .. "/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme.config_dir .. "/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme.config_dir .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.config_dir .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme.config_dir .. "/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.config_dir .. "/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.config_dir .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.config_dir .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme.config_dir .. "/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
-- We are setting background from somewhere else (namely, ./smockey/wallpaper...
theme.wallpaper_cmd = { "feh --bg-fill /home/smockey/Pictures/Wallpapers/sir.jpg" }

-- You can use your own layout icons like this:
theme.layout_fairh = theme.config_dir .. "/layouts/fairhw.png"
theme.layout_fairv = theme.config_dir .. "/layouts/fairvw.png"
theme.layout_floating  = theme.config_dir .. "/layouts/floatingw.png"
theme.layout_magnifier = theme.config_dir .. "/layouts/magnifierw.png"
theme.layout_max = theme.config_dir .. "/layouts/maxw.png"
theme.layout_fullscreen = theme.config_dir .. "/layouts/fullscreenw.png"
theme.layout_tilebottom = theme.config_dir .. "/layouts/tilebottomw.png"
theme.layout_tileleft   = theme.config_dir .. "/layouts/tileleftw.png"
theme.layout_tile = theme.config_dir .. "/layouts/tilew.png"
theme.layout_tiletop = theme.config_dir .. "/layouts/tiletopw.png"
theme.layout_spiral  = theme.config_dir .. "/layouts/spiralw.png"
theme.layout_dwindle = theme.config_dir .. "/layouts/dwindlew.png"

-- theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"
theme.awesome_icon = theme.config_dir .. "/icon.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
