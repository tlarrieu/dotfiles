vim.pack.add({ 'https://github.com/gaodean/autolist.nvim' }, { confirm = false })
local autolist = require('autolist')

autolist.setup()

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'gitcommit', 'text' },
  callback = function()
    vim.keymap.set('i', '<c-t>', '<c-t><cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('i', '<c-d>', '<c-d><cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('i', '<CR>', '<CR><cmd>AutolistNewBullet<cr>', { buffer = true })
    vim.keymap.set('n', 'o', 'o<cmd>AutolistNewBullet<cr>', { buffer = true })
    vim.keymap.set('n', '<leader>x', '<cmd>AutolistToggleCheckbox<cr>', { buffer = true })
    vim.keymap.set('n', '<C-r>', '<cmd>AutolistRecalculate<cr>', { buffer = true })

    -- cycle list types with dot-repeat
    vim.keymap.set('n', 'gs', autolist.cycle_next_dr, { expr = true, buffer = true })
    vim.keymap.set('n', 'gS', autolist.cycle_prev_dr, { expr = true, buffer = true })

    -- functions to recalculate list on edit
    vim.keymap.set('n', '>>', '>><cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('n', '<<', '<<<cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('n', 'dd', 'dd<cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('v', 'd', 'd<cmd>AutolistRecalculate<cr>', { buffer = true })
  end,
})
