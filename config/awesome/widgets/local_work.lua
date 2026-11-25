-- Local work: commits to push, and the worktrees stopped agents left behind
-- (see ~/scripts/local-work). Local only: polls often, at no cost.
-- Panel widget, see panel.lua: returns { widget, update }

-- What needs me: commits to push (a branch's, or a detached worktree's, on no
-- branch), or a stopped agent's worktree kept for its changes. Changes in a
-- worktree an agent or I still work in don't count
---@param record Record A local-work record
---@return boolean
local pending = function(record)
  return (tonumber(record.ahead) or 0) > 0 or record.kept == 'yes'
end

return require('widgets.counter').make({
  script = 'local-work',
  signal = 'local-work::changed',
  app = 'local-work',
  icon = '󰅧',
  icon_size = 16,
  filter = ':local',
  title = 'Local work',
  quiet_when_unwatched = true, -- the merge queue widget already says so
  poll = { idle = 60 },

  describe = function(count)
    return count == 0 and 'Nothing to push, no worktree left behind'
        or ('%d branch%s or worktree%s to deal with'):format(count, count > 1 and 'es' or '', count > 1 and 's' or '')
  end,

  render = function(records, colors)
    local count = 0
    for _, record in ipairs(records) do
      if pending(record) then count = count + 1 end
    end
    return { color = count > 0 and colors.yellow.base or colors.fg.dim, count = count }
  end,
})
