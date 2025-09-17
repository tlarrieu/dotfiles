local awful = require('awful')
local helpers = require('helpers')
local gears = require('gears')

local spawner = require('spawner')

local home = os.getenv('HOME')
local dotfiles = string.format('%s/git/dotfiles', home)
local work = string.format('%s/dev/jeancaisse', home)
local accounting = string.format('%s/git/accounting', home)
local neorg = string.format('%s/.neorg', home)

local super = 'Mod4'
local alt = 'Mod1'
local ctrl = 'Control'
local shift = 'Shift'

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
    spawner.key({ super }, 'Return', function(c) c.fullscreen = not c.fullscreen end),
    spawner.key({ super }, 'eacute', spawner.soft_kill),
    spawner.key({ super, shift }, 'eacute', function(c) c:kill() end),
    spawner.key({ super, ctrl }, 'm', function(c) awful.client.setmaster(c) end),
    spawner.key({ super, ctrl }, 'c', function(c)
      awful.tag.viewprev()
      c:move_to_tag(c.screen.selected_tag)
    end),
    spawner.key({ super, ctrl }, 'r', function(c)
      awful.tag.viewnext()
      c:move_to_tag(c.screen.selected_tag)
    end),
    spawner.key({ super }, 'n', function(client) helpers.create_tag_and_attach_to(client, true) end),
    spawner.key({ super, ctrl }, 'e', function(client) move_to_screen(client, 1) end),
    spawner.key({ super, ctrl }, 'i', function(client) move_to_screen(client, 2) end),
    spawner.key({ super, ctrl }, 'u', function(client) move_to_screen(client, 3) end)
  ),

  root = gears.table.join(
    spawner.key({ super }, 'Tab', awful.tag.history.restore),
    spawner.key({ super }, 'c', awful.tag.viewprev),
    spawner.key({ super }, 'r', awful.tag.viewnext),

    spawner.key({ super }, '"', function() view_tag(1) end),
    spawner.key({ super }, 'guillemotleft', function() view_tag(2) end),
    spawner.key({ super }, 'guillemotright', function() view_tag(3) end),
    spawner.key({ super }, '(', function() view_tag(4) end),
    spawner.key({ super }, ')', function() view_tag(5) end),
    spawner.key({ super }, '@', function() view_tag(6) end),
    spawner.key({ super }, '+', function() view_tag(7) end),
    spawner.key({ super }, '-', function() view_tag(8) end),
    spawner.key({ super }, '/', function() view_tag(9) end),
    spawner.key({ super }, '*', function() view_tag(10) end),
    spawner.key({ super }, 't', function() focus_client(1) end),
    spawner.key({ super, ctrl }, 't', function() awful.client.swap.byidx(1) end),
    spawner.key({ super }, 's', function() focus_client(-1) end),
    spawner.key({ super, ctrl }, 's', function() awful.client.swap.byidx(-1) end),
    spawner.key({ super }, 'd', function() awful.tag.incmwfact(increment) end),
    spawner.key({ super }, 'v', function() awful.tag.incmwfact(-increment) end),
    spawner.key({ super }, 'e', function() awful.screen.focus(1) end),
    spawner.key({ super }, 'i', function() awful.screen.focus(2) end),
    spawner.key({ super }, 'u', function() awful.screen.focus(3) end),
    spawner.key({ super, shift }, 'r', awesome.restart),

    -- [[ Togglers ]] ----------------------------------------------------------

    spawner.key({ super, shift }, 't', require('context').toggle),
    spawner.key({ super, shift }, 'Return', 'toggle-light-and-dark.sh'),

    -- [[ Applications ]] ------------------------------------------------------

    spawner.key({ super }, '.', {
      app = spawner.terminal('nvim', { class = 'config', directory = dotfiles }),
      props = { class = 'config' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super }, 'w', {
      app = spawner.shell('work'),
      props = { name = 'rails server' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super, shift }, 'w', spawner.shell('work restart')),
    spawner.key({ super }, 'x', {
      app = spawner.terminal('nvim', { class = 'work', directory = work }),
      props = { class = 'work' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super, shift }, 'x', {
      app = spawner.terminal('opencode', { class = 'opencode', directory = work }),
      props = { class = 'opencode' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super }, 'g', {
      app = spawner.shell('github'),
      props = { instance = 'www.github.com' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super, shift }, 'g', {
      app = spawner.shell('code-review'),
      props = { instance = 'github.com__pulls' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super, shift }, 's', {
      app = spawner.shell('slack'),
      props = { instance = 'app.slack.com' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super, shift }, 'd', {
      app = spawner.shell('documentation'),
      props = { instance = 'documentation' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super, shift }, 'l', {
      app = spawner.shell('linear'),
      props = { instance = 'linear.app' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super, shift }, 'c', {
      app = spawner.shell('calendar'),
      props = { instance = 'calendar.google.com' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super }, 'a', {
      app = spawner.shell('gmail'),
      props = { instance = 'www.gmail.com' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super }, 'è', {
      app = spawner.terminal(string.format('nvim %s/postgres.sql', home), { class = 'postgres' }),
      props = { class = 'postgres' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ super }, ',', {
      app = spawner.terminal(string.format('nvim %s/.scratchpad.md', home), { class = 'scratchpad' }),
      props = { class = 'scratchpad' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ super, shift }, ',', {
      app = spawner.shell('excalidraw'),
      props = { instance = 'www.excalidraw.com' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super, shift }, 'e', {
      app = spawner.shell('metabase'),
      props = { instance = 'metabase' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super, shift }, 'i', {
      app = function()
        return spawner.terminal(
          string.format('nvim %s/index.norg', require('context').get()),
          { class = 'wiki', directory = neorg }
        )
      end,
      props = { class = 'wiki' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ super, shift }, 'a', {
      app = spawner.terminal('ft edit', { class = 'accounting', directory = accounting }),
      props = { class = 'accounting' },
      signal = spawner.actions.JUMP,
    }),
    spawner.key({ super, shift }, '.', {
      app = spawner.terminal('newsboat', { class = 'newsboat' }),
      props = { class = 'newsboat' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ super }, '$', {
      app = spawner.terminal(nil, { class = 'quake' }),
      props = { class = 'quake' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ super, shift }, 'h', {
      app = spawner.terminal('htop', { class = 'htop' }),
      props = { class = 'htop' },
      signal = spawner.actions.MOVE,
    }),

    spawner.key({ super }, 'l', 'rofi-layouts'),
    spawner.key({ super }, ' ', spawner.shell('~/scripts/rofi-main')),
    spawner.key({ alt }, ' ', 'rofi-search'),
    spawner.key({ super, shift }, 'Tab', 'rofi-keyboard'),
    spawner.key({ super, ctrl }, 'Tab', 'rofi-monitors'),
    spawner.key({}, 'F12', 'rofi-wifi'),
    spawner.key({ super }, 'k', 'rofi-emojis'),
    spawner.key({ super }, 'f', 'rofi-nerdfont'),
    spawner.key({ super }, 'à', 'rofi-bluetooth'),
    spawner.key({ super }, 'y', 'pulseaudio-ctl mute-input'),
    spawner.key({ super }, 'Escape', 'rofi-pass'),
    spawner.key({ super }, 'q', 'rofi-power'),

    spawner.key({ super, shift }, 'u', {
      app = spawner.terminal('pulsemixer', { class = 'mixer' }),
      props = { class = 'mixer' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ super }, 'b', 'mpc-library'),
    spawner.key({ super, shift }, 'b', 'mpc-playlist'),
    spawner.key({ super }, 'm', {
      app = 'music',
      props = { instance = 'music.youtube.com' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ super }, 'y', {
      app = 'youtube',
      props = { instance = 'www.youtube.com' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({}, 'XF86AudioPause', 'mpc toggle'),
    spawner.key({}, 'XF86AudioPlay', 'mpc toggle'),
    spawner.key({}, 'XF86AudioNext', 'mpc next'),
    spawner.key({}, 'XF86AudioPrev', 'mpc prev'),
    spawner.key({ super }, 'BackSpace', 'mpc toggle'),
    spawner.key({ super }, 'o', spawner.terminal('vifm', { class = 'vifm' })),
    spawner.key({ super, shift }, 'o', 'nemo'),
    spawner.key({ super, shift }, 'q', 'wallpaper'),
    spawner.key({ super }, 'h', {
      app = spawner.terminal('gtgf', { class = 'gtgf' }),
      props = { class = 'gtgf' },
      signal = spawner.actions.MOVE,
    }),
    spawner.key({ super }, 'percent', spawner.terminal('ytdl', { class = 'download' })),
    spawner.key({ super }, 'ccedilla', spawner.shell('open (xsel --clipboard -o)')),
    spawner.key({ super }, "'", spawner.terminal()),
    spawner.key({ super, shift }, "'", spawner.terminal(nil, { class = 'kitty-light' })),
    spawner.key({ super }, 'p', 'screenshot.sh')
  )
}

-- [[ Mouse ]] =================================================================

local mouse = {
  clients = gears.table.join(
    spawner.button({}, 1, function(client)
      client:emit_signal('request::activate', 'mouse_click', { raise = true })
    end),
    spawner.button({ super }, 1, function(client)
      client:emit_signal('request::activate', 'mouse_click', { raise = true })
      awful.mouse.client.move(client)
    end),
    spawner.button({ super }, 4, function(_)
      spawner.grab_mouse_until_released()
      awful.tag.viewnext()
    end),
    spawner.button({ super }, 5, function(_)
      spawner.grab_mouse_until_released()
      awful.tag.viewprev()
    end)
  ),

  root = gears.table.join(
    spawner.button({ super }, 4, awful.tag.viewnext),
    spawner.button({ super }, 5, awful.tag.viewprev)
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
