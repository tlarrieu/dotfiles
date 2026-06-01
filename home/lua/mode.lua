local M = {}

M.current = function()
  local output = io.popen([[
      gsettings get org.gnome.desktop.interface color-scheme |
        grep -Eo "light|dark"
    ]])
  local mode = nil
  if output then
    mode = output:read('*a'):gsub('%s+', '')
    if mode ~= 'light' and mode ~= 'dark' then mode = 'light' end
    output:close()
  end

  return mode or 'light'
end

return M
