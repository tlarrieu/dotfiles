local _M = {
  keyboard = {},
  mouse = {}
}

-- [[ Variables ]] -------------------------------------------------------------

local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")

local terminal = "kitty --single-instance"
local dotfiles = string.format("%s/git/dotfiles", os.getenv("HOME"))
local sandbox = string.format("%s/sandbox", os.getenv("HOME"))
local mod = "Mod4"

local key = awful.key
local mkey = function(k, f) return key({mod}, k, f) end

local spawn = function(mods, k, cmd, props)
  return key(mods, k, function() awful.spawn(cmd, props) end)
end
local mspawn = function(k, cmd, props) return spawn({mod}, k, cmd, props) end

local script = function(path)
  return "sh " .. os.getenv("HOME") .. "/scripts/" .. path
end

local fish = function(command)
  return "fish -c '" .. command .. "'"
end

local termstart = function(cmd, opts)
  local options = ""
  if opts then
    for name, value in pairs(opts) do
      options = string.format("%s --%s %s", options, name, value)
    end
  end

  return fish(string.format(
    "%s %s %s",
    terminal,
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

    mspawn("l", script('rofi-layouts')),

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

    mspawn(" ",                    fish("rofi -show run -lines 6")),
    spawn({ "Control" }, " ",      script("gtd-inbox")),
    spawn({ mod, "Shift" }, "c",   termstart(
      "nvim nvim/init.vim",
      { directory = dotfiles }
    )),
    spawn({ mod, "Shift" }, "e",   termstart("nvim")),
    mspawn("Tab",                  script("rofi-window")),
    spawn({mod, "Control"}, "Tab", script("rofi-monitors")),
    spawn({}, "F12",               script("rofi-wifi")),
    mspawn("F2",                   script("rofi-keyboard")),
    mspawn("k",                    script("rofi-emojis")),
    mspawn("f",                    script("rofi-nerdfont")),
    mspawn("à",                    script("rofi-bluetooth")),
    mspawn("Escape",               script("rofi-pass")),

    mspawn("q", script("rofi-power")),
    mspawn("a", termstart("pulsemixer", { class = "mixer" })),

    mspawn("m", script("mpc-library")),
    mspawn("b", script("mpc-playlist")),
    mspawn("$", "mpc toggle"),

    mspawn(".", "bash -c 'GDK_SCALE=2 GDK_DPI_SCALE=0.5 nyxt -S'"),
    mspawn(",", fish("chromium-with-context")),
    mspawn("u", termstart("vifm")),
    spawn({mod, "Shift"}, "u", "thunar"),
    mspawn("g", script("wallpaper")),
    mspawn("h", termstart(script("gtgf"), { class = "gtgf" })),
    spawn({}, "F1", termstart("bhoogle", { class = "help" })),

    spawn({ mod, "Shift" }, "b",   termstart("", { directory = sandbox })),
    mspawn("percent", termstart(script("ytdl"), { directory = sandbox })),

    mspawn("'", terminal),
    spawn({ mod, "Shift" }, "'",   termstart("", { class = "kitty-light" })),

    mspawn("p", script("screenshot.sh"))
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
