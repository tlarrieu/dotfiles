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

local check = function(char)
  return function()
    local line = vim.api.nvim_get_current_line():gsub('^(%s*)- %[.%]', '%1- [' .. char .. ']')
    local cursor = vim.api.nvim_win_get_cursor(0)
    -- toggling markview off to avoid screen flicker
    pcall(vim.cmd.Markview, 'toggle')
    vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1], false, { line })
    -- turn it back on
    pcall(vim.cmd.Markview, 'toggle')
  end
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'gitcommit', 'text' },
  callback = function()
    vim.keymap.set('i', '<c-t>', '<c-t><cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('i', '<c-d>', '<c-d><cmd>AutolistRecalculate<cr>', { buffer = true })
    vim.keymap.set('i', '<cr>', '<CR><cmd>AutolistNewBullet<cr>', { buffer = true })
    vim.keymap.set('n', '<c-cr>', 'o', { buffer = true })
    vim.keymap.set('i', '<c-cr>', '<c-o>o', { buffer = true })
    vim.keymap.set('n', 'o', 'o<cmd>AutolistNewBullet<cr>', { buffer = true })

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

    -- checkbox manipulation
    vim.keymap.set('n', '<leader>tr', check(' '), { buffer = true })
    vim.keymap.set('n', '<leader>td', check('x'), { buffer = true })
    vim.keymap.set('n', '<leader>ts', check('/'), { buffer = true })
    vim.keymap.set('n', '<leader>tc', check('-'), { buffer = true })
  end,
})
