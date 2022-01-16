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
      },
      instance = {
        "meet.google.com"
      }
    },
    properties = {
      callback = helpers.create_tag_and_attach_to(false),
    },
  },

  {
    rule_any = {
      name = {
        "meet.google.com is sharing a window.",
        "discord.com is sharing a window."
      }
    },
    properties = {
      hidden = true,
    },
  },

  -- [[ Transparency ]] --------------------------------------------------------
  {
    rule_any = {
      class = {
        "kitty",
        "kitty-light",
        "config",
      }
    },
    properties = {
      opacity = 0.9,
    },
  },

  -- [[ Meet ]] ----------------------------------------------------------------
  {
    rule = { instance = "meet.google.com" },
    properties = {
      callback = function(client)
        awful.layout.set(awful.layout.suit.tile.left)
        awful.client.swap.byidx(-1)
      end
    },
  },

  -- [[ cal.new ]] ----------------------------------------------------------------
  {
    rule = { instance = "cal.new" },
    properties = {
      floating = true,
      width = 1920,
      height = 1080,
      placement = awful.placement.centered,
    },
  },

  -- [[ Scratchpad ]] ----------------------------------------------------------
  {
    rule_any = {
      class = {
        "scratchpad",
        "wiki",
        "man",
        "quake",
        "Seahorse",
        "v4l2ucp",
        "webcam-props",
      }
    },
    properties = {
      floating = true,
      placement = awful.placement.centered,
    },
  },

  -- [[ Kitty ]] ---------------------------------------------------------------
  {
    rule = { class = "kitty" },
    properties = { size_hints_honor = false },
  },

  -- [[ RoomArranger ]] --------------------------------------------------------
  {
    rule = { class = "RoomArranger" },
    except_any = { modal = true },
    properties = {
      fullscreen = false,
      floating = false,
      maximized = true,
    },
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
        "Pathway",
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
      maximized = false,
    },
  },
}
