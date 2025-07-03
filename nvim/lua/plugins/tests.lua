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
    vim.cmd [[
      function! ToggleTermBackground(cmd) abort
        execute "TermExec open=0 cmd='".substitute(a:cmd, "'", '"', "g")."'"
      endfunction
      let test#ruby#rspec#options = '--format=json --out=/tmp/testbus.json --format=progress'
      let g:test#custom_strategies = { 'toggleterm_background': function('ToggleTermBackground') }
      let g:test#strategy = 'toggleterm_background'
    ]]
  end
}
