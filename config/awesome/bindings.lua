--| HELP |----------------------------------------------------------------------
-- To get “weird” keys name, use xev -event keyboard
-- (it comes in the xorg-xev package)
--------------------------------------------------------------------------------

local _M = {
  keyboard = {},
  mouse = {}
}

-- [[ Variables ]] -------------------------------------------------------------

local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")

local spawner = require("spawner")

local dotfiles = string.format("%s/git/dotfiles", os.getenv("HOME"))
local sandbox = string.format("%s/sandbox", os.getenv("HOME"))
local mod = "Mod4"

local shell = function(command)
  return "fish -c '" .. command .. "'"
end

local termstart = function(cmd, opts)
  local options = ""
  if opts then
    for name, value in pairs(opts) do
      options = string.format("%s --%s %s", options, name, value)
    end
  end

  return shell(string.format(
    "kitty --single-instance %s %s",
    options,
    cmd
  ))
end

local increment = 0.01

local view_tag = function(id) awful.screen.focused().tags[id]:view_only() end

local focus_client = function(direction)
  awful.client.focus.byidx(direction)
  if client.focus then client.focus:raise() end
end

-- [[ Keyboard ]] ==============================================================

_M.keyboard = {
  clients = gears.table.join(
    spawner.key({ mod }, "Return", function(c) c.fullscreen = not c.fullscreen end),
    spawner.key({ mod }, "eacute", function(c)
      if c.immortal then
        c:tags({}) -- hide client instead of killing it
      else
        c:kill()
      end
    end),

    spawner.key({mod, "Control"}, "c", function(c)
      awful.tag.viewprev()
      c:move_to_tag(c.screen.selected_tag)
    end),

    spawner.key({ mod, "Control" }, "r", function(c)
      awful.tag.viewnext()
      c:move_to_tag(c.screen.selected_tag)
    end),

    spawner.key({ mod }, "n", function(client) helpers.create_tag_and_attach_to(client, true) end),

    spawner.key({ mod }, "o", function(client)
      client:move_to_screen()
      helpers.create_tag_and_attach_to(client, true)

      -- This is a **dirty** trick to counteract Awesome's fallback mechanism
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
        timeout   = 0.2,
        single_shot = true,
        autostart = true,
        callback  = function()
          awful.tag.viewprev()
          awful.tag.viewnext()
        end
      }
    end),

    spawner.key({ mod, "Control" }, "o", function(client)
      for _, c in ipairs(client.first_tag:clients()) do
        if client ~= c then c:kill() end
      end
    end)
  ),

  root = gears.table.join(
    -- [[ Window Manager ]] ----------------------------------------------------

    spawner.key({ mod }, "l",              shell('rofi-layouts')),

    spawner.key({ mod }, "c",              awful.tag.viewprev),
    spawner.key({ mod }, "Left",           awful.tag.viewprev),
    spawner.key({ mod }, "r",              awful.tag.viewnext),
    spawner.key({ mod }, "Right",          awful.tag.viewnext),

    spawner.key({ mod }, "\"",             function() view_tag(1) end),
    spawner.key({ mod }, "guillemotleft",  function() view_tag(2) end),
    spawner.key({ mod }, "guillemotright", function() view_tag(3) end),
    spawner.key({ mod }, "(",              function() view_tag(4) end),
    spawner.key({ mod }, ")",              function() view_tag(5) end),
    spawner.key({ mod }, "@",              function() view_tag(6) end),

    spawner.key({mod, "Control"}, "t",     function() awful.client.swap.byidx(1) end),
    spawner.key({mod, "Control"}, "s",     function() awful.client.swap.byidx(-1) end),

    spawner.key({ mod }, "d",              function() awful.tag.incmwfact(increment) end),
    spawner.key({ mod }, "v",              function() awful.tag.incmwfact(-increment) end),
    spawner.key({mod, "Shift"}, "d",       function() awful.client.incwfact(increment) end),
    spawner.key({mod, "Shift"}, "v",       function() awful.client.incwfact(-increment) end),

    spawner.key({ mod }, "t",              function() focus_client(1) end),
    spawner.key({ mod }, "Down",           function() focus_client(1) end),
    spawner.key({ mod }, "s",              function() focus_client(-1) end),
    spawner.key({ mod }, "Up",             function() focus_client(-1) end),

    spawner.key({ mod }, "i",              function() awful.screen.focus_relative(1) end),
    spawner.key({ mod }, "e",              function() awful.screen.focus_relative(-1) end),

    spawner.key({mod, "Shift"}, "r",       awesome.restart),

    -- [[ Context ]] -----------------------------------------------------------

    spawner.key({mod, "Shift"}, "t",         shell("cont")),

    -- [[ Applications ]] ------------------------------------------------------

    spawner.key({ mod }, " ",                shell("rofi -show run -lines 6")),

    spawner.key({ mod, "Shift" }, "c", {
      app = termstart("nvim nvim/init.lua", { class = "config", directory = dotfiles }),
      props = { class = "config" },
      callback = spawner.callbacks.jump_to_client
    }),
    spawner.key({ mod, "Shift" }, "e", {
      app = termstart("nvim ~/.scratchpad.md", { class = "scratchpad" }),
      props = { class = "scratchpad" },
      callback = spawner.callbacks.move_client
    }),
    spawner.key({ mod, "Shift" }, "i", {
      app = shell("notes"),
      props = { class = "wiki" },
      callback = spawner.callbacks.move_client
    }),
    spawner.key({ mod }, ".", {
      app = shell("gtd"),
      props = { class = "gtd" },
      callback = spawner.callbacks.move_client
    }),
    spawner.key({ mod }, "$", {
      app = termstart("", { class = "quake" }),
      props = { class = "quake" },
      callback = spawner.callbacks.move_client
    }),
    -- Open last downloaded video
    spawner.key({ mod, "Shift" }, "o",     shell("cd ~/sandbox; open (ls -1tc | head -n 1)")),

    spawner.key({ mod }, "Tab",            function() require('rofi-windows')() end),
    spawner.key({mod, "Control"}, "Tab",   shell("rofi-monitors")),
    spawner.key({}, "F12",                 shell("rofi-wifi")),
    spawner.key({ mod }, "F2",             shell("rofi-keyboard")),
    spawner.key({ mod }, "k",              shell("rofi-emojis")),
    spawner.key({ mod }, "f",              shell("rofi-nerdfont")),
    spawner.key({ mod }, "à",              shell("rofi-bluetooth")),
    spawner.key({ mod }, "y",              shell("pulseaudio-ctl mute-input")),
    spawner.key({ mod }, "Escape",         shell("rofi-pass")),
    spawner.key({ mod }, ",",              shell("rofi-search")),

    spawner.key({ mod }, "q",              shell("rofi-power")),
    spawner.key({ mod }, "a",              termstart("pulsemixer", { class = "mixer" })),

    spawner.key({ mod }, "m",              shell("mpc-library")),
    spawner.key({ mod, "Shift"}, "m",      shell("toggle-dim-mpd.sh")),
    spawner.key({ mod }, "b",              shell("mpc-playlist")),
    spawner.key({ mod }, "BackSpace",      "mpc toggle"),

    spawner.key({ mod }, "u",              termstart("vifm")),
    spawner.key({ mod, "Shift"}, "u",      "thunar"),
    spawner.key({ mod }, "g",              shell("wallpaper")),
    spawner.key({ mod }, "h",              termstart(shell("gtgf"), { class = "gtgf" })),

    spawner.key({ mod, "Shift" }, "b",     termstart("", { directory = sandbox })),
    spawner.key({ mod }, "percent",        termstart(
      shell("ytdl"),
      { directory = sandbox, class = "download" }
    )),
    spawner.key({ mod }, "equal",          shell("open (xsel --clipboard -o)")),

    spawner.key({ mod }, "'",              termstart("")),
    spawner.key({ mod, "Shift" }, "'",     termstart("", { class = "kitty-light" })),

    spawner.key({ mod }, "p",              shell("screenshot.sh"))
  )
}

-- [[ Mouse ]] =================================================================

_M.mouse = {
  clients = gears.table.join(
    spawner.button({}, 1, function(client)
      client:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    spawner.button({mod}, 1, function (client)
        client:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(client)
    end),
    spawner.button({mod}, 4, function(_)
      spawner.grab_mouse_until_released()
      awful.tag.viewnext()
    end),
    spawner.button({mod}, 5, function(_)
      spawner.grab_mouse_until_released()
      awful.tag.viewprev()
    end)
  ),

  root = gears.table.join(
    spawner.button({mod}, 4, awful.tag.viewnext),
    spawner.button({mod}, 5, awful.tag.viewprev)
  )
}

return _M

-- vim: textwidth=100
