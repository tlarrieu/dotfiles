local wrap = function(fun)
  return function() require('testbus').start(fun) end
end

return {
  'janko-m/vim-test',
  dependencies = {
    'akinsho/toggleterm.nvim',
    'tlarrieu/testbus',
  },
  cmd = {
    'TestNearest',
    'TestFile',
    'TestLast'
  },
  keys = {
    { '<leader>tr', wrap(vim.cmd.TestNearest), desc = 'Run nearest test', silent = true },
    { '<leader>tf', wrap(vim.cmd.TestFile), desc = 'Run test file', silent = true },
    { '<leader>tl', wrap(vim.cmd.TestLast), desc = 'Rerun last test', silent = true },
    {
      '<leader>ts',
      function()
        require('testbus').clear()
        local bufnr = vim.fn.bufnr('#toggleterm#')
        if bufnr == -1 then return end
        vim.cmd.bdelete({ bufnr, bang = true })
      end,
      desc = 'Stop running test',
      silent = true
    },
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
