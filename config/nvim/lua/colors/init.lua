local M = {}

M.palettes = require('colors.palettes')
M.theme = require('colors.theme')

M.palette = function()
  if not vim.g.colors_name then return end

  local ok, palette = pcall(require, 'nightfox.palette')
  if ok then return palette.load(vim.g.colors_name) end
end

return M
