awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = true,
      keys = clientkeys,
      buttons = clientbuttons
    }
  }, -- Default rules for all applications

  {
    rule = { class = "Plugin-container" },
    properties = {
      floating = true,
      ontop = true,
      border = 0
    }
  }, -- Flash player

  {
    rule_any = {
      class = {
        "Gpick",
        "Gvba",
        "MPlayer",
        "Vlc",
        "mednafen",
        "mpv",
      }
    },
    properties = { floating = true, ontop = true }
  },

  {
    rule = { class = "Minecraft" },
    properties = { floating = true },
  },
}
