-- Reviews: pull requests waiting on me (see ~/scripts/review-queue)
-- Panel widget, see panel.lua: returns { widget, update }

local gears = require('gears')
local github = require('github')

-- Ages (seconds) from which the oldest request turns the widget yellow, then red
local warn_after, alert_after = 4 * 3600, 24 * 3600

return require('widgets.counter').make({
  script = 'review-queue',
  signal = 'reviews::changed',
  app = 'reviews',
  icon = '',
  icon_size = 19,
  filter = ':review',
  title = 'Reviews',
  poll = { idle = 300 },

  describe = function(count)
    return count == 0 and 'Nothing waiting on your review'
        or ('%d review%s waiting on you'):format(count, count > 1 and 's' or '')
  end,

  render = function(records, colors)
    ---@type integer, integer, string[]
    local now, oldest, rows = os.time(), 0, {}
    for _, review in ipairs(records) do
      local waited = now - (tonumber(review.at) or now)
      oldest = math.max(oldest, waited)
      table.insert(rows, ('<b>%5s</b>  %s <span fgalpha="60%%">(%s)</span>'):format(
        github.ago(waited), github.pull_request(review), gears.string.xml_escape(review.author)))
    end
    return {
      color = oldest >= alert_after and colors.red.base or oldest >= warn_after and colors.yellow.base or colors.fg.dim,
      count = #rows,
      rows = rows,
    }
  end,
})
