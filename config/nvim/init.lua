-- Send all print statements as notifications
print = function(...)
  local args = {}
  for _, arg in ipairs({ ... }) do table.insert(args, tostring(arg)) end
  vim.notify(table.concat(args, ' '), vim.log.levels.DEBUG)
end

require('config.options')
require('plugins')
require('config.filetypes')
require('config.keymaps')
require('config.abbrev')
require('config.autocmd')
