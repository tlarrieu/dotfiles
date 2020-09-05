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

local script = function(path)
  return "sh " .. os.getenv("HOME") .. "/scripts/" .. path
end

local fish = function(command)
  return "fish -c '" .. command .. "'"
end

local spawn_or_raise = function(mods, k, cmd, props)
  return spawner.key(
    mods,
    k,
    function() spawner.spawn_or_move_client(cmd, props) end
  )
end

local spawn_or_jump = function(mods, k, cmd, props)
  return spawner.key(
    mods,
    k,
    function() spawner.spawn_or_jump(cmd, props) end
  )
end

local termstart = function(cmd, opts)
  local options = ""
  if opts then
    for name, value in pairs(opts) do
      options = string.format("%s --%s %s", options, name, value)
    end
  end

  return fish(string.format(
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

local scratchpad = function(mods, k)
  local props = { class = "scratchpad" }
  return spawn_or_raise(
    mods,
    k,
    termstart("nvim ~/.scratchpad.md", props),
    props
  )
end

local wiki = function(mods, k)
  local props = { class = "wiki" }
  return spawn_or_raise(mods, k, fish("vimwiki"), props)
end

local config = function(mods, k)
  local props = { class = "config" }
  return spawn_or_jump(
    mods,
    k,
    termstart("nvim nvim/init.vim", { class = "config", directory = dotfiles }),
    props
  )
end

local quake = function(mods, k)
  local props = { class = "quake" }
  return spawn_or_raise(mods, k, termstart("", props), props)
end

-- [[ Keyboard ]] ==============================================================

_M.keyboard = {
  clients = gears.table.join(
    spawner.key({ mod }, "Return", function(c) c.fullscreen = not c.fullscreen end),
    spawner.key({ mod }, "eacute", function(c) c:kill() end),

    spawner.key({mod, "Control"}, "c", function(c)
      awful.tag.viewprev()
      c:move_to_tag(c.screen.selected_tag)
    end),

    spawner.key({ mod, "Control" }, "r", function(c)
      awful.tag.viewnext()
      c:move_to_tag(c.screen.selected_tag)
    end),

    spawner.key({ mod }, "n", helpers.create_tag_and_attach_to),

    spawner.key({ mod }, "o", function(client)
      client:move_to_screen()
      helpers.create_tag_and_attach_to(client)

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

    spawner.key({ mod }, "l",              script('rofi-layouts')),

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

    -- [[ Applications ]] ------------------------------------------------------

    spawner.key({ mod }, " ",              fish("rofi -show run -lines 6")),
    spawner.key({ "Control" }, " ",        script("gtd-inbox")),

    config({ mod, "Shift" }, "c"),
    scratchpad({ mod, "Shift" }, "e"),
    wiki({ mod, "Shift" }, "i"),
    quake({ mod }, "$"),

    spawner.key({ mod }, "Tab",            script("rofi-window")),
    spawner.key({mod, "Control"}, "Tab",   script("rofi-monitors")),
    spawner.key({}, "F12",                 script("rofi-wifi")),
    spawner.key({ mod }, "F2",             script("rofi-keyboard")),
    spawner.key({ mod }, "k",              script("rofi-emojis")),
    spawner.key({ mod }, "f",              script("rofi-nerdfont")),
    spawner.key({ mod }, "à",              script("rofi-bluetooth")),
    spawner.key({ mod }, "Escape",         script("rofi-pass")),
    spawner.key({ mod }, ".",              fish("rofi-search")),

    spawner.key({ mod }, "q",              script("rofi-power")),
    spawner.key({ mod }, "a",              termstart("pulsemixer", { class = "mixer" })),

    spawner.key({ mod }, "m",              script("mpc-library")),
    spawner.key({ mod }, "b",              script("mpc-playlist")),
    spawner.key({ mod }, "BackSpace",      "mpc toggle"),

    spawner.key({ mod }, ",",              fish("browser-with-context")),
    spawner.key({ mod }, "u",              termstart("vifm")),
    spawner.key({ mod, "Shift"}, "u",      "thunar"),
    spawner.key({ mod }, "g",              script("wallpaper")),
    spawner.key({ mod }, "h",              termstart(script("gtgf"), { class = "gtgf" })),
    spawner.key({}, "F1",                  termstart("bhoogle", { class = "help" })),

    spawner.key({ mod, "Shift" }, "b",     termstart("", { directory = sandbox })),
    spawner.key({ mod }, "percent",        termstart(
      script("ytdl"),
      { directory = sandbox, class = "download" }
    )),
    spawner.key({ mod }, "equal",          fish("open (xsel --clipboard -o)")),

    spawner.key({ mod }, "'",              termstart("")),
    spawner.key({ mod, "Shift" }, "'",     termstart("", { class = "kitty-light" })),

    spawner.key({ mod }, "p",              script("screenshot.sh"))
  )
}

-- [[ Mouse ]] =================================================================

_M.mouse = {
  clients = gears.table.join(
    awful.button({}, 1, function(client)
      client:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({mod}, 1, function (client)
        client:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(client)
    end),
    awful.button({mod}, 4, function(_) awful.tag.viewnext() end),
    awful.button({mod}, 5, function(_) awful.tag.viewprev() end)
  ),

  root = gears.table.join(
    awful.button({mod}, 4, awful.tag.viewnext),
    awful.button({mod}, 5, awful.tag.viewprev)
  )
}

return _M

-- vim: textwidth=100
