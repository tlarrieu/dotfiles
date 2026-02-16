return {
  'austintaylor/vim-indentobject',
  config = function()
    -- we don't want to keymap anything in select mode
    vim.keymap.del('s', 'ai')
    vim.keymap.del('s', 'ii')
  end,
}
