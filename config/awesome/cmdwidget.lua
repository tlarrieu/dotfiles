local newtimer = require("lain.helpers").newtimer
local read_pipe = require("lain.helpers").read_pipe
local util = require("lain.util")

local beautiful = require("beautiful")

local wibox = require("wibox")

local setmetatable = setmetatable

local function worker(args)
  local base     = {}
  local opts     = args or {}
  local timeout  = opts.timeout or 5
  local cmd      = opts.cmd or ""
  local font     = opts.font or beautiful.font
  local color    = opts.color or function() end
  local text     = opts.text or function () end

  base.widget = wibox.widget({
    widget = wibox.widget.textbox,
    font = font
  })

  function base.update()
    local output = read_pipe(cmd)
    if output ~= base.prev then
      base.prev = output
      local markup = util.markup(
        color(output) or beautiful.colors.foreground,
        text(output)
      )
      base.widget:set_markup(markup)
    end
  end

  newtimer(cmd, timeout, base.update)

  return setmetatable(base, { __index = base.widget })
end

return setmetatable({}, { __call = function(_, ...) return worker(...) end })
