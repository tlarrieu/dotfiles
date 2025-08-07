vim.bo.expandtab = false
vim.bo.softtabstop = 2
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2

local runner = require('runner')
runner.default({ main = runner.term('python %') })
