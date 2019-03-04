local awful = require("awful")
require("awful.rules")
local beautiful = require("beautiful")

awful.rules.rules = {
  -- [[ Common rules ]] --------------------------------------------------------
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      keys = clientkeys,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      buttons = clientbuttons,
      placement = awful.placement.no_overlap +
        awful.placement.no_offscreen +
        awful.placement.centered,
      screen = awful.screen.focused,
    },
  },

  -- [[ Kitty ]] ---------------------------------------------------------------
  {
    rule = { class = "kitty" },
    properties = { size_hints_honor = false },
  },

  -- [[ Flash player ]] --------------------------------------------------------
  {
    rule = { class = "Plugin-container" },
    properties = {
      floating = true,
      ontop = true,
      border = 0,
    },
  },

  -- [[ Multimedia ]] ----------------------------------------------------------
  {
    rule_any = {
      class = {
        "mpv",
        "Pavucontrol",
      },
    },
    properties = { fullscreen = true },
  },

  -- [[ Gnuplot ]] -------------------------------------------------------------
  {
    rule = { class = "Gnuplot" },
    properties = { fullscreen = true },
  },

  {
    rule = { class = "Slay the Spire" },
    properties = { fullscreen = true },
  },

  -- [[ Games ]] ---------------------------------------------------------------
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

  -- [[ Chat ]] ----------------------------------------------------------------
  {
    rule_any = { class = { "Slack", "hangups", "Whatsie" } },
    properties = { tag = "" },
  },

  {
    rule = { class = "hangups" },
    properties = { switchtotag = true },
  },
}
