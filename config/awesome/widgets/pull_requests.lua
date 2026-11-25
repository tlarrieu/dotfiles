-- Pull requests: mine outside the merge queue (drafts, blocked, ready to
-- enqueue; see ~/scripts/merge-queue). Doesn't poll: widgets/merge_queue.lua
-- does, and the tracker's signal repaints both.
-- Panel widget, see panel.lua: returns { widget, update }

---@alias Urgency 'mine'|'ready'|'waiting' Needs me / to enqueue / on others (or a draft)

-- Whether what blocks a pull request is on me (the others, drafts included,
-- wait on someone else); merge-queue's states
---@type table<string, Urgency>
local urgencies = {
  CONFLICT = 'mine',
  CHECKS_FAILING = 'mine',
  CHANGES_REQUESTED = 'mine',
  BOT_REVIEW_FAILED = 'mine',
  NO_REVIEWER = 'mine', -- bots only: someone to ask
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

  -- Red when one needs me, yellow when one is ready to enqueue
  render = function(records, colors)
    ---@type table<Urgency, boolean>, integer
    local found, count = {}, 0
    for _, pull_request in ipairs(records) do
      if pull_request.kind == 'other' or pull_request.kind == 'ready' then
        count = count + 1
        local urgency = urgencies[pull_request.state] or 'waiting'
        -- Ready with auto-merge on: GitHub enqueues it, nothing for me to do
        found[(urgency == 'ready' and pull_request.auto == 'auto') and 'waiting' or urgency] = true
      end
    end
    return {
      color = found.mine and colors.red.base or found.ready and colors.yellow.base or colors.fg.dim,
      count = count,
    }
  end,
})
