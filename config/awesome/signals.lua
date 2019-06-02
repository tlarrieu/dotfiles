local awful = require("awful")
local beautiful = require("beautiful")

client.connect_signal("focus", function(client)
  client.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(client)
  client.border_color = beautiful.border_normal
end)

client.connect_signal("request::activate", function(client, context)
  if context == "mouse_click" or context == "ewmh" then return end

  local geo = client:geometry()
  mouse.coords {
    x = geo.x + geo.width / 2,
    y = geo.y + geo.height / 2
  }
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
  { class = "Chromium", instance = "maps.google.com", icon = "﫴" },
  { class = "Chromium", instance = "drive.google.com" , icon = "" },
  { class = "Chromium", instance = "hangouts.google.com" , icon = "" },
  { class = "Chromium", instance = "www.gmail.com", icon = "" },

  { class = "Chromium", instance = "ilucca.net", icon = "" },
  { class = "Chromium", instance = "www.spendesk.com", icon = "" },
  { class = "Chromium", instance = "slack" , icon = "" },

  { class = "Chromium", instance = "amazon", icon = "" },
  { class = "Chromium", instance = "bankin", icon = "" },
  { class = "Chromium", instance = "dynalist.io", icon = "" },
  { class = "Chromium", instance = "www.github.com", icon = "" },
  { class = "Chromium", instance = "www.trello.com", icon = "" },
  { class = "Chromium", instance = "web.whatsapp.com" , icon = "" },

  { class = "kitty", name = "NVIM" , icon = "" },
  { class = "kitty", name = "mpv", icon = "" },
  { class = "kitty", name = "Tasks", icon = "" },
  { class = "kitty", name = "ncpamixer" , icon = "奔" },

  { class = "Chromium", icon = "" },
  { class = "Luakit", icon = "" },
  { class = "kitty", icon = "" },
  { class = "Steam", icon = "" },
}

local handle = function(tag, client)
  if client then
    for _, rule in ipairs(rules) do
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

for _, signal in ipairs(client_signals) do
  client.connect_signal(
    signal,
    function(client) handle(client.first_tag, client) end
  )
end

awful.screen.connect_for_each_screen(function(screen)
  for _, signal in ipairs(tag_signals) do
    awful.tag.attached_connect_signal(
      screen,
      signal,
      function(tag) handle(tag, tag:clients()[1]) end
    )
  end
end)
