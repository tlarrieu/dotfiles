--[[ Mouse bindings ]]----------------
root.buttons(awful.util.table.join(
  awful.button({        }, 3, function () mymainmenu:toggle() end),
  awful.button({ modkey }, 4, awful.tag.viewnext                 ),
  awful.button({ modkey }, 5, awful.tag.viewprev                 )
))

--[[ Global keys ]]----------------
globalkeys = awful.util.table.join(
  -- Workspace switching
  awful.key({ modkey,           }, "c",  awful.tag.viewprev                              ),
  awful.key({ modkey,           }, "r",  awful.tag.viewnext                              ),

  -- Layout manipulation
  awful.key({ modkey, "Control" }, "t",  function () awful.client.swap.byidx(  1)     end),
  awful.key({ modkey, "Control" }, "s",  function () awful.client.swap.byidx( -1)     end),
  awful.key({ modkey,           }, "d",  function () awful.tag.incmwfact( 0.05)       end),
  awful.key({ modkey,           }, "v",  function () awful.tag.incmwfact(-0.05)       end),
  awful.key({ modkey, "Shift"   }, "d",  function () awful.client.incwfact( 0.05)     end),
  awful.key({ modkey, "Shift"   }, "v",  function () awful.client.incwfact(-0.05)     end),
  -- Layout switching
  awful.key({ modkey,           }, "\"", function () awful.layout.inc(layouts, 1)     end),
  awful.key({ modkey,           }, "«",  function () awful.layout.inc(layouts, -1)    end),
  -- Focus switching
  awful.key({ modkey,           }, "t",
    function ()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end
    end),
  awful.key({ modkey,           }, "s",
    function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end),
  -- Screen switching
  awful.key({ modkey,           }, "e",  function () awful.screen.focus_relative(1)    end),
  -- Window screen switching
  awful.key({ modkey,           }, "o",  awful.client.movetoscreen                        ),

  awful.key({ "Control", "Shift"}, "r",  awesome.restart                                  )
)

--[[ Workspace handling ]]----------------
-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
  keynumber = math.min(9, math.max(#tags[s], keynumber));
end

for i = 1, keynumber do
  globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "F" .. i + 9,
      function ()
        local screen = mouse.screen
        if tags[screen][i] then
          awful.tag.viewonly(tags[screen][i])
        end
      end),
    awful.key({ modkey }, "F" .. i,
      function ()
        if client.focus and tags[client.focus.screen][i] then
          awful.client.movetotag(tags[client.focus.screen][i])
        end
      end
    )
  )
end

--[[ Client Keys ]]----------------
clientkeys = awful.util.table.join(
  -- Fullscreen
  awful.key({ modkey,           }, "f", function (c) c.fullscreen = not c.fullscreen end),
  -- On Top
  awful.key({ modkey,           }, "h", function (c) c.ontop = not c.ontop           end),
  -- Kill
  awful.key({ modkey,           }, "w", function (c) c:kill()                        end),
  awful.key({ modkey, "Control" }, "w", function (c) awful.util.spawn("xkill")       end),
  -- Moving client arounds
  awful.key({ modkey, "Control" }, "c",
    function (c)
      local id = awful.tag.getidx()
      if id == 1 then
        id = keynumber
      else
        id = id - 1
      end
      local screen = client.focus.screen
      awful.client.movetotag(tags[screen][id])
      awful.tag.viewonly(tags[screen][id])
    end

  ),
  awful.key({ modkey, "Control" }, "r",
    function (c)
      local id = awful.tag.getidx() % keynumber + 1
      local screen = client.focus.screen
      awful.client.movetotag(tags[screen][id])
      awful.tag.viewonly(tags[screen][id])
    end
  )
)

--[[ Client mouse manipulation ]]----------------
clientbuttons = awful.util.table.join(
  awful.button({                }, 1, function (c) client.focus = c; c:raise() end),
  awful.button({ modkey         }, 1, awful.mouse.client.move                     ),
  awful.button({ modkey         }, 3, awful.mouse.client.resize                   ),
  awful.button({ modkey         }, 4, awful.tag.viewnext                          ),
  awful.button({ modkey         }, 5, awful.tag.viewprev                          )
)

--[[ Program bindings ]]----------------
globalkeys = awful.util.table.join(globalkeys,
  -- dmenu
  --awful.key({ modkey          }, " ",           function ()
  --  awful.util.spawn("dmenu_run -l 5 -i -p 'Run :'" ..
  --    " -nb '" ..  beautiful.bg_normal ..
  --    "' -nf '" .. beautiful.fg_normal ..
  --    "' -sb '" .. beautiful.bg_focus ..
  --    "' -sf '" .. beautiful.fg_focus .. "'")
  --end),
  awful.key({ modkey            }, " ",           function ()
    -- Solarized theme uses #AARRGGBB, not supported by dmenu, so I had to hardcode values :(
    awful.util.spawn("dmenu_run -l 5 -i -p 'Run: ' -nb '#002b36' -nf '#839496' -sb '#073642' -sf '#859900' -fn '-*-terminus-medium-*-*-*-16-*-*-*-*-*-*-*'")
  end),
  -- Session control
  awful.key({ modkey            }, "q",           function () awful.util.spawn("xfce4-session-logout")       end),
  -- XFCE4 properties
  awful.key({ modkey            }, "b",           function () awful.util.spawn("xfce4-settings-manager")     end),
  -- Media player controls
  awful.key({                   }, "F10",         function () awful.util.spawn("mocp --previous")            end),
  awful.key({                   }, "F11",         function () awful.util.spawn("mocp --toggle-pause")        end),
  awful.key({                   }, "F12",         function () awful.util.spawn("mocp --next")                end),

  awful.key({ modkey            }, "i",           function () awful.util.spawn(terminal_exec .. "ranger")    end),
  awful.key({ modkey            }, "m",           function () awful.util.spawn(terminal_exec .. "mocp")      end),
  awful.key({ modkey            }, "a",           function () awful.util.spawn(terminal_exec .. "alsamixer") end),

  awful.key({ modkey            }, "Return",      function () awful.util.spawn(terminal)                     end),
  awful.key({ modkey, "Shift"   }, "Return",      function () awful.util.spawn("gksu" .. terminal)           end),
  awful.key({ "Control"         }, "F12",         function () awful.util.spawn("scrot -e 'mv $f ~/Pictures/Screenshots/'") end)
)

-- Set keys
root.keys(globalkeys)
