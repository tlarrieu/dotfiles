-- Merge queue: my pull requests in it (see ~/scripts/merge-queue; the others
-- are in widgets/pull_requests.lua). Polls the tracker for both.
-- Panel widget, see panel.lua: returns { widget, update }

return require('widgets.counter').make({
  script = 'merge-queue',
  signal = 'merge-queue::changed',
  app = 'merge-queue',
  icon = '',
  icon_size = 16,
  filter = ':queued',
  title = 'Merge queue',
  -- Fast while something is queued or waits for its deploy (it moves; a
  -- deploy run takes a few minutes), or while an open one's checks or a
  -- bot's review run (after a push, say: they end within minutes), slowly
  -- otherwise
  poll = { idle = 300, busy = 60 },

  describe = function(count)
    return count == 0 and 'Nothing queued'
        or ('%d pull request%s queued'):format(count, count > 1 and 's' or '')
  end,

  -- Green while one of mine is being tested in a merge group
  render = function(records, colors)
    ---@type boolean, boolean, boolean, integer
    local testing, deploying, running, count = false, false, false, 0
    for _, pull_request in ipairs(records) do
      deploying = deploying or pull_request.kind == 'deploying'
      running = running or ((pull_request.kind == 'other' or pull_request.kind == 'ready')
        and (pull_request.ci == 'PENDING' or pull_request.review == 'BOT_REVIEWING'))
      if pull_request.kind == 'queued' then
        count = count + 1
        local state = pull_request.state
        testing = testing or state == 'AWAITING_CHECKS' or state == 'MERGEABLE'
      end
    end
    return { color = testing and colors.green.base or colors.fg.dim, count = count, busy = count > 0 or deploying or running }
  end,
})
