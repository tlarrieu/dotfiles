awful.rules.rules = {
  {
    rule = {},
    properties = {
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
        "Pavucontrol",
      }
    },
    properties = { floating = true, ontop = true }
  },

  {
    rule = { class = "Minecraft" },
    properties = { floating = true },
  },
}
