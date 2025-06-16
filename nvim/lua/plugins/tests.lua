return {
  'janko-m/vim-test',
  cmd = {
    'TestNearest',
    'TestFile',
    'TestLast'
  },
  config = function()
    vim.g['test#strategy'] = 'toggleterm'
  end
}
