-- Deploys: my pull requests merged, not in production yet (see
-- ~/scripts/merge-queue). Doesn't poll: widgets/merge_queue.lua does, and the
-- tracker's signal repaints both.
-- Panel widget, see panel.lua: returns { widget, update }

local github = require('github')

return require('widgets.counter').make({
  script = 'merge-queue',
  signal = 'merge-queue::changed',
  app = 'merge-queue',
  icon = '󱓞',
  icon_size = 16,
  filter = ':deploying',
  title = 'Deploys',
  quiet_when_unwatched = true, -- the merge queue widget already says so

  describe = function(count)
    return count == 0 and 'Nothing waiting for a deploy'
        or ('%d pull request%s waiting for a deploy'):format(count, count > 1 and 's' or '')
  end,

  -- Blue while a deploy run ships one
  render = function(records, colors)
    ---@type integer, boolean, string[]
    local now, shipping, rows = os.time(), false, {}
    for _, pull_request in ipairs(records) do
      if pull_request.kind == 'deploying' then
        shipping = shipping or pull_request.state == 'DEPLOYING'
        local merged = tonumber(pull_request.time)
        table.insert(rows, ('<b>%9s</b>  %5s  %s'):format(
          pull_request.label, merged and github.ago(now - merged --[[@as integer]]) or '',
          github.pull_request(pull_request)))
      end
    end
    return { color = shipping and colors.blue.base or colors.fg.dim, count = #rows, rows = rows }
  end,
})
