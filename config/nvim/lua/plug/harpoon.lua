vim.pack.add({ { src = 'https://github.com/theprimeagen/harpoon', version = 'harpoon2' } }, { confirm = false })

local normalize = function(str)
  local substr, count = str:gsub('oil://', '')
  local rel = vim.fs.relpath(vim.fn.getcwd(), substr, {})
  return (rel or substr) .. (count > 0 and ' *' or '')
end

local harpoon = require('harpoon')
harpoon.setup({
  default = {
    display = function(item) return normalize(item.value) end,
  },
})

harpoon:extend({
  NAVIGATE = function()
    -- force FileType autocmd to run
    vim.cmd.let('&filetype=&filetype')

    -- drop dangling empty buffer
    local prevbuf = vim.fn.bufnr('#')
    if prevbuf == -1 then return end
    if vim.api.nvim_buf_get_name(prevbuf) ~= '' then return end
    vim.api.nvim_buf_delete(prevbuf, {})
  end,

  UI_CREATE = function(cx)
    local select = function(mode) harpoon.ui:select_menu_item({ [mode] = true }) end

    vim.keymap.set('n', '<c-v>', function() select('vsplit') end, { buffer = cx.bufnr })
    vim.keymap.set('n', '<c-x>', function() select('split') end, { buffer = cx.bufnr })
    vim.keymap.set('n', '<c-t>', function() select('tabedit') end, { buffer = cx.bufnr })

    -- highlight current buffer
    for line_number, file in pairs(cx.contents) do
      if normalize(cx.current_file) == normalize(file) then
        local ns = vim.api.nvim_create_namespace('Harpoon')
        vim.hl.range(cx.bufnr, ns, "HarpoonLine", { line_number - 1, 0 }, { line_number - 1, -1 })
        vim.api.nvim_win_set_cursor(cx.win_id, { line_number, 0 })
      end
    end
  end,
})

vim.keymap.set('n', '<c-,>', function() harpoon:list():add() end, { desc = 'Harpoon: add file' })

vim.keymap.set('n', '<c-">', function() harpoon:list():select(1) end, { desc = 'Harpoon: open #1' })
vim.keymap.set('n', '<c-«>', function() harpoon:list():select(2) end, { desc = 'Harpoon: open #2' })
vim.keymap.set('n', '<c-»>', function() harpoon:list():select(3) end, { desc = 'Harpoon: open #3' })
vim.keymap.set('n', '<c-(>', function() harpoon:list():select(4) end, { desc = 'Harpoon: open #4' })
vim.keymap.set('n', '<c-)>', function() harpoon:list():select(5) end, { desc = 'Harpoon: open #5' })
vim.keymap.set('n', '<c-@>', function() harpoon:list():select(6) end, { desc = 'Harpoon: open #6' })

vim.keymap.set('n', '<c-s-t>', function() harpoon:list():next() end, { desc = 'Harpoon: open #6' })
vim.keymap.set('n', '<c-s-s>', function() harpoon:list():prev() end, { desc = 'Harpoon: open #6' })

vim.keymap.set('n', "<c-e>",
  function()
    harpoon.ui:toggle_quick_menu(harpoon:list(), {
      title = '󱡅 Harpoon',
      title_pos = 'center',
      border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    })
  end,
  { desc = 'Harpoon: edit list' }
)

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'harpoon' },
  callback = function()
    vim.wo.cursorline = true
    vim.wo.relativenumber = false
  end,
})
