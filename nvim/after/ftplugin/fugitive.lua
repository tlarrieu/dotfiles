local runner = require('runner')
runner.default({ alt = runner.exec('Git push<bar>Git') })

vim.keymap.set('n', 'k', '(', { remap = true, buffer = true })
vim.keymap.set('n', 'j', ')', { remap = true, buffer = true })
