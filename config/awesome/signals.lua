local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")

client.connect_signal("focus", function(client)
  client.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(client)
  client.border_color = beautiful.border_normal
end)

client.connect_signal("request::activate", function(client, context)
  local skip = context == "mouse_click" or
    context == "ewmh" or
    context == "autofocus.check_focus"

  if skip then return end

  helpers.center_mouse_in_client(client)
end)

-- [[ Dynamic tag names ]] -----------------------------------------------------

local client_signals = {
  "property::name",
  "property::class",
  "property::instance",
  "unmanage",
  "manage",
  "focus"
}
local tag_signals = { "tagged", "untagged" }

local rules = {
  { class = "Chromium", name = "Google Sheets", icon = "" },
  { class = "Chromium", name = "Google Docs", icon = "" },
  { class = "Chromium", name = "Google Photos", icon = "" },
  { class = "Chromium", name = "Google Slides" , icon = "" },
  { class = "Chromium", name = "YouTube", icon = "輸" },
  { class = "Chromium", instance = "calendar.google.com" , icon = "" },
  { class = "Chromium", instance = "drive.google.com" , icon = "" },
  { class = "Chromium", instance = "docs.google.com.*spreadsheets" , icon = "" },
  { class = "Chromium", instance = "docs.google.com.*slides" , icon = "" },
  { class = "Chromium", instance = "docs.google.com" , icon = "" },
  { class = "Chromium", instance = "photos.google.com" , icon = "" },
  { class = "Chromium", instance = "hangouts.google.com" , icon = "" },
  { class = "Chromium", instance = "meet.google.com" , icon = "" },
  { class = "Chromium", instance = "keep.google.com" , icon = "" },
  { class = "Chromium", instance = "maps.google.com", icon = "﫴" },
  { class = "Chromium", instance = "goo.gl__maps", icon = "﫴" },
  { class = "Chromium", instance = "www.gmail.com", icon = "" },
  { class = "Chromium", instance = "groups.google.com", icon = "" },

  { class = "Chromium", instance = "ilucca.net", icon = "" },
  { class = "Chromium", instance = "slack" , icon = "" },
  { class = "Chromium", instance = "app.spendesk.com", icon = "" },

  { class = "Chromium", instance = "amazon", icon = "" },
  { class = "Chromium", instance = "bankin", icon = "" },
  { class = "Chromium", instance = "dynalist.io", icon = "" },
  { class = "Chromium", instance = "heroku", icon = "" },
  { class = "Chromium", instance = "paypal", icon = "" },
  { class = "Chromium", instance = "trainline", icon = "" },
  { class = "Chromium", instance = "web.whatsapp.com", icon = "甆" },
  { class = "Chromium", instance = "woven.com", icon = "" },
  { class = "Chromium", instance = "www.deliveroo.fr", icon = "﫱" },
  { class = "Chromium", instance = "ubereats.com", icon = "" },
  { class = "Chromium", instance = "www.twitter.com", icon = "" },
  { class = "Chromium", name = "Twitter", icon = "" },
  { class = "Chromium", instance = "www.gettr.com", icon = "" },
  { class = "Chromium", instance = "www.exercism.io", icon = "" },
  { class = "Chromium", instance = "www.github.com", icon = "" },
  { class = "Chromium", instance = "trello.com", icon = "" },
  { class = "Chromium", instance = "app.productplan.com", icon = "" },
  { class = "Chromium", instance = "jobteaser.atlassian.net", icon = "" },
  { class = "Chromium", instance = "jobteaser.kanbantool.com", icon = "﵁" },
  { class = "Chromium", instance = "circleci.com", icon = "" },
  { class = "Chromium", instance = "miro.com", icon = "﵁" },
  { class = "Chromium", instance = "pragli.com", icon = "" },
  { class = "Chromium", instance = "metroretro.io", icon = "滛" },
  { class = "Chromium", instance = "pinterest.com", icon = "" },
  { class = "Chromium", instance = "citymapper.com", icon = "" },
  { class = "Chromium", instance = "hub.docker.com", icon = "" },
  { class = "Chromium", instance = "appsignal.com", icon = "" },
  { class = "Chromium", instance = "bugsnag.com", icon = "" },
  { class = "Chromium", instance = "datadoghq.com", icon = "" },
  { class = "Chromium", instance = "linkedin.com", icon = "" },
  { class = "Chromium", instance = "discord.com", icon = "" },
  { class = "Chromium", instance = "wallhaven.cc", icon = "" },
  { class = "Chromium", instance = "app.diagrams.net", icon = "" },
  { class = "Chromium", instance = "whimsical.co", icon = "" },
  { class = "Chromium", instance = "reddit.com", icon = "" },
  { class = "Chromium", instance = "rubygems", icon = "" },
  { class = "Chromium", instance = "pratebay", icon = "" },
  { class = "Chromium", instance = "hoogle", icon = "" },
  { class = "Chromium", instance = "docusign", icon = "" },
  { class = "Chromium", instance = "notion.so", icon = "" },

  { class = "Chromium", instance = "roll20.net", icon = "﫩" },

  { class = "kitty", name = "htop", icon = "" },
  { class = "kitty", name = "exercism", icon = "" },
  { class = "kitty", name = "git/dotfiles", icon = "" },
  { class = "kitty", name = "NVIM" , icon = "" },
  { class = "kitty", name = "vifm", icon = "" },
  { class = "kitty", name = "vpn", icon = "嬨" },
  { class = "kitty", name = "newsboat", icon = "" },

  { class = "Alacritty", name = "htop", icon = "" },
  { class = "Alacritty", name = "exercism", icon = "" },
  { class = "Alacritty", name = "git/dotfiles", icon = "" },
  { class = "Alacritty", name = "NVIM" , icon = "" },
  { class = "Alacritty", name = "vifm", icon = "" },
  { class = "Alacritty", name = "vpn", icon = "嬨" },

  { class = "Chromium", instance = "tryhackme.com", icon = "" },

  { class = "config", icon = "" },
  { class = "scratchpad", icon = "" },
  { class = "wiki", icon = "" },
  { class = "download", icon = "" },
  { class = "quake", icon = "" },
  { class = "man", icon = "" },

  { class = "taskwarrior", icon = "" },
  { class = "help", icon = "" },
  { class = "gtgf", icon = "" },

  { class = "Lxappearance", icon = "" },
  { class = "Thunar", icon = "" },
  { class = "Gimp", icon = "" },
  { class = "Viewnior", icon = "" },
  { class = "Sxiv", icon = "" },
  { class = "Flowblade", icon = "" },

  { class = "zoom", icon = "" },
  { class = "discord", icon = "" },

  { name = "yay", icon = "" },

  { name = "Document Scanner", icon = "ﮩ" },

  { class = "Signal", icon = "" },

  -- As the name does not imply, this if wonderdraft!
  { class = "Godot", icon = "" },
  { class = "dungeondraft.exe", icon = "" },
  { class = "Chromium", instance = "app.legendkeeper.com", icon = "" },
  { class = "Chromium", instance = "watabou.itch.io", icon = "" },
  { class = "Chromium", instance = "rolladvantage.com", icon = "" },

  { class = "Chromium", icon = "" },
  { class = "firefox", icon = "" },
  { class = "Cockatrice", icon = "" },
  { class = "RoomArranger", icon = "沈" },
  { class = "Luakit", icon = "" },
  { class = "nyxt", icon = "" },
  { class = "Steam", icon = "" },
  -- PlayOnLinux
  { class = "Mainwindow.py", icon = "" },
  { class = "Lutris", icon = "" },
  { class = "Wine", icon = "" },
  { class = "Zathura", icon = "" },
  { class = "kitty", icon = "" },
  { class = "Alacritty", icon = "" },
  { class = "mpv", icon = "" },
  { class = "vlc", icon = "嗢" },
  { class = "Vlc", icon = "嗢" },
  { class = "mixer", icon = "奔" },
  { class = "Gpick", icon = "" },
  { class = "Xephyr", icon = "" },
  { class = "Seahorse", icon = "" },
  { class = "Audacity", icon = "" },
}

