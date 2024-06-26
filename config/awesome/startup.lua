local awful = require('awful')

local _M = {}

local git_pull = function(path)
  awful.spawn.with_shell('cd ' .. path .. ' && git pull')
end

_M.boot = function ()
  local path = '/tmp/awesome_started'
  local f = io.open(path, 'r')

  awful.spawn.with_shell('~/.fehbg')

  if not f then
    git_pull('~/.password-store')
    git_pull('~/.neorg')

    local apps = {
      'gmail',
      'calendar',
    }

    for _, app in ipairs(apps) do
      awful.spawn.spawn(app)
    end

    -- NOTE: Disable screen saving / blanking
    awful.spawn.with_shell('xset s off -dpms')

    io.open(path, 'w'):close()
  else
    f:close()
  end
end

return _M
