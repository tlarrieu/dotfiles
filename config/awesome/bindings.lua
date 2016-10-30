-- [[ Variables ]] -------------------------------------------------------------

local terminal = "termite"
local modkey = "Mod4"

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
  awful.key({modkey}, "Return", function(c)
    c.fullscreen = not c.fullscreen
  end),

  -- Minimize
  awful.key({modkey}, "h", function(c)
    c.minimized = not c.minimize
  end),

  -- Kill
  awful.key({modkey}, "w", function(c) c:kill() end),

  -- Moving client arounds
  awful.key({modkey, "Control"}, "c", function(c)
    local screen = client.focus.screen
    local id = awful.tag.getidx()
    if id == 1 then
      id = #tags[screen]
    else
      id = id - 1
    end
    awful.client.movetotag(tags[screen][id])
    awful.tag.viewonly(tags[screen][id])
    desktop_notification()
  end),
  awful.key({ modkey, "Control" }, "r", function(c)
    local screen = client.focus.screen
    local id = awful.tag.getidx() % #tags[screen] + 1
    awful.client.movetotag(tags[screen][id])
    awful.tag.viewonly(tags[screen][id])
    desktop_notification()
  end)
)

clientbuttons = awful.util.table.join(
  awful.button({}, 1, function(c) client.focus = c; c:raise() end),
  awful.button({modkey}, 1, awful.mouse.client.move),
  awful.button({modkey}, 3, awful.mouse.client.resize),
  awful.button({modkey}, 4, awful.tag.viewnext),
  awful.button({modkey}, 5, awful.tag.viewprev)
)

-- [[ Window Manager ]] --------------------------------------------------------

local keyboard = awful.util.table.join(
  -- Workspace switching

  awful.key({modkey}, "c", awful.tag.viewprev),
  awful.key({modkey}, "r", awful.tag.viewnext),

  -- Client moving

  awful.key({modkey, "Control"}, "t", function()
    awful.client.swap.byidx(1)
  end),
  awful.key({modkey, "Control"}, "s", function()
    awful.client.swap.byidx(-1)
  end),
  -- Client size
  awful.key({modkey}, "d", function()
    awful.tag.incmwfact(0.05)
  end),
  awful.key({modkey}, "v", function()
    awful.tag.incmwfact(-0.05)
  end),
  awful.key({modkey, "Shift"}, "d", function()
    awful.client.incwfact(0.05)
  end),
  awful.key({modkey, "Shift"}, "v", function()
    awful.client.incwfact(-0.05)
  end),

  -- Layout switching

  awful.key({modkey}, "l", function()
    awful.layout.inc(layouts, 1)
  end),
  awful.key({modkey, "Shift"}, "l", function()
    awful.layout.inc(layouts, -1)
  end),

  -- Client focus

  awful.key({modkey}, "t", function()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
  end),
  awful.key({modkey}, "s", function()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
  end),

  -- Screen focus

  awful.key({modkey}, "i", function()
    awful.screen.focus_relative(1)
  end),
  awful.key({modkey}, "e", function()
    awful.screen.focus_relative(-1)
  end),

  -- Client screen moving

  awful.key({modkey}, "o", function(c)
    awful.client.movetoscreen(c,client.focus.screen-1)
  end),
  awful.key({modkey, "Shift"}, "o", function(c)
    awful.client.movetoscreen(c,client.focus.screen+1)
  end),

  -- Restart awesome

  awful.key({modkey, "Shift"}, "r", awesome.restart)
)

-- [[ Applications ]] ----------------------------------------------------------

local spawn = function(mod, key, cmd)
  return awful.key(mod, key, function() awful.util.spawn(cmd) end)
end
local mspawn = function(key, cmd) return spawn({modkey}, key, cmd) end
local mtspawn = function(key, cmd)
  return mspawn(key, terminal .. " -e " .. "'" .. cmd .. "'")
end

keyboard = awful.util.table.join(
  keyboard,

  -- launcher

  spawn({"Control"}, " ", "rofi -show run"),
  mspawn("Tab", "rofi -show window"),
  spawn(
    {modkey, "Control"},
    "Tab",
    "sh /home/tlarrieu/scripts/rofi-monitors"
    ),
  spawn({}, "F12", "sh /home/tlarrieu/scripts/rofi-wifi"),

  -- Power management

  mspawn("Escape", "sh /home/tlarrieu/scripts/rofi-power"),

  -- luminosity

  spawn({}, "F7", "xbacklight -10"),
  spawn({}, "F8", "xbacklight +10"),

  -- sound

  mspawn("a", "pavucontrol"),

  -- music

  awful.key({modkey, "Control"}, "m", function()
    run_or_raise(
      terminal .. " -e 'padsp mocp' -t mocp --class=mocp",
      { class = "mocp" }
    )
  end),

  awful.key({modkey}, "m", function()
    run_or_raise("spotify", { class = "Spotify" })
  end),

  -- XFCE4 properties

  mspawn("b", "xfce4-settings-manager"),

  awful.key({modkey}, ".", function()
    run_or_raise(terminal .. " --class=hangups -e hangups", { class = "hangups" })
  end),

  -- browsers

  mspawn("'", "qutebrowser"),
  mtspawn("u", "ranger"),
  mspawn("g", "thunar"),

  -- games

  spawn({modkey, "Control"}, "h", "/home/tlarrieu/bin/hearthstone"),

  -- terminal

  mspawn("n", terminal),
  spawn({modkey, "Shift"}, "n", "gksu " .. terminal),

  -- screenshots

  awful.key({modkey}, "p", function()
    awful.util.spawn_with_shell("sh /home/tlarrieu/scripts/scrot.sh")
  end),

  -- xkill

  spawn({modkey, "Control"}, "w", "xkill")
)

-- [[ Final binding ]] ---------------------------------------------------------

root.keys(keyboard)
