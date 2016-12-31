local awful = require("awful")
require("awful.rules")

awful.rules.rules = {
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      keys = clientkeys,
      buttons = clientbuttons,
      placement = awful.placement.no_overlap +
        awful.placement.no_offscreen +
        awful.placement.centered
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
    properties = { tag = "chat" },
  },

  {
    rule = { class = "hangups" },
    properties = { switchtotag = true },
  },
}
