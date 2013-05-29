-- {{{ Rules
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = true,
			keys = clientkeys,
			buttons = clientbuttons,
			opacity = 0.9
		}
	},

	{ rule = { class = "Firefox" }, properties = { opacity = 1.0 } },
	{ rule = { class = "Opera" }, properties = { opacity = 1.0 } },
	{ rule = { class = "luakit" }, properties = { opacity = 1.0 } },
	{ rule = { class = "Plugin-container" }, properties = { floating = true, opacity = 1.0 } },
	{ rule = { class = "Operapluginwrapper-native" }, properties = { floating = true, opacity = 1.0 } },


	{ rule = { class = "Evince" }, properties = { opacity = 1.0 } },
	{ rule = { class = "Zathura" }, properties = { opacity = 1.0 } },

	{ rule = { class = "Gimp-2.8" }, properties = { opacity = 1.0 } },
	{ rule = { class = "Inkscape" }, properties = { opacity = 1.0 } },
	{ rule = { class = "feh" }, properties = { opacity = 1.0 } },
	{ rule = { class = "Gnumeric" }, properties = { opacity = 1.0 } },

	{ rule = { class = "Klavaro" }, properties = { opacity = 1.0 } },

	{ rule = { class = "Wine" }, properties = { opacity = 1.0 } },

	{ rule = { class = "Eclipse" }, properties = { opacity = 1.0 } },

	{ rule = { class = "MPlayer" }, properties = { floating = true, ontop = true, opacity = 1.0 } },
	{ rule = { class = "Vlc" }, properties = { floating = true, ontop = true, opacity = 1.0 } },

	{ rule = { class = "mednafen" }, properties = { floating = true, ontop = true, opacity = 1.0 } },
	{ rule = { class = "Phoenix" }, properties = { floating = true, ontop = true, opacity = 1.0, fullscreen = true } }, -- bsnes
	{ rule = { class = "Gvba" }, properties = { floating = true, opacity = 1.0 } },
	{ rule = { class = "Minecraft" }, properties = { floating = true } },

	{ rule = { class = "Conky" }, properties = { floating = true } },
	{ rule = { class = "Kupfer.py" }, properties = { border_width = 0 } },

	{ rule = { class = "Gpick" }, properties = { floating = true, opacity = 1.0, ontop = true } }
}
-- }}}
