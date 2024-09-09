return {
  'airblade/vim-gitgutter',
  config = function()
    vim.g.gitgutter_map_keys = 0

    vim.api.nvim_create_autocmd('BufReadPost', {
      pattern = { '*' },
      callback = function()
        vim.keymap.set('n', 'ß', '<Plug>(GitGutterPrevHunk)')
        vim.keymap.set('n', 'þ', '<Plug>(GitGutterNextHunk)')
        vim.keymap.set('', '7', ':GitGutterStageHunk<cr>', { remap = true })
        vim.keymap.set('', '8', ':GitGutterUndoHunk<cr>', { remap = true })
      end,
      group = vim.api.nvim_create_augroup('GitGutterAutocmd', {})
    })
  end
}
