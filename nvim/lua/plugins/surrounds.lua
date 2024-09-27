return {
  'tpope/vim-surround',
  config = function()
    vim.g.surround_no_insert_mappings = 1

    vim.keymap.set({ 'n', 'o' }, 's', 'ys', { remap = true, silent = true })
    vim.keymap.set({ 'x' }, 's', 'S', { remap = true, silent = true })
  end
}
