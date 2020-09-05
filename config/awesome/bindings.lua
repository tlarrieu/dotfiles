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

local key = awful.key
local mkey = function(k, f) return key({mod}, k, f) end

local spawn = function(mods, k, cmd, props)
  return key(mods, k, function() spawner.spawn(cmd, props) end)
end

local script = function(path)
  return "sh " .. os.getenv("HOME") .. "/scripts/" .. path
end

local fish = function(command)
  return "fish -c '" .. command .. "'"
end

local spawn_or_raise = function(mods, k, cmd, props)
  return key(
    mods,
    k,
    function() spawner.spawn_or_move_client(cmd, props) end
  )
end

local spawn_or_jump = function(mods, k, cmd, props)
  return key(
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
    mkey("Return", function(c) c.fullscreen = not c.fullscreen end),
    mkey("eacute", function(c) c:kill() end),

    key({mod, "Control"}, "c", function(c)
      awful.tag.viewprev()
      c:move_to_tag(c.screen.selected_tag)
    end),

    key({ mod, "Control" }, "r", function(c)
      awful.tag.viewnext()
      c:move_to_tag(c.screen.selected_tag)
    end),

    mkey("n", helpers.create_tag_and_attach_to),

    mkey("o", function(client)
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

    key({ mod, "Control" }, "o", function(client)
      for _, c in ipairs(client.first_tag:clients()) do
        if client ~= c then c:kill() end
      end
    end)
  ),

  root = gears.table.join(
    -- [[ Window Manager ]] ----------------------------------------------------

    spawn({ mod }, "l", script('rofi-layouts')),

    mkey("c",     awful.tag.viewprev),
    mkey("Left",  awful.tag.viewprev),
    mkey("r",     awful.tag.viewnext),
    mkey("Right", awful.tag.viewnext),

    mkey("\"",             function() view_tag(1) end),
    mkey("guillemotleft",  function() view_tag(2) end),
    mkey("guillemotright", function() view_tag(3) end),
    mkey("(",              function() view_tag(4) end),
    mkey(")",              function() view_tag(5) end),
    mkey("@",              function() view_tag(6) end),

    key({mod, "Control"}, "t", function() awful.client.swap.byidx(1) end),
    key({mod, "Control"}, "s", function() awful.client.swap.byidx(-1) end),

    mkey("d",          function() awful.tag.incmwfact(increment) end),
    mkey("v",          function() awful.tag.incmwfact(-increment) end),
    key({mod, "Shift"}, "d", function() awful.client.incwfact(increment) end),
    key({mod, "Shift"}, "v", function() awful.client.incwfact(-increment) end),

    mkey("t",    function() focus_client(1) end),
    mkey("Down", function() focus_client(1) end),
    mkey("s",    function() focus_client(-1) end),
    mkey("Up",   function() focus_client(-1) end),

    mkey("i", function() awful.screen.focus_relative(1) end),
    mkey("e", function() awful.screen.focus_relative(-1) end),

    key({mod, "Shift"}, "r", awesome.restart),

    -- [[ Applications ]] ------------------------------------------------------

    spawn({ mod }, " ",            fish("rofi -show run -lines 6")),
    spawn({ "Control" }, " ",      script("gtd-inbox")),

    config({ mod, "Shift" }, "c"),
    scratchpad({ mod, "Shift" }, "e"),
    wiki({ mod, "Shift" }, "i"),
    quake({ mod }, "$"),

    spawn({ mod }, "Tab",          script("rofi-window")),
    spawn({mod, "Control"}, "Tab", script("rofi-monitors")),
    spawn({}, "F12",               script("rofi-wifi")),
    spawn({ mod }, "F2",           script("rofi-keyboard")),
    spawn({ mod }, "k",            script("rofi-emojis")),
    spawn({ mod }, "f",            script("rofi-nerdfont")),
    spawn({ mod }, "à",            script("rofi-bluetooth")),
    spawn({ mod }, "Escape",       script("rofi-pass")),
    spawn({ mod }, ".",            fish("rofi-search")),

    spawn({ mod }, "q",            script("rofi-power")),
    spawn({ mod }, "a",            termstart("pulsemixer", { class = "mixer" })),

    spawn({ mod }, "m",            script("mpc-library")),
    spawn({ mod }, "b",            script("mpc-playlist")),
    spawn({ mod }, "BackSpace",    "mpc toggle"),

    spawn({ mod }, ",",            fish("browser-with-context")),
    spawn({ mod }, "u",            termstart("vifm")),
    spawn({ mod, "Shift"}, "u",    "thunar"),
    spawn({ mod }, "g",            script("wallpaper")),
    spawn({ mod }, "h",            termstart(script("gtgf"), { class = "gtgf" })),
    spawn({}, "F1",                termstart("bhoogle", { class = "help" })),

    spawn({ mod, "Shift" }, "b",   termstart("", { directory = sandbox })),
    spawn({ mod }, "percent",      termstart(
      script("ytdl"),
      { directory = sandbox, class = "download" }
    )),
    spawn({ mod }, "equal",        fish("open (xsel --clipboard -o)")),

    spawn({ mod }, "'",            termstart("")),
    spawn({ mod, "Shift" }, "'",   termstart("", { class = "kitty-light" })),

    spawn({ mod }, "p",            script("screenshot.sh"))
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
