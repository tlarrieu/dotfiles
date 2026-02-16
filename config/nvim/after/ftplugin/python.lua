vim.bo.softtabstop = 4
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

local runner = require('runner')
runner.default({ main = runner.term('python %') })
