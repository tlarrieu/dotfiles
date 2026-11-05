--- How the panel shows the GitHub trackers' records (~/scripts/review-queue
--- and merge-queue, read with records.lua).

local gears = require('gears')

local M = {}

-- A pull request in a tooltip: name#number  title (repository owner left
-- out), escaped for markup
---@param record Record With repo, number and title
---@return string
M.pull_request = function(record)
  return ('%s#%s  %s'):format(gears.string.xml_escape((record.repo:gsub('^.*/', ''))), record.number,
    gears.string.xml_escape(record.title))
end

-- A merge glyph when auto-merge is on, a space otherwise (the glyph takes
-- one cell, like a space, so that the rows stay aligned)
---@param record Record With auto ('auto' or '-')
---@return string
M.auto_mark = function(record) return record.auto == 'auto' and '󰘬' or ' ' end

-- Time since something: 42m, 5h, 1d3h (mirrors ago in ~/scripts/lib/github.sh)
---@param seconds integer
---@return string
M.ago = function(seconds)
  if seconds < 3600 then return math.floor(seconds / 60) .. 'm' end
  if seconds < 86400 then return math.floor(seconds / 3600) .. 'h' end
  return ('%dd%dh'):format(math.floor(seconds / 86400), math.floor(seconds % 86400 / 3600))
end

-- Time left: 4m, 1h26 (minutes rounded up, never "60m"; mirrors eta in
-- ~/scripts/lib/github.sh)
---@param seconds integer
---@return string
M.eta = function(seconds)
  local minutes = math.ceil(seconds / 60)
  if minutes < 60 then return minutes .. 'm' end
  return ('%dh%02d'):format(math.floor(minutes / 60), minutes % 60)
end

return M
