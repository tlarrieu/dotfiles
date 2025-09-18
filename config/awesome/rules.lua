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
        'PureRef',
      },
      instance = {
        'localhost',
      }
    },
    properties = {
      callback = function(client) helpers.create_tag_and_attach_to(client, false) end,
    },
  },

  {
    rule_any = {
      name = {
        'meet.google.com is sharing',
        'discord.com is sharing'
      }
    },
    properties = { hidden = true },
  },

  -- [[ Transparency ]] --------------------------------------------------------
  {
    rule_any = {
      class = {
        'kitty',
        'kitty-light',
        'vifm',
        'config',
        'work',
        'opencode',
        'accounting',
        'postgres',
        'gtd',
        'wiki',
        'newsboat',
        'scratchpad',
        'quake',
        'htop',
        'monkeytype.com',
      },
      instance = {
        'monkeytype.com',
      },
    },
    properties = { opacity = 0.80 },
  },

  {
    rule_any = {
      instance = {
        'www.excalidraw.com',
        'metabase',
        'www.github.com',
        'github.com__pulls',
      },
    },
    properties = { opacity = 0.90 },
  },

  -- [[ gtgf ]] ----------------------------------------------------------------

  {
    rule = { class = 'gtgf' },
    properties = {
      fullscreen = true,
      floating = false,
    },
  },

  -- [[ music ]] ---------------------------------------------------------------

  {
    rule = { instance = 'music.youtube.com', },
    properties = {
      fullscreen = false,
      floating = false,
      placement = awful.placement.centered,
      opacity = 0.80,
      callback = function(client) helpers.create_tag_and_attach_to(client) end
    },
  },

  -- [[ floating ]] ------------------------------------------------------------

  {
    rule_any = {
      role = {
        'bubble',
      },
    },
    properties = { floating = true, },
  },

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
        'web.whatsapp.com',
      },
      class = {
        'scratchpad',
        'wiki',
        'postgres',
        'gtd',
        'newsboat',
        'man',
        'quake',
        'htop',
        'opencode',
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
        'postgres',
        'gtd',
        'newsboat',
        'quake',
        'htop',
        'steam',
        'work',
        'opencode',
        'config',
      },
      instance = {
        'web.whatsapp.com',
        'tailwindcss.com',
        'music.youtube.com',
        'www.youtube.com',
        'app.slack.com',
        'meet',
        'linear.app',
        'calendar.google.com',
        'www.gmail.com',
        'www.excalidraw.com',
        'metabase',
        'documentation',
        'www.github.com',
        'github.com__pulls',
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
        'Slay the Spire',
        'Pathway',
      }
    },
    properties = { fullscreen = true, floating = false },
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
