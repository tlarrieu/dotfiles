-- Local work: commits to push, and the worktrees stopped agents left behind
-- (see ~/scripts/local-work). Local only: polls often, at no cost.
-- Panel widget, see panel.lua: returns { widget, update }

local gears = require('gears')
local github = require('github')

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
    ---@type integer, string[]
    local now, rows = os.time(), {}
    for _, record in ipairs(records) do
      if pending(record) then
        local where = record.worktree ~= '-' and record.worktree or record.clone
        local what = {}
        local ahead, changes = tonumber(record.ahead) or 0, tonumber(record.changes) or 0
        if ahead > 0 then table.insert(what, ('󰅧 %d'):format(ahead)) end
        if changes > 0 then table.insert(what, ('󱇧 %d'):format(changes)) end
        if record.kept == 'yes' then table.insert(what, 'kept') end
        table.insert(rows, ('<b>%5s</b>  %s  %s <span fgalpha="60%%">(%s)</span>'):format(
          github.ago(now - (tonumber(record.time) or now)),
          gears.string.xml_escape(record.branch ~= '-' and record.branch or 'detached HEAD'),
          table.concat(what, ' '),
          gears.string.xml_escape((where:gsub('^.*/', '')))))
      end
    end
    return {
      color = #rows > 0 and colors.yellow.base or colors.fg.dim,
      count = #rows,
      rows = rows,
    }
  end,
})
