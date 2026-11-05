-- Merge queue: my pull requests in it (see ~/scripts/merge-queue; the others
-- are in widgets/pull_requests.lua). Polls the tracker for both.
-- Panel widget, see panel.lua: returns { widget, update }

local github = require('github')

return require('widgets.counter').make({
  script = 'merge-queue',
  signal = 'merge-queue::changed',
  app = 'merge-queue',
  icon = '',
  icon_size = 16,
  filter = ':queued',
  title = 'Merge queue',
  -- Fast while something is queued (it moves), slowly otherwise
  poll = { idle = 300, busy = 60 },

  describe = function(count)
    return count == 0 and 'Nothing queued'
        or ('%d pull request%s queued'):format(count, count > 1 and 's' or '')
  end,

  -- Green while one of mine is being tested in a merge group
  render = function(records, colors)
    ---@type boolean, string[]
    local testing, rows = false, {}
    for _, pull_request in ipairs(records) do
      if pull_request.kind == 'queued' then
        local state = pull_request.state
        testing = testing or state == 'AWAITING_CHECKS' or state == 'MERGEABLE'
        local seconds = tonumber(pull_request.time)
        table.insert(rows, ('<b>%4s</b>  %5s  %s %s <span fgalpha="60%%">(%s)</span>'):format(
          '#' .. pull_request.position, seconds and github.eta(seconds --[[@as integer]]) or '?',
          github.auto_mark(pull_request), github.pull_request(pull_request), pull_request.label))
      end
    end
    return { color = testing and colors.green.base or colors.fg.dim, count = #rows, rows = rows, busy = #rows > 0 }
  end,
})
