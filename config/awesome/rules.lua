local awful = require("awful")
require("awful.rules")

awful.rules.rules = {
  -- [[ Common rules ]] --------------------------------------------------------
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      keys = clientkeys,
      buttons = clientbuttons,
      placement = awful.placement.no_overlap +
        awful.placement.no_offscreen +
        awful.placement.centered,
      screen = awful.screen.focused,
    },
  },

  -- [[ URxvt ]] ---------------------------------------------------------------
  {
    rule_any = {
      class = {
        "URxvt",
        "XTerm",
        "kitty",
      }
    },
    properties = {
      size_hints_honor = false,
      opacity = 0.9,
    },
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
