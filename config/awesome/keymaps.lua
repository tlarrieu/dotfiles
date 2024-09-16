local _M = {
  keyboard = {},
  mouse = {}
}

-- [[ Variables ]] -------------------------------------------------------------

local awful = require('awful')
local helpers = require('helpers')
local gears = require('gears')

local spawner = require('spawner')

local home = os.getenv('HOME')
local dotfiles = string.format('%s/git/dotfiles', home)
local accounting = string.format('%s/git/accounting', home)
local sandbox = string.format('%s/sandbox', home)
local neorg = string.format('%s/.neorg', home)

local mod = 'Mod4'

local increment = 0.01

local view_tag = function(id) awful.screen.focused().tags[id]:view_only() end

local focus_client = function(direction)
  awful.client.focus.byidx(direction)
  if client.focus then client.focus:raise() end
end

-- [[ Keyboard ]] ==============================================================

_M.keyboard = {
  clients = gears.table.join(
    spawner.key({ mod }, 'Return', function(c) c.fullscreen = not c.fullscreen end),
    spawner.key({ mod }, 'eacute', function(c) if c.immortal then c:tags({}) else c:kill() end end),
    spawner.key({ mod, 'Shift' }, 'eacute', function(c) c:kill() end),

    spawner.key({ mod, 'Control' }, 'c', function(c)
      awful.tag.viewprev()
      c:move_to_tag(c.screen.selected_tag)
    end),

    spawner.key({ mod, 'Control' }, 'r', function(c)
      awful.tag.viewnext()
      c:move_to_tag(c.screen.selected_tag)
    end),

    spawner.key({ mod }, 'n', function(client) helpers.create_tag_and_attach_to(client, true) end),
    spawner.key({ mod }, 'o', function(client)
      client:move_to_screen()
      helpers.create_tag_and_attach_to(client, true)

      -- HACK: This is a **dirty** trick to counteract Awesome's fallback mechanism
      -- when closing a volatile tag (the focus goes to the next client of the
      -- next tag of the source screen, instead of following the client on the
      -- next screen)
      -- Since the screen is focused (but not the client) after the
      -- client:move_to_screen, we can wait a few milliseconds (otherwise the
      -- trick does not work) and trigger an awful.tag.viewprev(), followed by a
      -- awful.tag.viewnext() (so it is as we never changed tag by calling it)
      -- which will give the focus to the client we just moved to the other
      -- screen.
      gears.timer {
        timeout     = 0.2,
        single_shot = true,
        autostart   = true,
        callback    = function()
          awful.tag.viewprev()
          awful.tag.viewnext()
        end
      }
    end)
  ),

  root = gears.table.join(
    -- [[ Window Manager ]] ----------------------------------------------------

    spawner.key({ mod }, 'l', 'rofi-layouts'),

    spawner.key({ mod }, 'c', awful.tag.viewprev),
    spawner.key({ mod }, 'Left', awful.tag.viewprev),
    spawner.key({ mod }, 'r', awful.tag.viewnext),
    spawner.key({ mod }, 'Right', awful.tag.viewnext),

    spawner.key({ mod }, '"', function() view_tag(1) end),
    spawner.key({ mod }, 'guillemotleft', function() view_tag(2) end),
    spawner.key({ mod }, 'guillemotright', function() view_tag(3) end),
    spawner.key({ mod }, '(', function() view_tag(4) end),
    spawner.key({ mod }, ')', function() view_tag(5) end),
    spawner.key({ mod }, '@', function() view_tag(6) end),
    spawner.key({ mod, 'Control' }, 't', function() awful.client.swap.byidx(1) end),
    spawner.key({ mod, 'Control' }, 's', function() awful.client.swap.byidx(-1) end),
    spawner.key({ mod }, 'd', function() awful.tag.incmwfact(increment) end),
    spawner.key({ mod }, 'v', function() awful.tag.incmwfact(-increment) end),
    spawner.key({ mod, 'Shift' }, 'd', function() awful.client.incwfact(increment) end),
    spawner.key({ mod, 'Shift' }, 'v', function() awful.client.incwfact(-increment) end),
    spawner.key({ mod }, 't', function() focus_client(1) end),
    spawner.key({ mod }, 'Down', function() focus_client(1) end),
    spawner.key({ mod }, 's', function() focus_client(-1) end),
    spawner.key({ mod }, 'Up', function() focus_client(-1) end),
    spawner.key({ mod }, 'i', function() awful.screen.focus_relative(1) end),
    spawner.key({ mod }, 'e', function() awful.screen.focus_relative(-1) end),
    spawner.key({ mod, 'Shift' }, 'r', awesome.restart),

    -- [[ Togglers ]] ----------------------------------------------------------

    spawner.key({ mod, 'Shift' }, 't', require('context').toggle),
    spawner.key({ mod, 'Shift' }, 'b', 'toggle-light-and-dark.sh'),

    -- [[ Applications ]] ------------------------------------------------------

    spawner.key({ mod }, ' ', 'rofi -show combi -modes combi -combi-modes " :~/scripts/rofi-clients.sh,run" -display-combi "" -display-run "󱕷"'),

    spawner.key({ mod, 'Shift' }, 'c', {
      app = spawner.terminal('nvim', { class = 'config', directory = dotfiles }),
      props = { class = 'config' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod, 'Shift' }, 'e', {
      app = spawner.terminal(string.format('nvim %s/.scratchpad.norg', home), { class = 'scratchpad' }),
      props = { class = 'scratchpad' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ mod, 'Shift' }, 'i', {
      app = function()
        return spawner.terminal(
          string.format('nvim %s/index.norg', require('context').get()),
          { class = 'wiki', directory = neorg }
        )
      end,
      props = { class = 'wiki' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ mod, 'Shift' }, 'a', {
      app = function()
        return spawner.terminal(
          spawner.shell('ft edit'),
          { class = 'accounting', directory = accounting }
        )
      end,
      props = { class = 'accounting' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod }, '.', {
      app = spawner.terminal('nvim gtd/index.norg', { class = 'gtd', directory = neorg }),
      props = { class = 'gtd' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ mod }, '$', {
      app = spawner.terminal(nil, { class = 'quake' }),
      props = { class = 'quake' },
      signal = spawner.actions.MOVE,
    }),

    spawner.key({ mod }, 'Tab', awful.tag.history.restore),
    spawner.key({ mod, 'Shift' }, 'Tab', 'rofi-keyboard'),
    spawner.key({ mod, 'Control' }, 'Tab', 'rofi-monitors'),
    spawner.key({}, 'F12', 'rofi-wifi'),
    spawner.key({ mod }, 'k', 'rofi-emojis'),
    spawner.key({ mod }, 'f', 'rofi-nerdfont'),
    spawner.key({ mod }, 'à', 'rofi-bluetooth'),
    spawner.key({ mod }, 'y', 'pulseaudio-ctl mute-input'),
    spawner.key({ mod }, 'Escape', 'rofi-pass'),
    spawner.key({ mod }, ',', 'rofi-search'),
    spawner.key({ 'Control' }, ' ', 'gtd-inbox'),

    spawner.key({ mod }, 'q', 'rofi-power'),
    spawner.key({ mod }, 'a', {
      app = spawner.terminal('pulsemixer', { class = 'mixer' }),
      props = { class = 'mixer' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ mod }, 'm', 'mpc-library'),
    spawner.key({ mod }, 'b', 'mpc-playlist'),
    spawner.key({ mod, 'Shift' }, 'm', {
      app = 'music',
      props = { instance = 'music.youtube.com' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ mod }, 'BackSpace', 'mpc toggle'),
    spawner.key({ mod }, 'u', spawner.terminal('vifm', { class = 'vifm' })),
    spawner.key({ mod, 'Shift' }, 'u', 'nemo'),
    spawner.key({ mod }, 'g', 'wallpaper'),
    spawner.key({ mod }, 'h', {
      app = spawner.terminal('gtgf', { class = 'gtgf' }),
      props = { class = 'gtgf' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ mod }, 'percent', spawner.terminal('ytdl', { directory = sandbox, class = 'download' })),
    spawner.key({ mod }, 'equal', spawner.shell('open (xsel --clipboard -o)')),
    spawner.key({ mod }, "'", spawner.terminal()),
    spawner.key({ mod, 'Shift' }, "'", spawner.terminal(nil, { class = 'kitty-light' })),
    spawner.key({ mod }, 'p', 'screenshot.sh')
  )
}

-- [[ Mouse ]] =================================================================

_M.mouse = {
  clients = gears.table.join(
    spawner.button({}, 1, function(client)
      client:emit_signal('request::activate', 'mouse_click', { raise = true })
    end),
    spawner.button({ mod }, 1, function(client)
      client:emit_signal('request::activate', 'mouse_click', { raise = true })
      awful.mouse.client.move(client)
    end),
    spawner.button({ mod }, 4, function(_)
      spawner.grab_mouse_until_released()
      awful.tag.viewnext()
    end),
    spawner.button({ mod }, 5, function(_)
      spawner.grab_mouse_until_released()
      awful.tag.viewprev()
    end)
  ),

  root = gears.table.join(
    spawner.button({ mod }, 4, awful.tag.viewnext),
    spawner.button({ mod }, 5, awful.tag.viewprev)
  )
}

_M.config = function()
  -- root
  root.keys(_M.keyboard.root)
  root.buttons(_M.mouse.root)

  -- clients
  awful.rules.rules = gears.table.join(awful.rules.rules, {
    {
      rule = {},
      properties = {
        keys = _M.keyboard.clients,
        buttons = _M.mouse.clients,
      }
    }
  })
end

return _M
