return {
  'janko-m/vim-test',
  cmd = {
    'TestNearest',
    'TestFile',
    'TestLast'
  },
  dependencies = {
    'akinsho/toggleterm.nvim',
  },
  config = function()
    vim.g['test#strategy'] = 'toggleterm'
  end
}
