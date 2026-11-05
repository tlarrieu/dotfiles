--- Records: what the GitHub trackers and claude-agent-list print (see
--- ~/scripts/lib/records.sh). Tab separated lines under a header naming their
--- fields, "#<field>\t<field>…": read by name, so adding a field only touches
--- the script printing them.

local M = {}

---@alias Record table<string, string> Field name => value

-- The fields of a tab separated line, empty ones included
---@param line string
---@return string[]
local split = function(line)
  local fields = {}
  for field in (line .. '\t'):gmatch('([^\t]*)\t') do table.insert(fields, field) end
  return fields
end

-- The records a script printed, keyed by the names of its header. Lines
-- before the header, and lines with no tab (failure messages), are skipped
---@param out string
---@return Record[]
M.parse = function(out)
  ---@type string[]?, Record[]
  local names, records = nil, {}
  for line in out:gmatch('[^\n]+') do
    if names then
      if line:find('\t', 1, true) then
        local values, record = split(line), {}
        for i, name in ipairs(names) do record[name] = values[i] end
        table.insert(records, record)
      end
    elseif line:sub(1, 1) == '#' then
      names = split(line:sub(2))
    end
  end
  return records
end

return M
