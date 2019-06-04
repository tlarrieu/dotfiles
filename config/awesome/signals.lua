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
  { class = "Chromium", instance = "drive.google.com" , icon = "" },
  { class = "Chromium", instance = "hangouts.google.com" , icon = "" },
  { class = "Chromium", instance = "maps.google.com", icon = "﫴" },
  { class = "Chromium", instance = "www.gmail.com", icon = "" },

  { class = "Chromium", instance = "ilucca.net", icon = "" },
  { class = "Chromium", instance = "slack" , icon = "" },
  { class = "Chromium", instance = "www.spendesk.com", icon = "" },

  { class = "Chromium", instance = "amazon", icon = "" },
  { class = "Chromium", instance = "bankin", icon = "" },
  { class = "Chromium", instance = "dynalist.io", icon = "" },
  { class = "Chromium", instance = "web.whatsapp.com" , icon = "" },
  { class = "Chromium", instance = "www.deliveroo.fr", icon = "﫱" },
  { class = "Chromium", instance = "www.exercism.io", icon = "" },
  { class = "Chromium", instance = "www.github.com", icon = "" },
  { class = "Chromium", instance = "www.trello.com", icon = "" },

  { class = "Chromium", instance = "01b4f52e1ce94237918c8a15e147a7da", icon = "" },
  { class = "Chromium", instance = "21211c4211c84ee8a9db873220e457b2", icon = "" },
  { class = "Chromium", instance = "2fd3c97e4ef64dcfb391ed2b348ef9f0", icon = "" },
  { class = "Chromium", instance = "324fe5ac916d4fb49d2fe8387600ed72", icon = "" },
  { class = "Chromium", instance = "40a05b9746904e04911db5346ee92a5d", icon = "" },
  { class = "Chromium", instance = "6a6882169a7249adbf321f897035c6e0", icon = "" },
  { class = "Chromium", instance = "77277bcb054647d9b9603c2d1b92f463", icon = "" },
  { class = "Chromium", instance = "802f37c764ef42b4bfae2fc2c3db0dc2", icon = "" },
  { class = "Chromium", instance = "91ae543e7efd461a89eb3b240230b6fd", icon = "" },
  { class = "Chromium", instance = "d06e31abdb7149528f3122151a13e6c2", icon = "" },
  { class = "Chromium", instance = "ea190b962a914cf49da1438c028e785a", icon = "" },

  { class = "kitty", name = "NVIM" , icon = "" },
  { class = "kitty", name = "ncpamixer" , icon = "奔" },
  { class = "kitty", name = "vifm", icon = "" },

  { class = "Chromium", icon = "" },
  { class = "Luakit", icon = "" },
  { class = "Steam", icon = "" },
  { class = "kitty", icon = "" },
  { class = "mpv", icon = "" },
}

local updateIcon = function(tag, client)
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

  updateIcon(tag, client)
end

for _, signal in ipairs(client_signals) do
  client.connect_signal(signal, handle)
end

awful.screen.connect_for_each_screen(function(screen)
  for _, signal in ipairs(tag_signals) do
    awful.tag.attached_connect_signal(screen, signal, handle)
  end
end)
