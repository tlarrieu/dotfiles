--- Refreshes the GitHub trackers (~/scripts/github-refresh) when leaving a
--- GitHub page (a browser-kiosk window: its instance starts with
--- github.com__), which is where threads get resolved, comments hidden,
--- reviews submitted. At most once every `gap` seconds: leaving one again
--- sooner refreshes once that time is up (one refresh for a burst of
--- back-and-forths).

local awful = require('awful')
local gears = require('gears')

local command = { os.getenv('HOME') .. '/scripts/github-refresh', 'merge-queue', 'review-queue' }
local gap = 30

local last = -math.huge

local do_refresh = function()
  last = os.time()
  awful.spawn(command, false)
end

local pending = gears.timer({ timeout = gap, single_shot = true, callback = do_refresh })

---@param c Client
local refresh = function(c)
  if not (c.instance and c.instance:find('^github%.com__')) or pending.started then return end
  local wait = last + gap - os.time()
  if wait <= 0 then
    do_refresh()
  else
    pending.timeout = wait
    pending:start()
  end
end

client.connect_signal('unfocus', refresh)
client.connect_signal('unmanage', refresh)
