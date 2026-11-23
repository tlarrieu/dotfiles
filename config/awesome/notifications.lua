-- Notifications, drawn and placed by us (naughty's `request::display`) rather than by naughty's legacy layout:
-- that one pads every screen edge alike, and naughty's newer box layout ties the vertical edge padding to the spacing
-- between notifications.
--
-- Looks are the legacy ones: icon, then the bold title over the message, then the actions, all inside
-- beautiful.notification_margin.
--
-- Clicks tell D-Bus senders (`notify-send --wait`) one thing each: left click the default action, an action its own,
-- right click nothing. Left alone, naughty reports a user dismissal as the default action too, so that right click
-- would open things, and actions would come followed by the default one.

local awful = require('awful')
local beautiful = require('beautiful')
local naughty = require('naughty')
local wibox = require('wibox')

local escape = function(text) return (text:gsub('[<>&]', { ['<'] = '&lt;', ['>'] = '&gt;', ['&'] = '&amp;' })) end

-- Same as the legacy layout: senders may use markup (and escape their text accordingly), the title can't
local render_text = function(textbox, n)
  local title = escape(n.title or '')
  local message = n.message or ''
  local join = function(body)
    local parts = {}
    if title ~= '' then table.insert(parts, '<b>' .. title .. '</b>') end
    if body ~= '' then table.insert(parts, body) end
    return table.concat(parts, '\n')
  end
  if not textbox:set_markup_silently(join((message:gsub('<br.*>', '\n')))) then
    if not textbox:set_markup_silently(join(escape(message))) then
      textbox:set_text(table.concat({ n.title or '', message }, '\n'))
    end
  end
end

local closed = naughty.notification_closed_reason

-- Reported as the default action to D-Bus senders (see sendNotificationClosed in naughty/dbus.lua)
local open = function(n) n:destroy(closed.dismissed_by_user) end
local dismiss = function(n) n:destroy(closed.dismissed_by_command) end

-- Invoking an action dismisses the notification (by the user, so as the default action too) unless resident
local invoke = function(n, action)
  local resident = n.resident
  n.resident = true
  action:invoke(n)
  n.resident = resident
  dismiss(n)
end

local content = function(n)
  local margin = n.margin or beautiful.notification_margin or 4
  local font = n.font or beautiful.notification_font or beautiful.font

  local textbox = wibox.widget({ valign = 'center', font = font, widget = wibox.widget.textbox })
  render_text(textbox, n)
  n:connect_signal('property::title', function() render_text(textbox, n) end)
  n:connect_signal('property::message', function() render_text(textbox, n) end)

  local body = wibox.widget({
    {
      { naughty.widget.icon({ notification = n }), valign = 'top', widget = wibox.container.place },
      margins = margin,
      draw_empty = false, -- no room taken without an icon
      widget = wibox.container.margin,
    },
    { textbox, margins = margin, widget = wibox.container.margin },
    layout = wibox.layout.fixed.horizontal,
  })
  body.buttons = {
    awful.button({}, 1, nil, function() open(n) end),
    awful.button({}, 3, nil, function() dismiss(n) end),
  }

  local layout = wibox.widget({ body, layout = wibox.layout.fixed.vertical })
  for _, action in ipairs(n.actions or {}) do
    local run = function() invoke(n, action) end
    layout:add(wibox.widget({
      {
        markup = ('☛ <u>%s</u>'):format(escape(action.name)),
        valign = 'center',
        font = font,
        widget = wibox.widget.textbox,
      },
      margins = margin,
      buttons = { awful.button({}, 1, run), awful.button({}, 3, run) },
      widget = wibox.container.margin,
    }))
  end
  return layout
end

return {
  -- padding: distance to the screen's edges, by side ({ top, bottom, left, right }): base for every position,
  -- overridden by position (e.g. bottom_right = { bottom = 12 }); spacing: between notifications
  config = function(options)
    local spacing = options.spacing
    local padding = function(position)
      return setmetatable(options.padding[position] or {}, { __index = options.padding.base })
    end

    -- Shown popups, per screen then position, from the edge inwards
    local stacks = setmetatable({}, { __mode = 'k' })
    local stack = function(s, position)
      stacks[s] = stacks[s] or {}
      stacks[s][position] = stacks[s][position] or {}
      return stacks[s][position]
    end

    local restack = function(s, position)
      if not s.valid then return end
      local area = s.workarea
      local pad = padding(position)
      local offset = 0
      for _, popup in ipairs(stack(s, position)) do
        local border = 2 * (popup.border_width or 0)
        local width, height = popup.width + border, popup.height + border
        local x
        if position:match('left') then
          x = area.x + pad.left
        elseif position:match('right') then
          x = area.x + area.width - width - pad.right
        else
          x = area.x + math.floor((area.width - width) / 2)
        end
        local y = position:match('top')
            and area.y + pad.top + offset
            or area.y + area.height - pad.bottom - offset - height
        if popup.x ~= x or popup.y ~= y then popup:geometry({ x = x, y = y }) end
        offset = offset + height + spacing
      end
    end

    naughty.connect_signal('request::display', function(n)
      local s = n.screen or awful.screen.focused()
      local position = n.position or 'top_right'
      local popup = awful.popup({
        type = 'notification',
        ontop = true,
        visible = false,
        screen = s,
        placement = false, -- we place it ourselves
        maximum_width = n.max_width or beautiful.notification_max_width,
        bg = n.bg or beautiful.notification_bg,
        fg = n.fg or beautiful.notification_fg,
        border_width = n.border_width or beautiful.notification_border_width or 0,
        border_color = n.border_color or beautiful.notification_border_color,
        shape = n.shape or beautiful.notification_shape,
        opacity = n.opacity,
        widget = content(n),
      })

      table.insert(stack(s, position), popup)
      -- Resized (its text changed, e.g. replaced through its id), or another one went away
      popup:connect_signal('property::width', function() restack(s, position) end)
      popup:connect_signal('property::height', function() restack(s, position) end)

      n:connect_signal('destroyed', function()
        popup.visible = false
        local popups = stack(s, position)
        for i, p in ipairs(popups) do
          if p == popup then
            table.remove(popups, i)
            break
          end
        end
        restack(s, position)
      end)

      popup:_apply_size_now()
      restack(s, position)
      popup.visible = true
    end)
  end,
}
