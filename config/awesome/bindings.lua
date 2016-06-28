--[[ Variables ]]---------------------------------------------------------------

terminal = "roxterm --hide-menubar"
modkey = "Mod4"

kanjis = { "一", "二", "三", "四", "五" }

--[[ Mouse bindings ]]----------------------------------------------------------

mouse = awful.util.table.join(
  awful.button({}, 3, function() mymainmenu:toggle() end),
  awful.button({ modkey }, 4, awful.tag.viewnext),
  awful.button({ modkey }, 5, awful.tag.viewprev)
)

--[[ Global keys ]]-------------------------------------------------------------

desktop_notification = function()
  local desktop_kanji = kanjis[awful.tag.getidx()]

  desktop_notification_id = naughty.notify(
    { text = " "..desktop_kanji.."画面 "
    , timeout = 1
    , position = "bottom_right"
    , font = "Inconsolata-g for Powerline 36"
    , fg = beautiful.fg_focus
    , bg = beautiful.bg_focus
    , replaces_id = desktop_notification_id }
  ).id
end

keyboard = awful.util.table.join(
  -- Workspace switching
  awful.key({modkey}, "c", function()
    awful.tag.viewprev()
    desktop_notification()
  end),
  awful.key({modkey}, "r", function()
    awful.tag.viewnext()
    desktop_notification()
  end),

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

--[[ Client Keys ]]-------------------------------------------------------------

clientkeys = awful.util.table.join(
  -- Fullscreen
  awful.key({modkey}, "Return", function(c)
    c.fullscreen = not c.fullscreen
  end),

  -- On Top
  awful.key({modkey}, "h", function(c)
    c.ontop = not c.ontop
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

--[[ Client mouse manipulation ]]-----------------------------------------------

clientbuttons = awful.util.table.join(
  awful.button({}, 1, function(c) client.focus = c; c:raise() end),
  awful.button({modkey}, 1, awful.mouse.client.move),
  awful.button({modkey}, 3, awful.mouse.client.resize),
  awful.button({modkey}, 4, awful.tag.viewnext),
  awful.button({modkey}, 5, awful.tag.viewprev)
)

--[[ Program bindings ]]--------------------------------------------------------

spawn = function(mod, key, cmd)
  return awful.key(mod, key, function() awful.util.spawn(cmd) end)
end
mspawn = function(key, cmd) return spawn({modkey}, key, cmd) end
mtspawn = function(key, cmd)
  return mspawn(key, terminal .. " -e " .. "'" .. cmd .. "'")
end

dmenu = function()
  options = " -l 4 -i "
  colors = " -nb '#fdf6e3' -nf '#657b83' -sb '#eee8d5' -sf '#859900' "
  font = " -fn 'Terminus-10:normal' "
  return "dmenu_run " .. options .. colors .. font
end

nmcli_dmenu = function()
  options = " -l 4 -i "
  colors = " -nb '#fdf6e3' -nf '#657b83' -sb '#eee8d5' -sf '#859900' "
  font = " -fn 'Terminus-10:normal' "
  return "nmcli_dmenu " .. options .. colors .. font
end

notify_volume = function()
  local handle = io.popen("amixer -c 1 get Master")
  local output = handle:read("a*")
  local volume = tonumber(output:match('Mono: Playback %d+ %[(%d+)%%%].*'))
  local on = output:match('Mono: Playback %d+ %[%d+%%%].*%[(on|off)%]')

  local status = ""
  for i = 1, math.floor(volume / 10) do
    status = status .. "|"
  end
  for i = math.floor(volume / 10) + 1, 10 do
    status = status .. "-"
  end
  status = volume.."%".." [" ..status .. "]"

  sound_notification_id = naughty.notify(
    { title = "Volume"
    , text = "\n"..status
    , timeout = 2
    , position = "top_right"
    , fg = beautiful.fg_focus
    , bg = beautiful.bg_focus
    , replaces_id = sound_notification_id }
  ).id
end

keyboard = awful.util.table.join(keyboard,
  -- dmenu
  spawn({"Control"}, " ", dmenu()),
  spawn({}, "F12", nmcli_dmenu()),

  -- Session control
  mspawn("q", "sh /home/tlarrieu/scripts/shutdown_dialog.sh"),

  -- luminosity
  spawn({}, "F7", "xbacklight -10"),
  spawn({}, "F8", "xbacklight +10"),

  -- sound
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.util.spawn("amixer -c 1 set Master 1db-")
    notify_volume()
  end),
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.util.spawn("amixer -c 1 set Master 1db+")
    notify_volume()
  end),

  -- xkill
  awful.key({modkey, "Control"}, "w", function()
    awful.util.spawn("xkill")
  end),

  -- XFCE4 properties
  mspawn("b", "xfce4-settings-manager"),

  mtspawn("u", "ranger"),
  mtspawn("m", "mocp"),

  mspawn("a", "pavucontrol"),
  mspawn("g", "thunar"),
  mspawn("'", "firefox"),

  mspawn("n", terminal),
  spawn({modkey, "Shift"}, "n", "gksu " .. terminal),
  mspawn("p", "shutter -s -o '~/Pictures/Screenshots/%Y-%m-%d-%T_$$h.png'")
)

--[[ Final binding ]]-----------------------------------------------------------

root.buttons(mouse)
root.keys(keyboard)
