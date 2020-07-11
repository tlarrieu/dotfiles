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
  { class = "Chromium", instance = "calendar.google.com" , icon = "" },
  { class = "Chromium", instance = "drive.google.com" , icon = "" },
  { class = "Chromium", instance = "docs.google.com.*spreadsheets" , icon = "離" },
  { class = "Chromium", instance = "docs.google.com" , icon = "" },
  { class = "Chromium", instance = "photos.google.com" , icon = "" },
  { class = "Chromium", instance = "hangouts.google.com" , icon = "" },
  { class = "Chromium", instance = "meet.google.com" , icon = "" },
  { class = "Chromium", instance = "keep.google.com" , icon = "ﯚ" },
  { class = "Chromium", instance = "maps.google.com", icon = "﫴" },
  { class = "Chromium", instance = "www.gmail.com", icon = "" },
  { class = "Chromium", name = "Google Sheets", icon = "離" },
  { class = "Chromium", name = "Google Docs", icon = "" },
  { class = "Chromium", name = "Google Photos", icon = "" },
  { class = "Chromium", name = "YouTube", icon = "" },
  { class = "Luakit", name = "YouTube", icon = "" },

  { class = "Chromium", instance = "ilucca.net", icon = "" },
  { class = "Chromium", instance = "slack" , icon = "" },
  { class = "Chromium", instance = "www.spendesk.com", icon = "" },

  { class = "Chromium", instance = "amazon", icon = "" },
  { class = "Chromium", instance = "bankin", icon = "" },
  { class = "Chromium", instance = "dynalist.io", icon = "" },
  { class = "Chromium", instance = "heroku", icon = "" },
  { class = "Chromium", instance = "paypal", icon = "" },
  { class = "Chromium", instance = "trainline", icon = "" },
  { class = "Chromium", instance = "web.whatsapp.com" , icon = "" },
  { class = "Chromium", instance = "woven.com", icon = "" },
  { class = "Chromium", instance = "www.deliveroo.fr", icon = "﫱" },
  { class = "Chromium", instance = "www.twitter.com", icon = "" },
  { class = "Chromium", instance = "www.exercism.io", icon = "" },
  { class = "Chromium", instance = "www.github.com", icon = "" },
  { class = "Chromium", instance = "www.trello.com", icon = "" },
  { class = "Chromium", instance = "trello.com", icon = "" },
  { class = "Chromium", instance = "app.productplan.com", icon = "" },
  { class = "Chromium", instance = "monday.com", icon = "" },
  { class = "Chromium", instance = "jobteaser.atlassian.net", icon = "" },
  { class = "Chromium", instance = "circleci.com", icon = "" },
  { class = "Chromium", instance = "miro.com", icon = "﵁" },
  { class = "Chromium", instance = "pragli.com", icon = "" },
  { class = "Chromium", instance = "metroretro.io", icon = "滛" },
  { class = "Chromium", instance = "pinterest.com", icon = "" },
  { class = "Chromium", instance = "citymapper.com", icon = "" },
  { class = "Chromium", instance = "hub.docker.com", icon = "" },
  { class = "Chromium", instance = "appsignal.com", icon = "勞" },

  { class = "Chromium", instance = "roll20.net", icon = "﫩" },
  { class = "Chromium", instance = "1BLpUgFZ7HXxhe9sbIL9KdwTvQkLwSPTjyQwzwY6f", icon = "" },

  { class = "Chromium", name = "Candidates", icon = "" },

  { class = "kitty", name = "NVIM" , icon = "" },
  { class = "kitty", name = "vifm", icon = "" },

  { class = "Thunar", icon = "" },
  { class = "Gimp", icon = "" },
  { class = "Flowblade", icon = "﨣" },

  { class = "zoom", icon = "" },

  { name = "Document Scanner", icon = "ﮩ" },

  -- As the name does not imply, this if wonderdraft!
  { class = "Godot", icon = "" },
  { class = "Chromium", instance = "app.legendkeeper.com", icon = "" },
  { class = "Chromium", instance = "rolladvantage.com", icon = "" },

  { class = "Chromium", icon = "" },
  { class = "Cockatrice", icon = "﬷" },
  { class = "Luakit", icon = "" },
  { class = "Steam", icon = "" },
  { class = "Wine", icon = "" },
  { class = "Zathura", icon = "" },
  { class = "discord", icon = "" },
  { class = "kitty", icon = "" },
  { class = "mpv", icon = "" },
  { class = "mixer", icon = "奔" },
}

local update_icon = function(tag, client)
  if client then
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
        tag.name = rule.icon
        return
      end
    end
  end

  tag.name = ""
end

local handle = function(object)
  local tag, client

  if type(object) == 'client' then
    tag = object.first_tag
    client = object
  elseif type(object) == 'tag' then
    tag = object
    client = object:clients()[1]
  else
    return
  end

  update_icon(tag, client)
end

for _, signal in ipairs(client_signals) do
  client.connect_signal(signal, handle)
end

awful.screen.connect_for_each_screen(function(screen)
  for _, signal in ipairs(tag_signals) do
    awful.tag.attached_connect_signal(screen, signal, handle)
  end
end)
