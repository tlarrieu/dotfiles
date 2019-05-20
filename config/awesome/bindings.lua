-- [[ Variables ]] -------------------------------------------------------------
local awful = require("awful")

local terminal = "kitty"
local mod = "Mod4"

local key = awful.key
local mkey = function(k, f) return key({mod}, k, f) end

local spawn = function(mods, k, cmd, props)
  return key(mods, k, function() awful.spawn(cmd, props) end)
end
local mspawn = function(k, cmd, props) return spawn({mod}, k, cmd, props) end

local client_focus = function(direction)
  awful.client.focus.byidx(direction)
  if client.focus then client.focus:raise() end
end

local script = function(path)
  return "sh " .. os.getenv("HOME") .. "/scripts/" .. path
end

local create_tag_if_needed = function()
  local current_tag = awful.screen.focused().selected_tag
  local alltags = awful.screen.focused().tags
  local lasttag = alltags[#alltags]

  if current_tag == lasttag and #current_tag:clients() > 1 then
    local config = {
      layout = awful.layout.suit.fair,
      master_width_factor = 0.75,
      screen = awful.screen.focused(),
      volatile = true
    }

    return awful.tag.add("", config)
  end
end

-- [[ Client ]] ----------------------------------------------------------------

clientkeys = awful.util.table.join(
  mkey("Return", function(c) c.fullscreen = not c.fullscreen end),
  mkey("eacute", function(c) c:kill() end),

  key({mod, "Control"}, "c", function(c)
    awful.tag.viewprev()
    c:move_to_tag(c.screen.selected_tag)
  end),

  key({ mod, "Control" }, "r", function(c)
    create_tag_if_needed()

    awful.tag.viewnext()
    c:move_to_tag(c.screen.selected_tag)
  end),

  mkey("o", function(client)
    local last_screen = client.screen
    client:move_to_screen()
    awful.screen.focus(last_screen)
  end),

  key({ mod, "Control" }, "o", function(client)
    local tags = client.screen.tags
    local id = awful.tag.getidx()
    local tag = tags[id]

    for _, c in ipairs(tag:clients()) do
      if client ~= c then c:kill() end
    end
  end)
)

clientbuttons = awful.util.table.join(
  awful.button({}, 1, function(c) client.focus = c; c:raise() end)
)

-- [[ Window Manager ]] --------------------------------------------------------

local viewtag = function(id) awful.screen.focused().tags[id]:view_only() end

local keyboard = awful.util.table.join(
  mspawn("l", script('rofi-layouts')),

  mkey("c",     awful.tag.viewprev),
  mkey("Left",  awful.tag.viewprev),
  mkey("r",     awful.tag.viewnext),
  mkey("Right", awful.tag.viewnext),

  mkey("\"",             function() viewtag(1) end),
  mkey("guillemotleft",  function() viewtag(2) end),
  mkey("guillemotright", function() viewtag(3) end),
  mkey("(",              function() viewtag(4) end),
  mkey(")",              function() viewtag(5) end),
  mkey("@",              function() viewtag(6) end),

  key({mod, "Control"}, "t", function() awful.client.swap.byidx(1) end),
  key({mod, "Control"}, "s", function() awful.client.swap.byidx(-1) end),

  mkey("d",          function() awful.tag.incmwfact(0.05) end),
  mkey("v",          function() awful.tag.incmwfact(-0.05) end),
  key({mod, "Shift"}, "d", function() awful.client.incwfact(0.05) end),
  key({mod, "Shift"}, "v", function() awful.client.incwfact(-0.05) end),

  mkey("t",    function() client_focus(1) end),
  mkey("Down", function() client_focus(1) end),
  mkey("s",    function() client_focus(-1) end),
  mkey("Up",   function() client_focus(-1) end),

  mkey("i", function() awful.screen.focus_relative(1) end),
  mkey("e", function() awful.screen.focus_relative(-1) end),

  key({mod, "Shift"}, "r", awesome.restart)
)

-- [[ Applications ]] ----------------------------------------------------------

keyboard = awful.util.table.join(
  keyboard,

  mspawn(" ",                    "fish -c 'rofi -show run -lines 6'"),
  spawn({ "Control" }, " ",      script("gtd-inbox")),
  mspawn("Tab",                  "rofi -show window -lines 6"),
  spawn({mod, "Control"}, "Tab", script("rofi-monitors")),
  spawn({}, "F12",               script("rofi-wifi")),
  mspawn("F2",                   script("rofi-keyboard")),
  mspawn("k",                    script("rofi-emojis")),
  mspawn("f",                    script("rofi-nerdfont")),

  mspawn("q", script("rofi-power")),
  mspawn("a", terminal .. " --class ncpamixer ncpamixer"),

  mspawn("m", script("mpc-library")),
  mspawn("b", script("mpc-playlist")),
  mspawn("$", "mpc toggle"),

  mspawn(".", "luakit"),
  spawn({mod, "Shift"}, ".", "chromium --profile-directory=Default"),
  mspawn("u", terminal .. " vifm"),
  mspawn("g", script("wallpaper")),
  mspawn("h", terminal .. " " .. script("gtgf")),

  mspawn("'", terminal),
  mspawn("n", terminal .. " nmtui"),

  mspawn("p", script("screenshot.sh"))
)

-- [[ Final binding ]] ---------------------------------------------------------

root.keys(keyboard)
