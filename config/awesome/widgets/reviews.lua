-- Reviews: pull requests waiting on me (see ~/scripts/review-queue), not
-- those requested from my teams only (rofi-github lists them)
-- Panel widget, see panel.lua: returns { widget, update }

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
    ---@type integer, integer, integer
    local now, oldest, count = os.time(), 0, 0
    for _, review in ipairs(records) do
      if (review.team or '-') == '-' then
        count = count + 1
        oldest = math.max(oldest, now - (tonumber(review.at) or now))
      end
    end
    return {
      color = oldest >= alert_after and colors.red.base or oldest >= warn_after and colors.yellow.base or colors.fg.dim,
      count = count,
    }
  end,
})
