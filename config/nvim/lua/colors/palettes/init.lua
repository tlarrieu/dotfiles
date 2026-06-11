local M = {}

M.load = function(mode)
  return loadfile(vim.fs.joinpath(
    vim.fn.stdpath('config'),
    'lua',
    'colors',
    'palettes',
    mode .. '.lua'
  ))()
end

return M
