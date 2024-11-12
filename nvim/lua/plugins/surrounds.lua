return {
  'tpope/vim-surround',
  config = function()
    vim.g.surround_no_insert_mappings = 1

    vim.keymap.set({ 'n', 'o' }, 'S', 'ys', { remap = true, silent = true })
    vim.keymap.set({ 'x' }, 'S', '<Plug>VSurround', { remap = true, silent = true })
  end
}
