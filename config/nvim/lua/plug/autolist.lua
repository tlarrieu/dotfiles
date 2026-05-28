vim.pack.add({ 'https://github.com/gaodean/autolist.nvim' }, { confirm = false })
local autolist = require('autolist')

local list_patterns = {
  unordered = '[-+*]', -- - + *
  digit = '%d+[.)]',   -- 1. 2. 3.
  ascii = '%a[.)]',    -- a) b) c)
  roman = '%u*[.)]',   -- I. II. III.
}

local lists = {
  list_patterns.unordered,
  list_patterns.digit,
  list_patterns.ascii,
  list_patterns.roman,
}

autolist.setup({
  colon = {            -- if a line ends in a colon
    indent = true,     -- if in list and line ends in `:` then create list
    indent_raw = true, -- above, but doesn't need to be in a list to work
    preferred = '-',   -- what the new list starts with (can be `1.` etc)
  },
  lists = {
    markdown = lists,
    gitcommit = lists,
    text = lists,
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'gitcommit', 'text' },
  callback = function()
    vim.keymap.set('i', '<c-t>', '<c-t><cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('i', '<c-d>', '<c-d><cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('i', '<cr>', '<CR><cmd>AutolistNewBullet<cr>', { buffer = true })
    vim.keymap.set('n', '<c-cr>', 'o', { buffer = true })
    vim.keymap.set('i', '<c-cr>', '<c-o>o', { buffer = true })
    vim.keymap.set('n', 'o', 'o<cmd>AutolistNewBullet<cr>', { buffer = true })
    vim.keymap.set('n', '<leader>x', '<cmd>AutolistToggleCheckbox<cr>', { buffer = true })
    vim.keymap.set('n', '<c-r>', '<cmd>AutolistRecalculate<cr>', { buffer = true })

    -- cycle list types with dot-repeat
    vim.keymap.set('n', 'gs', autolist.cycle_next_dr, { expr = true, buffer = true })
    vim.keymap.set('n', 'gS', autolist.cycle_prev_dr, { expr = true, buffer = true })

    -- functions to recalculate list on edit
    vim.keymap.set('n', '>>', '>><cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('n', '<<', '<<<cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('x', '3', '><cmd>AutolistRecalculate<cr>gv', { buffer = true })
    vim.keymap.set('x', '2', '<<cmd>AutolistRecalculate<cr>gv', { buffer = true })
    vim.keymap.set('n', 'dd', 'dd<cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('v', 'd', 'd<cmd>AutolistRecalculate<cr>', { buffer = true })
  end,
})
