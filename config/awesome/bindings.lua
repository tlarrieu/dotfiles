-- [[ Variables ]] -------------------------------------------------------------
local awful = require("awful")

local terminal = "kitty"
local mod = "Mod4"

local spawn = function(modifiers, key, cmd)
  return awful.key(modifiers, key, function() awful.spawn(cmd) end)
end
local mspawn = function(key, cmd) return spawn({mod}, key, cmd) end

local client_focus = function(direction)
  awful.client.focus.byidx(direction)
  if client.focus then client.focus:raise() end
end

local script = function(path)
  return "sh " .. os.getenv("HOME") .. "/scripts/" .. path
end

-- [[ Client ]] ----------------------------------------------------------------

clientkeys = awful.util.table.join(
  -- Fullscreen
  awful.key({mod}, "Return", function(c) c.fullscreen = not c.fullscreen end),

  -- Kill
  awful.key({mod}, "eacute", function(c) c:kill() end),

  -- Moving client arounds
  awful.key({mod, "Control"}, "c", function(c)
    local tags = c.screen.tags
    local id = awful.tag.getidx()
    if id == 1 then
      id = #tags
    else
      id = id - 1
    end
    awful.client.movetotag(tags[id])
    tags[id]:view_only()
  end),
  awful.key({ mod, "Control" }, "r", function(c)
    local tags = c.screen.tags
    local id = awful.tag.getidx() % #tags + 1
    awful.client.movetotag(tags[id])
    tags[id]:view_only()
  end)
)

clientbuttons = awful.util.table.join(
  awful.button({}, 1, function(c) client.focus = c; c:raise() end),
  awful.button({mod}, 1, awful.mouse.client.move),
  awful.button({mod}, 3, awful.mouse.client.resize)
)

-- [[ Window Manager ]] --------------------------------------------------------

local viewtag = function(id) awful.screen.focused().tags[id]:view_only() end

local keyboard = awful.util.table.join(
  -- Layout switching

  mspawn("l", script('rofi-layouts')),

  -- Tags switching

  awful.key({mod}, "c",     awful.tag.viewprev),
  awful.key({mod}, "Left",  awful.tag.viewprev),
  awful.key({mod}, "r",     awful.tag.viewnext),
  awful.key({mod}, "Right", awful.tag.viewnext),

  -- Tags direct access

  awful.key({mod}, "\"",             function() viewtag(1) end),
  awful.key({mod}, "guillemotleft",  function() viewtag(2) end),
  awful.key({mod}, "guillemotright", function() viewtag(3) end),
  awful.key({mod}, "(",              function() viewtag(4) end),
  awful.key({mod}, ")",              function() viewtag(5) end),
  awful.key({mod}, "@",              function() viewtag(6) end),

  -- Client moving

  awful.key({mod, "Control"}, "t", function() awful.client.swap.byidx(1) end),
  awful.key({mod, "Control"}, "s", function() awful.client.swap.byidx(-1) end),

  -- Client size

  awful.key({mod}, "d",          function() awful.tag.incmwfact(0.05) end),
  awful.key({mod}, "v",          function() awful.tag.incmwfact(-0.05) end),
  awful.key({mod, "Shift"}, "d", function() awful.client.incwfact(0.05) end),
  awful.key({mod, "Shift"}, "v", function() awful.client.incwfact(-0.05) end),

  -- Client focus

  awful.key({mod}, "t",    function() client_focus(1) end),
  awful.key({mod}, "Down", function() client_focus(1) end),
  awful.key({mod}, "s",    function() client_focus(-1) end),
  awful.key({mod}, "Up",   function() client_focus(-1) end),

  -- Screen focus

  awful.key({mod}, "i", function() awful.screen.focus_relative(1) end),
  awful.key({mod}, "e", function() awful.screen.focus_relative(-1) end),

  -- Client screen moving

  awful.key({mod}, "o",          function(c) awful.client.movetoscreen(c) end),

  -- Restart awesome

  awful.key({mod, "Shift"}, "r", awesome.restart)
)

-- [[ Applications ]] ----------------------------------------------------------

keyboard = awful.util.table.join(
  keyboard,

  -- launcher

  mspawn(" ",                    "rofi -show run"),
  mspawn("Tab",                  "rofi -show window"),
  spawn({mod, "Control"}, "Tab", script("rofi-monitors")),
  spawn({}, "F12",               script("rofi-wifi")),
  mspawn("F2",                   script("rofi-keyboard")),
  mspawn("f",                    script("rofi-nerdfont")),

  -- Power management

  mspawn("q", script("rofi-power")),

  -- luminosity

  spawn({}, "F7", "ligth -U 10"),
  spawn({}, "F8", "light -A 10"),

  -- sound

  mspawn("a", "pavucontrol"),

  -- music

  mspawn("m", script("mpc-library")),
  mspawn("b", script("mpc-playlist")),
  spawn({ "Control" }, " ", "mpc toggle"),

  spawn({}, "F9", "playerctl play-pause"),
  spawn({}, "F10", "playerctl next"),

  awful.key({mod, "Control"}, "m", function()
    run_or_raise("spotify", { class = "Spotify" })
  end),

  -- browsers

  mspawn("n", "luakit"),
  spawn({mod, "Control"}, "n", "qutebrowser --backend webengine"),
  mspawn("u", terminal .. " -e ranger"),
  mspawn("g", "thunar"),

  -- terminal

  mspawn("'", terminal),
  mspawn(".", terminal .. " -e nmtui"),

  -- screenshots

  awful.key({mod}, "p", function()
    awful.util.spawn_with_shell(script("screenshot.sh"))
  end),

  -- xkill

  spawn({mod, "Control"}, "w", "xkill"),

  -- htop

  mspawn(",", terminal .. " -e htop")
)

-- [[ Final binding ]] ---------------------------------------------------------

root.keys(keyboard)
