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
  "unmanage",
  "manage",
  "focus"
}
local tag_signals = { "tagged", "untagged" }

local rules = {
  { name = "Agenda" , icon = "" },
  { name = "Google Agenda" , icon = "" },
  { name = "Google Maps", icon = "﫴" },
  { name = "Google Drive" , icon = "" },
  { name = "Google Hangouts" , icon = "" },
  { name = "Gmail", icon = "" },
  { name = "Messagerie JobTeaser", icon = "" },

  { name = "Cleemy", icon = "" },
  { name = "Figgo", icon = "" },
  { name = "Lucca", icon = "" },
  { name = "Pagga", icon = "" },

  { name = "Amazon", icon = "" },
  { name = "Bankin", icon = "" },
  { name = "Banque", icon = "" },
  { name = "Dynalist", icon = "" },
  { name = "NVIM" , icon = "" },
  { name = "Slack" , icon = "" },
  { name = "Spendesk", icon = "" },
  { name = "Tasks", icon = "" },
  { name = "Twitter", icon = "" },
  { name = "WhatsApp" , icon = "" },
  { name = "mpv", icon = "" },
  { name = "ncpamixer" , icon = "奔" },

  { class = "Chromium", icon = "" },
  { class = "Luakit", icon = "" },
  { class = "kitty", icon = "" },
  { class = "Steam", icon = "" },
}

local handle = function(tag, client)
  if client then
    for _, rule in ipairs(rules) do
      local match = false

      if rule.name and rule.class then
        match = client.name:find(rule.name) and client.class == rule.class
      elseif rule.name then
        match = client.name:find(rule.name)
      elseif rule.class then
        match = client.class == rule.class
      end

      if match then
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
