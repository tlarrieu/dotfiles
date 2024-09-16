local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')

local helpers = require('helpers')

awful.rules.rules = gears.table.join(awful.rules.rules, {
  -- [[ Common rules ]] --------------------------------------------------------
  {
    rule = {},
    properties = {
      focus = awful.client.focus.filter,
      screen = awful.screen.preferred,

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
        'Gpick',
        'Nemo',
        'vifm',
        'gtgf',
        'kitty-light',
        'Xephyr',
      },
    },
    properties = {
      callback = function(client) helpers.create_tag_and_attach_to(client, false) end,
    },
  },

  {
    rule_any = {
      name = {
        'meet.google.com is sharing a window.',
        'discord.com is sharing a window.'
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
        'kitty',
        'kitty-light',
        'vifm',
        'config',
        'accounting',
        'gtd',
        'scratchpad',
        'quake',
      }
    },
    properties = {
      opacity = 0.9,
    },
  },

  -- [[ gtgf ]] ----------------------------------------------------------

  {
    rule = { class = 'gtgf' },
    properties = {
      fullscreen = true,
    },
  },

  -- [[ Floating ]] ------------------------------------------------------------
  {
    rule_any = {
      instance = {
        'cal.new',
        'attunement.io__search',
        'scryfall.com__search',
        'rubygems.org__search',
        'pypi.org__search',
        'www.thesaurus.com__browse',
        'translate.google.com',
        'dictionary.cambridge.org',
        'dictionnaire.lerobert.com',
        'pkg.go.dev',
        'fonts.google.com',
        'nerdfonts.com',
        'tailwindcss.com',
        'music.youtube.com',
      },
      class = {
        'scratchpad',
        'wiki',
        'gtd',
        'man',
        'quake',
        'Seahorse',
        'v4l2ucp',
        'webcam-props',
        'zenity',
        'mixer',
      }
    },
    properties = {
      floating = true,
      placement = awful.placement.centered,
      callback = function(client)
        helpers.resize_and_center(client)
        helpers.create_tag_and_attach_to(client)
      end
    },
  },

  -- [[ Never kill those ]] ----------------------------------------------------
  {
    rule_any = {
      class = {
        'scratchpad',
        'wiki',
        'gtd',
        'quake',
        'steam',
      },
      instance = {
        'web.whatsapp.com',
        'tailwindcss.com',
        'music.youtube.com',
      },
    },
    properties = {
      immortal = true,
    },
  },

  -- [[ Kitty ]] ---------------------------------------------------------------
  {
    rule = { class = 'kitty' },
    properties = { size_hints_honor = false },
  },

  -- [[ Audacity ]] --------------------------------------------------------
  {
    rule = { class = 'Audacity', modal = false },
    properties = {
      fullscreen = false,
      floating = false,
      maximized = false,
    },
  },

  -- [[ Multimedia ]] ----------------------------------------------------------
  {
    rule = { class = 'mpv' },
    properties = { fullscreen = true },
  },

  -- [[ Games ]] ---------------------------------------------------------------
  {
    rule_any = {
      class = {
        'Minecraft',
        'Gvba',
        'mednafen',
      },
    },
    properties = { floating = true },
  },

  {
    rule_any = {
      class = {
        'Slay the Spire',
        'Pathway',
      }
    },
    properties = { fullscreen = true },
  },

  {
    rule = { class = 'Cockatrice', modal = false },
    properties = {
      fullscreen = false,
      floating = false,
      maximized = false,
    },
  }
})
