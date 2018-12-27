package.path = package.path .. ';/home/tlarrieu/scripts/?.lua'

--------------------------
-- Default luakit theme --
--------------------------

local theme = {}
local xrdb = require('xrdb').load()

theme.colors = xrdb.colors

-- Default settings
theme.font = xrdb.font.name .. " " .. xrdb.font.size
theme.fg   = theme.colors.foreground
theme.bg   = theme.colors.background

-- Genaral colours
theme.success_fg = theme.colors.green.dark
theme.loaded_fg  = theme.colors.blue.dark
theme.error_fg = theme.colors.foreground
theme.error_bg = theme.colors.red.dark

-- Warning colours
theme.warning_fg = theme.colors.red.dark
theme.warning_bg = theme.colors.white.dark

-- Notification colours
theme.notif_fg = theme.colors.foreground
theme.notif_bg = theme.colors.background

-- Menu colours
theme.menu_fg                   = theme.colors.foreground
theme.menu_bg                   = theme.colors.background
theme.menu_selected_fg          = theme.colors.background
theme.menu_selected_bg          = theme.colors.green.dark
theme.menu_title_bg             = theme.colors.background
theme.menu_primary_title_fg     = theme.colors.blue.dark
theme.menu_secondary_title_fg   = theme.menu_primary_title_fg

theme.menu_disabled_fg = theme.colors.black.light
theme.menu_disabled_bg = theme.menu_bg
theme.menu_enabled_fg = theme.menu_fg
theme.menu_enabled_bg = theme.menu_bg
theme.menu_active_fg = theme.colors.blue.dark
theme.menu_active_bg = theme.menu_bg

-- Proxy manager
theme.proxy_active_menu_fg      = theme.colors.blue.dark
theme.proxy_active_menu_bg      = theme.colors.background
theme.proxy_inactive_menu_fg    = theme.colors.foreground
theme.proxy_inactive_menu_bg    = theme.colors.background

-- Statusbar specific
theme.sbar_fg         = theme.colors.foreground
theme.sbar_bg         = theme.colors.background

-- Downloadbar specific
theme.dbar_fg         = theme.colors.foreground
theme.dbar_bg         = theme.colors.background
theme.dbar_error_fg   = theme.colors.red.dark

-- Input bar specific
theme.ibar_fg           = theme.colors.foreground
theme.ibar_bg           = theme.colors.background

-- Tab label
theme.tab_fg            = theme.colors.foreground
theme.tab_bg            = theme.colors.background
theme.tab_hover_bg      = theme.tab_bg
theme.tab_ntheme        = theme.colors.white.light
theme.selected_fg       = theme.colors.magenta.dark
theme.selected_bg       = theme.colors.background
theme.selected_ntheme   = theme.tab_ntheme
theme.loading_fg        = theme.colors.blue.dark
theme.loading_bg        = theme.colors.background

theme.selected_private_tab_bg = theme.colors.blue.light
theme.private_tab_bg    = theme.selected_private_tab_bg

-- Trusted/untrusted ssl colours
theme.trust_fg          = theme.colors.green.dark
theme.notrust_fg        = theme.colors.red.dark

-- General colour pairings
theme.ok = { fg = theme.colors.foreground, bg = theme.colors.background }
theme.warn = { fg = theme.colors.red.dark, bg = theme.colors.background }
theme.error = { fg = theme.colors.foreground, bg = theme.colors.red.dark }

return theme
