return {
  'janko-m/vim-test',
  cmd = {
    'TestNearest',
    'TestFile',
    'TestLast'
  },
  dependencies = {
    'akinsho/toggleterm.nvim',
    'tlarrieu/testbus',
  },
  config = function()
    local testbus = require('testbus')
    local options = table.concat(testbus.adapters.rspec.options, ' ')
    vim.cmd("let test#ruby#rspec#options = '" .. options .. "'")
    vim.cmd [[
      function! ToggleTermBackground(cmd) abort
        execute "TermExec open=0 cmd='".substitute(a:cmd, "'", '"', "g")."'"
      endfunction
      let g:test#custom_strategies = { 'toggleterm_background': function('ToggleTermBackground') }
      let g:test#strategy = 'toggleterm_background'
    ]]
  end
}
