package.path = package.path .. ';/home/tlarrieu/scripts/?.lua'

local dpi = require('beautiful.xresources').apply_dpi
local xrdb = require('xrdb').load()

local theme = {}

-- [[ palette ]] ---------------------------------------------------------------

theme.colors = xrdb.colors
theme.useless_gap = dpi(6)

local accent = theme.colors.magenta.dark

-- [[ styles ]] ----------------------------------------------------------------
theme.font = "Fira Code 12.5"

-- [[ colors ]] ----------------------------------------------------------------
theme.fg_normal = theme.colors.foreground
theme.fg_focus = accent
theme.fg_urgent = theme.colors.white.light

theme.tasklist_fg_focus = theme.colors.black.light

theme.bg_normal = theme.colors.background
theme.bg_focus = theme.colors.background
theme.bg_urgent = theme.colors.red.dark
theme.bg_systray = theme.bg_normal

theme.border_width = dpi(1)
theme.border_normal = theme.colors.background
theme.border_focus = accent
theme.border_urgent = theme.colors.red.dark

-- [[ notifications ]] ---------------------------------------------------------
theme.notification_bg = theme.colors.background
theme.notification_border_color = theme.colors.foreground

-- [[ icons ]] -----------------------------------------------------------------
local theme_path = os.getenv("HOME") .. "/.config/awesome/themes/xresources/"
-- taglist
theme.taglist_squares_sel   = theme_path.."taglist/square_sel.png"
theme.taglist_squares_unsel = theme_path.."taglist/square_unsel.png"

return theme
