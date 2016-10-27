-- [[ main ]] ------------------------------------------------------------------
theme = {}
theme.path = os.getenv("HOME") .. "/.config/awesome/themes/awesome-solarized/light/"
theme.default_themes_path = "/usr/share/awesome/themes"

-- [[ palette ]] ---------------------------------------------------------------
theme.colors = {}
theme.colors.base03  = "#002b36"
theme.colors.base02  = "#073642"
theme.colors.base01  = "#586e75"
theme.colors.base00  = "#657b83"
theme.colors.base0   = "#839496"
theme.colors.base1   = "#93a1a1"
theme.colors.base2   = "#eee8d5"
theme.colors.base3   = "#fdf6e3"
theme.colors.yellow  = "#b58900"
theme.colors.orange  = "#cb4b16"
theme.colors.red     = "#dc322f"
theme.colors.magenta = "#d33682"
theme.colors.violet  = "#6c71c4"
theme.colors.blue    = "#268bd2"
theme.colors.cyan    = "#2aa198"
theme.colors.green   = "#859900"

-- [[ styles ]] ----------------------------------------------------------------
theme.font      = "Inconsolata-g For Powerline 11"

-- [[ colors ]] ----------------------------------------------------------------
theme.fg_normal         = theme.colors.base02
theme.fg_focus          = theme.colors.green
theme.fg_urgent         = theme.colors.base3

theme.tasklist_fg_focus = theme.colors.base03

theme.bg_normal         = theme.colors.base3
theme.bg_focus          = theme.colors.base3
theme.bg_urgent         = theme.colors.red
theme.bg_systray        = theme.bg_normal

-- [[ borders ]] ---------------------------------------------------------------
theme.border_width  = "2"
theme.border_normal = theme.bg_normal
theme.border_focus  = theme.colors.green
theme.border_marked = theme.bg_urgent

-- [[ titlebars ]] -------------------------------------------------------------
theme.titlebar_bg_focus  = theme.bg_focus
theme.titlebar_bg_normal = theme.bg_normal

-- [[ mouse finder ]] ----------------------------------------------------------
theme.mouse_finder_color = theme.colors.cyan
-- mouse_finder_[timeout|animate_timeout|radius|factor]

-- [[ menu ]] ------------------------------------------------------------------
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "18"
theme.menu_width  = "200"

-- [[ icons ]] ----------------------------------------------------------------------
-- taglist
theme.taglist_squares_sel   = theme.path.."taglist/square_sel.png"
theme.taglist_squares_unsel = theme.path.."taglist/square_unsel.png"
theme.taglist_bg_focus      = "png:" .. theme.path .. "taglist/bg_focus.png"

-- misc
theme.awesome_icon      = theme.path.."/layouts/awesome-icon.png"
theme.menu_submenu_icon = theme.default_themes_path.."/default/submenu.png"

-- layout
theme.layout_tile       = theme.path.."layouts/tile.png"
theme.layout_tileleft   = theme.path.."layouts/tileleft.png"
theme.layout_tilebottom = theme.path.."layouts/tilebottom.png"
theme.layout_tiletop    = theme.path.."layouts/tiletop.png"
theme.layout_fairv      = theme.path.."layouts/fairv.png"
theme.layout_fairh      = theme.path.."layouts/fairh.png"
theme.layout_spiral     = theme.path.."layouts/spiral.png"
theme.layout_dwindle    = theme.path.."layouts/dwindle.png"
theme.layout_max        = theme.path.."layouts/max.png"
theme.layout_fullscreen = theme.path.."layouts/fullscreen.png"
theme.layout_magnifier  = theme.path.."layouts/magnifier.png"
theme.layout_floating   = theme.path.."layouts/floating.png"

-- titlebar
theme.titlebar_close_button_focus               = theme.path.."titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.path.."titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active        = theme.path.."titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.path.."titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.path.."titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.path.."titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active       = theme.path.."titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.path.."titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.path.."titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.path.."titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active     = theme.path.."titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.path.."titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.path.."titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.path.."titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    = theme.path.."titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.path.."titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.path.."titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.path.."titlebar/maximized_normal_inactive.png"

-- [[ battery widget ]] --------------------------------------------------------
theme.ac      = theme.path .. "/icons/ac.png"
theme.bat     = theme.path .. "/icons/bat.png"
theme.bat_low = theme.path .. "/icons/bat_low.png"
theme.bat_no  = theme.path .. "/icons/bat_no.png"

return theme
