awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = true,
      keys = clientkeys,
      buttons = clientbuttons,
      opacity = 0.9
    }
  },

  {rule = {class = "Firefox"}, properties = {opacity = 1.0}},
  {rule = {class = "Opera"}, properties = {opacity = 1.0}},
  {rule = {class = "luakit"}, properties = {opacity = 1.0}},
  {rule = {class = "Plugin-container"}, properties = {
    opacity = 1.0,
    floating = true,
    ontop = true,
    border = 0
  }}, -- Flash player

  {rule = {class = "Evince"}, properties = {opacity = 1.0}},
  {rule = {class = "Zathura"}, properties = {opacity = 1.0}},

  {rule = {class = "Gimp-2.8"}, properties = {opacity = 1.0}},
  {rule = {class = "Inkscape"}, properties = {opacity = 1.0}},
  {rule = {class = "feh"}, properties = {opacity = 1.0}},
  {rule = {class = "Gnumeric"}, properties = {opacity = 1.0}},

  {rule = {class = "Klavaro"}, properties = {opacity = 1.0}},

  {rule = {class = "Wine"}, properties = {opacity = 1.0}},

  {rule = {class = "Eclipse"}, properties = {opacity = 1.0}},

  {rule = {class = "MPlayer"}, properties = {
    opacity = 1.0, floating = true, ontop = true
  }},
  {rule = {class = "Vlc"}, properties = {
    opacity = 1.0, floating = true, ontop = true
  }},

  {rule = {class = "mednafen"}, properties = {
    opacity = 1.0, floating = true, ontop = true
  }},
  {rule = {class = "Phoenix"}, properties = {
    opacity = 1.0, floating = true, ontop = true, fullscreen = true
  }}, -- bsnes
  {rule = {class = "Gvba"}, properties = {opacity = 1.0, floating = true}},
  {rule = {class = "Minecraft"}, properties = {
    opacity = 1.0, floating = true
  }},

  {rule = {class = "Conky"}, properties = {floating = true}},
  {rule = {class = "Kupfer.py"}, properties = {border_width = 0}},

  {rule = {class = "Gpick"}, properties = {
    floating = true, opacity = 1.0, ontop = true
  }}
}
