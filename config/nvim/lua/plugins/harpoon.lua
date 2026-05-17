vim.pack.add({
  { src = 'https://github.com/ThePrimeagen/harpoon', version = 'harpoon2' }
}, { confirm = false })

local border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }
local list = function() return require('harpoon'):list() end

local harpoon = require('harpoon')
harpoon.setup()
harpoon:extend({
  UI_CREATE = function(cx)
    local select = function(mode) harpoon.ui:select_menu_item({ [mode] = true }) end

    vim.keymap.set('n', '<c-v>', function() select('vsplit') end, { buffer = cx.bufnr })
    vim.keymap.set('n', '<c-x>', function() select('split') end, { buffer = cx.bufnr })
    vim.keymap.set('n', '<c-t>', function() select('tabedit') end, { buffer = cx.bufnr })

    -- highlight current buffer
    for line_number, file in pairs(cx.contents) do
      if string.find(cx.current_file, file, 1, true) then
        local ns = vim.api.nvim_create_namespace('Harpoon')
        vim.hl.range(cx.bufnr, ns, "HarpoonLine", { line_number - 1, 0 }, { line_number - 1, -1 })
        vim.api.nvim_win_set_cursor(cx.win_id, { line_number, 0 })
      end
    end
  end,
})

vim.keymap.set('n', '<c-s-,>', function() list():add() end, { desc = 'Harpoon: add file' })

vim.keymap.set('n', '<c-">', function() list():select(1) end, { desc = 'Harpoon: open #1' })
vim.keymap.set('n', '<c-«>', function() list():select(2) end, { desc = 'Harpoon: open #2' })
vim.keymap.set('n', '<c-»>', function() list():select(3) end, { desc = 'Harpoon: open #3' })
vim.keymap.set('n', '<c-(>', function() list():select(4) end, { desc = 'Harpoon: open #4' })
vim.keymap.set('n', '<c-)>', function() list():select(5) end, { desc = 'Harpoon: open #5' })
vim.keymap.set('n', '<c-@>', function() list():select(6) end, { desc = 'Harpoon: open #6' })

vim.keymap.set('n', "<c-,>",
  function() harpoon.ui:toggle_quick_menu(list(), { title = '󱡅 Harpoon', title_pos = 'center', border = border }) end,
  { desc = 'Harpoon: edit list' }
)

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'harpoon' },
  callback = function()
    vim.wo.cursorline = true
    vim.wo.relativenumber = false
  end,
})
