
--[[
                                                  
     Licensed under GNU General Public License v2 
      * (c) 2016, Luke Bonham                     
                                                  
--]]

local read_pipe    = require("lain.helpers").read_pipe
local newtimer     = require("lain.helpers").newtimer
local wibox        = require("wibox")

local string       = { match  = string.match,
                       format = string.format }

local setmetatable = setmetatable

-- PulseAudio volume
-- lain.widgets.pulseaudio
local pulseaudio = {}

local function worker(args)
   local args        = args or {}
   local timeout     = args.timeout or 5
   local settings    = args.settings or function() end

   pulseaudio.cmd    = args.cmd or string.format("pacmd list-sinks | sed -n -e '0,/*/d' -e '/base volume/d' -e '/volume:/p' -e '/muted:/p'")
   pulseaudio.widget = wibox.widget.textbox('')

   function pulseaudio.update()
      local source = read_pipe("pactl get-default-source")
      local muted = read_pipe("pactl get-source-mute " .. source)
      local left = read_pipe("pactl get-source-volume " .. source .. " | sed 's/Volume: //' | head -n1 | awk -F', +' '{ print $1 }' | awk -F' / ' '{ print $2 }'")
      local right = read_pipe("pactl get-source-volume " .. source .. " | sed 's/Volume: //' | head -n1 | awk -F', +' '{ print $2 }' | awk -F' / ' '{ print $2 }'")

      volume_now = {}
      volume_now.left  = tonumber(string.match(left, "(%d+)%%"))
      volume_now.right = tonumber(string.match(right, "(%d+)%%"))
      volume_now.muted = string.match(muted, "Mute: (%S+)") == "no"

      widget = pulseaudio.widget
      settings(volume_now)
   end

   newtimer(string.format("pulseaudio-%s", timeout), timeout, pulseaudio.update)

   return setmetatable(pulseaudio, { __index = pulseaudio.widget })
end

return setmetatable(pulseaudio, { __call = function(_, ...) return worker(...) end })
