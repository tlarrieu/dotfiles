local awful = require('awful')
local helpers = require('helpers')
local gears = require('gears')

local spawner = require('spawner')

local home = os.getenv('HOME')
local dotfiles = string.format('%s/git/dotfiles', home)
local work = string.format('%s/dev/jeancaisse', home)
local accounting = string.format('%s/git/accounting', home)
local neorg = string.format('%s/.neorg', home)

local mod = 'Mod4'

local increment = 0.01

local view_tag = function(id) awful.screen.focused().tags[id]:view_only() end

local focus_client = function(direction)
  awful.client.focus.byidx(direction)
  if client.focus then client.focus:raise() end
end

local move_to_screen = function(client, screen)
  client:move_to_screen(screen)
  helpers.create_tag_and_attach_to(client, true)
end

-- [[ Keyboard ]] ==============================================================

local keyboard = {
  clients = gears.table.join(
    spawner.key({ mod }, 'Return', function(c) c.fullscreen = not c.fullscreen end),
    spawner.key({ mod }, 'eacute', spawner.soft_kill),
    spawner.key({ mod, 'Shift' }, 'eacute', function(c) c:kill() end),
    spawner.key({ mod, 'Control' }, 'm', function(c) awful.client.setmaster(c) end),
    spawner.key({ mod, 'Control' }, 'c', function(c)
      awful.tag.viewprev()
      c:move_to_tag(c.screen.selected_tag)
    end),
    spawner.key({ mod, 'Control' }, 'r', function(c)
      awful.tag.viewnext()
      c:move_to_tag(c.screen.selected_tag)
    end),
    spawner.key({ mod }, 'n', function(client) helpers.create_tag_and_attach_to(client, true) end),
    spawner.key({ mod, 'Control' }, 'e', function(client) move_to_screen(client, 1) end),
    spawner.key({ mod, 'Control' }, 'i', function(client) move_to_screen(client, 2) end),
    spawner.key({ mod, 'Control' }, 'u', function(client) move_to_screen(client, 3) end)
  ),

  root = gears.table.join(
    spawner.key({ mod }, 'Tab', awful.tag.history.restore),
    spawner.key({ mod }, 'c', awful.tag.viewprev),
    spawner.key({ mod }, 'r', awful.tag.viewnext),

    spawner.key({ mod }, '"', function() view_tag(1) end),
    spawner.key({ mod }, 'guillemotleft', function() view_tag(2) end),
    spawner.key({ mod }, 'guillemotright', function() view_tag(3) end),
    spawner.key({ mod }, '(', function() view_tag(4) end),
    spawner.key({ mod }, ')', function() view_tag(5) end),
    spawner.key({ mod }, '@', function() view_tag(6) end),
    spawner.key({ mod }, '+', function() view_tag(7) end),
    spawner.key({ mod }, '-', function() view_tag(8) end),
    spawner.key({ mod }, '/', function() view_tag(9) end),
    spawner.key({ mod }, '*', function() view_tag(10) end),
    spawner.key({ mod }, 't', function() focus_client(1) end),
    spawner.key({ mod, 'Control' }, 't', function() awful.client.swap.byidx(1) end),
    spawner.key({ mod }, 's', function() focus_client(-1) end),
    spawner.key({ mod, 'Control' }, 's', function() awful.client.swap.byidx(-1) end),
    spawner.key({ mod }, 'd', function() awful.tag.incmwfact(increment) end),
    spawner.key({ mod }, 'v', function() awful.tag.incmwfact(-increment) end),
    spawner.key({ mod }, 'e', function() awful.screen.focus(1) end),
    spawner.key({ mod }, 'i', function() awful.screen.focus(2) end),
    spawner.key({ mod }, 'u', function() awful.screen.focus(3) end),
    spawner.key({ mod, 'Shift' }, 'r', awesome.restart),

    -- [[ Togglers ]] ----------------------------------------------------------

    spawner.key({ mod, 'Shift' }, 't', require('context').toggle),
    spawner.key({ mod, 'Shift' }, 'b', 'toggle-light-and-dark.sh'),

    -- [[ Applications ]] ------------------------------------------------------

    spawner.key({ mod }, '.', {
      app = spawner.terminal('nvim', { class = 'config', directory = dotfiles }),
      props = { class = 'config' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod }, 'w', {
      app = spawner.shell('work'),
      props = { name = 'rails server' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod, 'Shift' }, 'w', spawner.shell('work restart')),
    spawner.key({ mod }, 'x', {
      app = spawner.terminal('nvim', { class = 'work', directory = work }),
      props = { class = 'work' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod, 'Shift' }, 'x', {
      app = spawner.terminal('opencode', { class = 'opencode', directory = work }),
      props = { class = 'opencode' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod }, 'g', {
      app = spawner.shell('github'),
      props = { instance = 'www.github.com' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod, 'Shift' }, 's', {
      app = spawner.shell('slack'),
      props = { instance = 'app.slack.com' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod, 'Shift' }, 'l', {
      app = spawner.shell('linear'),
      props = { instance = 'linear.app' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod, 'Shift' }, 'c', {
      app = spawner.shell('calendar'),
      props = { instance = 'calendar.google.com' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod }, 'è', {
      app = spawner.terminal(string.format('nvim %s/postgres.sql', home), { class = 'postgres' }),
      props = { class = 'postgres' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ mod }, ',', {
      app = spawner.terminal(string.format('nvim %s/.scratchpad.md', home), { class = 'scratchpad' }),
      props = { class = 'scratchpad' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ mod }, 'y', {
      app = spawner.shell('excalidraw'),
      props = { instance = 'www.excalidraw.com' },
      signal = spawner.actions.JUMP,
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
      app = spawner.terminal('ft edit', { class = 'accounting', directory = accounting }),
      props = { class = 'accounting' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ mod, 'Shift' }, '.', {
      app = spawner.terminal('newsboat', { class = 'newsboat' }),
      props = { class = 'newsboat' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ mod }, '$', {
      app = spawner.terminal(nil, { class = 'quake' }),
      props = { class = 'quake' },
      signal = spawner.actions.MOVE,
    }),

    spawner.key({ mod }, 'l', 'rofi-layouts'),
    spawner.key({ mod }, ' ', spawner.shell('~/scripts/rofi-main')),
    spawner.key({ mod, 'Shift' }, ' ', 'rofi-search'),
    spawner.key({ mod, 'Shift' }, 'Tab', 'rofi-keyboard'),
    spawner.key({ mod, 'Control' }, 'Tab', 'rofi-monitors'),
    spawner.key({}, 'F12', 'rofi-wifi'),
    spawner.key({ mod }, 'k', 'rofi-emojis'),
    spawner.key({ mod }, 'f', 'rofi-nerdfont'),
    spawner.key({ mod }, 'à', 'rofi-bluetooth'),
    spawner.key({ mod }, 'y', 'pulseaudio-ctl mute-input'),
    spawner.key({ mod }, 'Escape', 'rofi-pass'),
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
    spawner.key({}, 'XF86AudioPause', 'mpc toggle'),
    spawner.key({}, 'XF86AudioPlay', 'mpc toggle'),
    spawner.key({}, 'XF86AudioNext', 'mpc next'),
    spawner.key({}, 'XF86AudioPrev', 'mpc prev'),
    spawner.key({ mod }, 'BackSpace', 'mpc toggle'),
    spawner.key({ mod }, 'o', spawner.terminal('vifm', { class = 'vifm' })),
    spawner.key({ mod, 'Shift' }, 'o', 'nemo'),
    spawner.key({ mod, 'Shift' }, 'g', 'wallpaper'),
    spawner.key({ mod }, 'h', {
      app = spawner.terminal('gtgf', { class = 'gtgf' }),
      props = { class = 'gtgf' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ mod }, 'percent', spawner.terminal('ytdl', { class = 'download' })),
    spawner.key({ mod }, 'ccedilla', spawner.shell('open (xsel --clipboard -o)')),
    spawner.key({ mod }, "'", spawner.terminal()),
    spawner.key({ mod, 'Shift' }, "'", spawner.terminal(nil, { class = 'kitty-light' })),
    spawner.key({ mod }, 'p', 'screenshot.sh')
  )
}

-- [[ Mouse ]] =================================================================

local mouse = {
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

return {
  config = function()
    root.keys(keyboard.root)
    root.buttons(mouse.root)

    awful.rules.rules = gears.table.join(awful.rules.rules, {
      {
        rule = {},
        properties = {
          keys = keyboard.clients,
          buttons = mouse.clients,
        }
      }
    })
  end
}
