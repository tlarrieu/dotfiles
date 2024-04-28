local awful = require('awful')

local _M = {}

local git_pull = function(path)
  awful.spawn.with_shell('cd ' .. path .. ' && git pull')
end

_M.boot = function ()
  local path = "/tmp/awesome_started"
  local f = io.open(path, "r")

  if not f then
    git_pull('~/.password-store')
    git_pull('~/.neorg')

    local apps = {
      'gtd',
      'gmail',
      'calendar',
      'steam',
    }

    for _, app in ipairs(apps) do
      awful.spawn.spawn(app)
    end

    io.open(path, "w"):close()
  else
    f:close()
  end
end

return _M
