-- Pull requests: mine outside the merge queue (drafts, blocked, ready to
-- enqueue; see ~/scripts/merge-queue). Doesn't poll: widgets/merge_queue.lua
-- does, and the tracker's signal repaints both.
-- Panel widget, see panel.lua: returns { widget, update }

local github = require('github')

---@alias Urgency 'mine'|'ready'|'waiting' Needs me / to enqueue / on others (or a draft)

-- Whether what blocks a pull request is on me (the others, drafts included,
-- wait on someone else); merge-queue labels them
---@type table<string, Urgency>
local urgencies = {
  CONFLICT = 'mine',
  CHECKS_FAILING = 'mine',
  CHANGES_REQUESTED = 'mine',
  READY = 'ready',
}

return require('widgets.counter').make({
  script = 'merge-queue',
  signal = 'merge-queue::changed',
  app = 'merge-queue',
  icon = '󰓂',
  icon_size = 16,
  filter = ':open',
  title = 'Pull requests',
  quiet_when_unwatched = true, -- the merge queue widget already says so

  describe = function(count)
    return count == 0 and 'No open pull request outside the merge queue'
        or ('%d open pull request%s outside the merge queue'):format(count, count > 1 and 's' or '')
  end,

  -- Red when one needs me, yellow when one is ready to enqueue. In
  -- rofi-github's order: those with auto-merge on (on their way) last
  render = function(records, colors)
    ---@type integer, table<Urgency, boolean>, string[], string[]
    local now, found, rows, on_their_way = os.time(), {}, {}, {}
    for _, pull_request in ipairs(records) do
      if pull_request.kind ~= 'queued' then
        local urgency = urgencies[pull_request.state] or 'waiting'
        local auto = pull_request.auto == 'auto'
        -- Ready with auto-merge on: GitHub enqueues it, nothing for me to do
        found[(urgency == 'ready' and auto) and 'waiting' or urgency] = true
        local since = tonumber(pull_request.time)
        table.insert(auto and on_their_way or rows, ('<b>%12s</b>  %5s %s %s'):format(
          pull_request.label, since and github.ago(now - since --[[@as integer]]) or '',
          github.auto_mark(pull_request), github.pull_request(pull_request)))
      end
    end
    for _, row in ipairs(on_their_way) do table.insert(rows, row) end
    return {
      color = found.mine and colors.red.base or found.ready and colors.yellow.base or colors.fg.dim,
      count = #rows,
      rows = rows,
    }
  end,
})
