-- [[ Variables ]] -------------------------------------------------------------

local terminal = "termite"
local mod = "Mod4"

-- [[ Panel ]] -----------------------------------------------------------------

tagbuttons = awful.util.table.join(
  awful.button({}, 1, awful.tag.viewonly)
)

taskbuttons = awful.util.table.join(
  awful.button({}, 1,
    function (c)
      if not c:isvisible() then
        awful.tag.viewonly(c:tags()[1])
      end
      client.focus = c
      c:raise()
    end
  )
)

layoutbuttons = awful.util.table.join(
  awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
  awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
  awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
)

-- [[ Client ]] ----------------------------------------------------------------

clientkeys = awful.util.table.join(
  -- Fullscreen
  awful.key({mod}, "Return", function(c)
    c.fullscreen = not c.fullscreen
  end),

  -- Minimize
  awful.key({mod}, "h", function(c)
    c.minimized = not c.minimize
  end),

  -- Kill
  awful.key({mod}, "eacute", function(c) c:kill() end),

  -- Moving client arounds
  awful.key({mod, "Control"}, "c", function(c)
    local screen = client.focus.screen
    local id = awful.tag.getidx()
    if id == 1 then
      id = #tags[screen]
    else
      id = id - 1
    end
    awful.client.movetotag(tags[screen][id])
    awful.tag.viewonly(tags[screen][id])
  end),
  awful.key({ mod, "Control" }, "r", function(c)
    local screen = client.focus.screen
    local id = awful.tag.getidx() % #tags[screen] + 1
    awful.client.movetotag(tags[screen][id])
    awful.tag.viewonly(tags[screen][id])
  end)
)

clientbuttons = awful.util.table.join(
  awful.button({}, 1, function(c) client.focus = c; c:raise() end),
  awful.button({mod}, 1, awful.mouse.client.move),
  awful.button({mod}, 3, awful.mouse.client.resize),
  awful.button({mod}, 4, awful.tag.viewnext),
  awful.button({mod}, 5, awful.tag.viewprev)
)

-- [[ Window Manager ]] --------------------------------------------------------

local viewtag = function(screen, id)
  awful.tag.viewonly(tags[screen][id])
end

local keyboard = awful.util.table.join(
  -- Tags switching

  awful.key({mod}, "c", awful.tag.viewprev),
  awful.key({mod}, "Left", awful.tag.viewprev),
  awful.key({mod}, "r", awful.tag.viewnext),
  awful.key({mod}, "Right", awful.tag.viewnext),

  -- Tags direct access

  awful.key({mod}, "\"", function() viewtag(1, 1) end),
  awful.key({mod}, "guillemotleft", function() viewtag(1, 2) end),
  awful.key({mod}, "guillemotright", function() viewtag(1, 3) end),
  awful.key({mod}, "(", function() viewtag(1, 4) end),
  awful.key({mod}, ")", function() viewtag(1, 5) end),
  awful.key({mod}, "@", function() viewtag(1, 6) end),

  -- Client moving

  awful.key({mod, "Control"}, "t", function() awful.client.swap.byidx(1) end),
  awful.key({mod, "Control"}, "s", function() awful.client.swap.byidx(-1) end),
  -- Client size
  awful.key({mod}, "d", function() awful.tag.incmwfact(0.05) end),
  awful.key({mod}, "v", function() awful.tag.incmwfact(-0.05) end),
  awful.key({mod, "Shift"}, "d", function() awful.client.incwfact(0.05) end),
  awful.key({mod, "Shift"}, "v", function() awful.client.incwfact(-0.05) end),

  -- Layout switching

  awful.key({mod}, "l", function() awful.layout.inc(layouts, 1) end),
  awful.key({mod, "Shift"}, "l", function() awful.layout.inc(layouts, -1) end),

  -- Client focus

  awful.key({mod}, "t", function()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
  awful.key({mod}, "Down", function()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
  awful.key({mod}, "s", function()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end),
  awful.key({mod}, "Up", function()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end),

  -- Screen focus

  awful.key({mod}, "i", function() awful.screen.focus_relative(1) end),
  awful.key({mod}, "e", function() awful.screen.focus_relative(-1) end),

  -- Client screen moving

  awful.key({mod}, "o", function(c)
    awful.client.movetoscreen(c, client.focus.screen - 1)
  end),
  awful.key({mod, "Shift"}, "o", function(c)
    awful.client.movetoscreen(c, client.focus.screen + 1)
  end),

  -- Restart awesome

  awful.key({mod, "Shift"}, "r", awesome.restart)
)

-- [[ Applications ]] ----------------------------------------------------------

local spawn = function(mod, key, cmd)
  return awful.key(mod, key, function() awful.util.spawn(cmd) end)
end
local mspawn = function(key, cmd) return spawn({mod}, key, cmd) end
local mtspawn = function(key, cmd)
  return mspawn(key, terminal .. " -e " .. "'" .. cmd .. "'")
end

keyboard = awful.util.table.join(
  keyboard,

  -- launcher

  spawn({"Control"}, " ", "rofi -show run"),
  mspawn("Tab", "rofi -show window"),
  spawn(
    {mod, "Control"},
    "Tab",
    "sh /home/tlarrieu/scripts/rofi-monitors"
  ),
  spawn({}, "F12", "sh /home/tlarrieu/scripts/rofi-wifi"),
  mspawn("F2", "sh /home/tlarrieu/scripts/rofi-keyboard"),

  -- Power management

  mspawn("Escape", "sh /home/tlarrieu/scripts/rofi-power"),

  -- luminosity

  spawn({}, "F7", "xbacklight -10"),
  spawn({}, "F8", "xbacklight +10"),

  -- sound

  mspawn("a", "pavucontrol"),

  -- music

  mspawn("m", "sh /home/tlarrieu/scripts/mpc-library"),
  mspawn("b", "sh /home/tlarrieu/scripts/mpc-playlist"),
  mspawn(" ", "mpc toggle"),

  awful.key({mod, "Control"}, "m", function()
    run_or_raise("spotify", { class = "Spotify" })
  end),

  -- browsers

  mspawn("n", "qutebrowser --backend webengine"),
  mspawn("u", terminal .. " -e 'ranger' -t ranger --class=Ranger"),
  mspawn("g", "thunar"),

  -- terminal

  mspawn("'", terminal),

  -- screenshots

  awful.key({mod}, "p", function()
    awful.util.spawn_with_shell("sh /home/tlarrieu/scripts/scrot.sh")
  end),

  -- xkill

  spawn({mod, "Control"}, "w", "xkill"),

  -- htop

  mspawn(",", terminal .. " -e htop"),

  -- hangups

  awful.key({mod}, ".", function()
    run_or_raise(terminal .. " --class=hangups -e hangups", { class = "hangups" })
  end)
)

-- [[ Final binding ]] ---------------------------------------------------------

root.keys(keyboard)
