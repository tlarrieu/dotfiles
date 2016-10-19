awful.rules.rules = {
  {
    rule = {},
    properties = {
      focus = true,
      keys = clientkeys,
      buttons = clientbuttons
    }
  },

  {
    rule = { class = "Plugin-container" },
    properties = {
      floating = true,
      ontop = true,
      border = 0
    }
  },

  {
    rule_any = {
      class = { "Spotify" },
      name = { "hangups" },
    },
    properties = {
      skip_taskbar = true
    }
  },

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
