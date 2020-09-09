local awful = require("awful")
require("awful.rules")
local beautiful = require("beautiful")
local helpers = require("helpers")
local bindings = require("bindings")

awful.rules.rules = {
  -- [[ Common rules ]] --------------------------------------------------------
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      screen = awful.screen.preferred,

      keys = bindings.keyboard.clients,
      buttons = bindings.mouse.clients,

      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,

      placement = awful.placement.no_overlap +
        awful.placement.no_offscreen +
        awful.placement.centered,
    },
  },

  {
    rule = {},
    except_any = {
      class = {
        "Gpick",
        "Thunar",
        "gtgf",
        "kitty-light",
        "Xephyr",
        "scratchpad",
        "wiki",
      }
    },
    properties = {
      callback = helpers.create_tag_and_attach_to(false),
    },
  },

  -- [[ Meet ]] ----------------------------------------------------------------
  {
    rule = { name = "meet.google.com is sharing a window." },
    properties = {
      hidden = true,
    },
  },

  -- [[ Scratchpad ]] ----------------------------------------------------------
  {
    rule_any = { class = { "scratchpad", "wiki", "man", "quake" } },
    properties = {
      floating = true,
      width = 1920,
      height = 1080
    },
  },

  -- [[ Kitty ]] ---------------------------------------------------------------
  {
    rule = { class = "kitty" },
    properties = { size_hints_honor = false },
  },

  -- [[ Multimedia ]] ----------------------------------------------------------
  {
    rule = { class = "mpv" },
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

  {
    rule_any = {
      class = {
        "Slay the Spire",
        "Pathway"
      }
    },
    properties = { fullscreen = true },
  },

  {
    rule = { class = "Cockatrice" },
    except_any = { modal = true },
    properties = {
      fullscreen = false,
      floating = false,
      maximized = false
    },
  },
}
