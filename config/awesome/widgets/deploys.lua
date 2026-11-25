-- Deploys: my pull requests merged, not in production yet (see
-- ~/scripts/merge-queue). Doesn't poll: widgets/merge_queue.lua does, and the
-- tracker's signal repaints both.
-- Panel widget, see panel.lua: returns { widget, update }

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
    ---@type boolean, integer
    local shipping, count = false, 0
    for _, pull_request in ipairs(records) do
      if pull_request.kind == 'deploying' then
        count = count + 1
        shipping = shipping or pull_request.state == 'DEPLOYING'
      end
    end
    return { color = shipping and colors.blue.base or colors.fg.dim, count = count }
  end,
})
