awful.rules = require("awful.rules")

awful.rules.rules = {
  {
    rule = {},
    properties = {
      focus = true,
      keys = clientkeys,
      buttons = clientbuttons,
    }
  },

  {
    rule = { class = "Plugin-container" },
    properties = {
      floating = true,
      ontop = true,
      border = 0,
    }
  },

  {
    rule = { class = "Conky" },
    properties = { focus = false },
  },

  {
    rule_any = {
      class = {
        "MPlayer",
        "Vlc",
        "mpv",
        "Pavucontrol",
      },
    },
    properties = { fullscreen = true },
  },

  {
    rule_any = {
      class = {
        "Minecraft",
        "Gvba",
        "mednafen",
      },
    },
    properties = { floating = true },
  },

  {
    rule_any = { class = { "Slack", "hangups", "Whatsie" } },
    properties = { tag = tags[1][5], switchtotag = true },
  },
}
