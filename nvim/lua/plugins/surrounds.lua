return {
  'tpope/vim-surround',
  config = function()
    vim.g.surround_no_insert_mappings = 1

    vim.keymap.set('', 's', 'ys', { remap = true, silent = true })
  end
}