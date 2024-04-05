return {
  'gcmt/taboo.vim',
  config = function()
    vim.keymap.set('n', '<leader>tl', ':TabooRename<leader>')
    vim.keymap.set('n', '<leader>tr', ':TabooReset<cr>')
    vim.g.taboo_tab_format = ' %N %f%m '
    vim.g.taboo_renamed_tab_format = ' %N (%l)%m '
    vim.g.taboo_modified_tab_flag = ' ∙'
    vim.g.taboo_unnamed_tab_label = '…'
  end
}
