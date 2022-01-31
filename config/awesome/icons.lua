local _M = {}

local default = ""

local config = {
  -- Google
  { icon = "", rules = {
      { class = "Chromium", name = "Google Sheets" },
      { class = "Chromium", instance = "docs.google.com.*spreadsheets" },
    }},
  { icon = "", rules = {
      { class = "Chromium", instance = "docs.google.com.*slides" },
      { class = "Chromium", name = "Google Slides"  },
    }},
  { icon = "", rules = {
      { class = "Chromium", instance = "docs.google.com" },
      { class = "Chromium", name = "Google Docs" },
    }},
  { icon = "", rules = {
      { class = "Chromium", instance = "hangouts.google.com" },
      { class = "Chromium", instance = "meet.google.com" },
    }},
  { icon = "", rules = {
      { class = "Chromium", instance = "calendar.google.com" },
      { class = "Chromium", instance = "cal.new" }
    }},
  { icon = "﫴", rules = {
      { class = "Chromium", instance = "maps.google.com" },
      { class = "Chromium", instance = "goo.gl__maps" },
    }},
  { icon = "", rule = { class = "Chromium", instance = "drive.google.com"  }},
  { icon = "", rule = { class = "Chromium", name = "Google Photos" }},
  { icon = "", rule = { class = "Chromium", instance = "groups.google.com" }},
  { icon = "", rule = { class = "Chromium", instance = "keep.google.com" }},
  { icon = "", rule = { class = "Chromium", instance = "photos.google.com" }},
  { icon = "輸", rule = { class = "Chromium", name = "YouTube" }},

  -- Social
  { icon = "", rule = { class = "Chromium", instance = "www.gettr.com" }},
  { icon = "", rule = { class = "Chromium", instance = "www.twitter.com" }},
  { icon = "", rule = { class = "Chromium", name = "Twitter" }},
  { icon = "", rule = { class = "Chromium", instance = "reddit.com" }},

  { icon = "", rule = { class = "Chromium", instance = "circleci.com" }},
  { icon = "", rule = { class = "Chromium", instance = "rubygems" }},
  { icon = "", rule = { class = "Chromium", instance = "sentry.io" }},
  { icon = "", rule = { class = "Chromium", instance = "trello.com" }},
  { icon = "", rule = { class = "Chromium", instance = "jobteaser.atlassian.net" }},
  { icon = "", rule = { class = "Chromium", name = "Jira" }},
  { icon = "", rule = { class = "Chromium", instance = "hoogle" }},
  { icon = "", rule = { class = "Chromium", instance = "heroku" }},
  { icon = "", rule = { class = "Chromium", instance = "dynalist.io" }},
  { icon = "", rule = { class = "Chromium", instance = "grafana.net" }},
  { icon = "", rule = { class = "Chromium", instance = "tryhackme.com" }},
  { icon = "", rule = { class = "Chromium", instance = "trainline" }},
  { icon = "", rule = { class = "Chromium", instance = "hub.docker.com" }},
  { icon = "", rule = { class = "Chromium", instance = "app.productplan.com" }},
  { icon = "", rule = { class = "Chromium", instance = "appsignal.com" }},
  { icon = "", rule = { class = "Chromium", instance = "amazon" }},
  { icon = "", rule = { class = "Chromium", instance = "whimsical.co" }},
  { icon = "", rule = { class = "Chromium", instance = "bankin" }},
  { icon = "", rule = { class = "Chromium", instance = "bugsnag.com" }},
  { icon = "", rule = { class = "Chromium", instance = "woven.com" }},
  { icon = "", rule = { class = "Chromium", instance = "amplitude.com" }},
  { icon = "", rule = { class = "Chromium", instance = "datadoghq.com" }},
  { icon = "", rule = { class = "Chromium", instance = "citymapper.com" }},
  { icon = "", rule = { class = "Chromium", instance = "pratebay" }},
  { icon = "", rule = { class = "Chromium", instance = "www.exercism.io" }},
  { icon = "", rule = { class = "Chromium", instance = "app.spendesk.com" }},
  { icon = "", rule = { class = "Chromium", instance = "paypal" }},
  { icon = "", rule = { class = "Chromium", instance = "app.diagrams.net" }},
  { icon = "", rule = { class = "Chromium", instance = "docusign" }},
  { icon = "", rule = { class = "Chromium", instance = "ubereats.com" }},
  { icon = "", rule = { class = "Chromium", instance = "www.github.com" }},
  { icon = "", rule = { class = "Chromium", instance = "my.appoptics.com" }},
  { icon = "", rule = { class = "Chromium", instance = "www.gmail.com" }},
  { icon = "", rule = { class = "Chromium", instance = "discord.com" }},
  { icon = "", rule = { class = "Chromium", instance = "ilucca.net" }},
  { icon = "", rule = { class = "Chromium", instance = "pinterest.com" }},
  { icon = "", rule = { class = "Chromium", instance = "wallhaven.cc" }},
  { icon = "", rule = { class = "Chromium", instance = "notion.so" }},
  { icon = "", rule = { class = "Chromium", instance = "linkedin.com" }},
  { icon = "", rule = { class = "Chromium", instance = "watabou.itch.io" }},
  { icon = "", rule = { class = "Chromium", instance = "rolladvantage.com" }},
  { icon = "", rule = { class = "Chromium", instance = "app.legendkeeper.com" }},
  { icon = "", rule = { class = "Chromium", instance = "slack" }},
  { icon = "", rule = { class = "Chromium", instance = "pragli.com" }},
  { icon = "", rule = { class = "Chromium", instance = "papertrail" }},
  { icon = "滛", rule = { class = "Chromium", instance = "metroretro.io" }},
  { icon = "甆", rule = { class = "Chromium", instance = "web.whatsapp.com" }},
  { icon = "﫩", rule = { class = "Chromium", instance = "roll20.net" }},
  { icon = "﫱", rule = { class = "Chromium", instance = "www.deliveroo.fr" }},
  { icon = "﵁", rule = { class = "Chromium", instance = "jobteaser.kanbantool.com" }},

  { icon = "", rule = { class = "Chromium" }},

  { icon = "", rule = { class = "Gpick" }},
  { icon = "", rule = { class = "man" }},
  { icon = "", rule = { class = "dungeondraft.exe" }},
  { icon = "", rule = { class = "Thunar" }},
  { icon = "", rule = { class = "config" }},
  { icon = "", rule = { class = "Wine" }},
  { icon = "", rule = { class = "Cockatrice" }},
  { icon = "", rule = { class = "firefox" }},
  { icon = "", rule = { class = "quake" }},
  { icon = "", rule = { class = "Lxappearance" }},
  { icon = "", rule = { class = "Mainwindow.py" }}, --[[ PlayOnLinux ]]
  { icon = "", rule = { class = "Steam" }},
  { icon = "", rule = { name = "yay" }},
  { icon = "", rule = { class = "Seahorse" }},
  { icon = "", rule = { class = "Signal" }},
  { icon = "", rule = { class = "zoom" }},
  { icon = "", rule = { class = "wiki" }},
  { icon = "", rule = { class = "taskwarrior" }},
  { icon = "", rule = { class = "Luakit" }},
  { icon = "", rule = { class = "nyxt" }},
  { icon = "", rule = { class = "Gimp" }},
  { icon = "", rule = { class = "download" }},
  { icon = "", rule = { class = "Zathura" }},
  { icon = "", rule = { class = "Flowblade" }},
  { icon = "", rule = { class = "gtgf" }},
  { icon = "", rule = { class = "Lutris" }},
  { icon = "", rule = { class = "discord" }},
  { icon = "", rule = { class = "help" }},
  { icon = "", rule = { class = "Sxiv" }},
  { icon = "", rule = { class = "Viewnior" }},
  { icon = "", rule = { class = "Godot" }}, --[[ wonderdraft ]]
  { icon = "", rule = { class = "Xephyr" }},
  { icon = "", rule = { class = "mpv" }},
  { icon = "", rule = { class = "Audacity" }},
  { icon = "", rule = { class = "scratchpad" }},
  { icon = "沈", rule = { class = "RoomArranger" }},
  { icon = "嗢", rule = { class = "Vlc" }},
  { icon = "嗢", rule = { class = "vlc" }},
  { icon = "奔", rule = { class = "mixer" }},
  { icon = "ﮩ", rule = { name = "Document Scanner" }},

  { icon = "", rule = { class = "kitty", name = "git/dotfiles" }},
  { icon = "", rule = { class = "kitty", name = "exercism" }},
  { icon = "", rule = { class = "kitty", name = "NVIM" }},
  { icon = "", rule = { class = "kitty", name = "newsboat" }},
  { icon = "", rule = { class = "kitty", name = "htop" }},
  { icon = "", rule = { class = "kitty", name = "vifm" }},
  { icon = "嬨", rule = { class = "kitty", name = "vpn" }},
  { icon = "", rule = { class = "kitty" }},
}

local match = function(client, rule)
  return (not rule.name or client.name:find(rule.name)) and
    (not rule.instance or client.instance:find(rule.instance)) and
    (not rule.class or client.class:find(rule.class))
end

_M.fetch = function(client)
  for i = 1, #config do
    if config[i].rules then
      for j = 1, #config[i].rules do
        if match(client, config[i].rules[j]) then return config[i].icon end
      end
    else
      if match(client, config[i].rule) then return config[i].icon end
    end
  end

  return default
end

return _M