local update_icon = function(tag)
  local iconset = {}

  for _, client in ipairs(tag:clients()) do
    local matched = false

    for i = 1, #rules do
      local rule = rules[i]
      local match = true
      local has_rule = false

      for _, key in ipairs({ "name", "instance", "class" }) do
        if rule[key] then
          has_rule = true
          match = match and client[key]:find(rule[key])
        end
      end

      if has_rule and match then
        matched = true
        iconset[rule.icon] = true
        break
      end
    end

    if not matched then
      iconset[""] = true
    end
  end

  local icons = {}
  for k,_ in pairs(iconset) do
    icons[#icons+1] = k
  end

  tag.name = table.concat(icons, " ")
end

local handle = function(object)
  local tag

  if type(object) == 'client' then
    tag = object.first_tag
  elseif type(object) == 'tag' then
    tag = object
  else
    return
  end

  update_icon(tag)
end

for _, signal in ipairs(client_signals) do
  client.connect_signal(signal, handle)
end

client.connect_signal("property::minimized", function(client)
  if client.name == "meet.google.com is sharing a window." then
    return
  end

  client.minimized = false
end)

awful.screen.connect_for_each_screen(function(screen)
  for _, signal in ipairs(tag_signals) do
    awful.tag.attached_connect_signal(screen, signal, handle)
  end
end)
