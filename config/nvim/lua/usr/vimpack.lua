vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind

    if not (kind == 'install' or kind == 'update') then return end

    local data = ev.data.spec.data or {}

    local info = function(label) vim.notify(label, vim.log.levels.INFO, { title = 'PackChanged: ' .. name }) end

    if data.build then
      info('running post-install build...')
      vim.system({ data.build }, { cwd = ev.data.path }):wait()
      info('done.')
    end

    if data.cmd then
      info('running post-install cmd')
      if not ev.data.active then vim.cmd.packadd(name) end
      vim.cmd(data.cmd)
      info('done')
    end
  end
})

vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',

  'https://github.com/AndrewRadev/linediff.vim',
  'https://github.com/tommcdo/vim-exchange',
  'https://github.com/tpope/vim-eunuch',
  'https://github.com/tpope/vim-projectionist',
  'https://github.com/tpope/vim-repeat',
  'https://github.com/vim-scripts/edifact.vim',
}, { confirm = false })

require('usr.plugins.colors')
require('usr.plugins.devicons')

require('usr.plugins.oil')
require('usr.plugins.telescope')
require('usr.plugins.harpoon')
require('usr.plugins.neogit')
require('usr.plugins.gitsigns')
require('usr.plugins.webify')

require('usr.plugins.copilot')
require('usr.plugins.completion')
require('usr.plugins.treesitter')
require('usr.plugins.lsp')
require('usr.plugins.conform')

require('usr.plugins.testbus')
require('usr.plugins.fidget')
require('usr.plugins.dropbar')
require('usr.plugins.statusline')

require('usr.plugins.surround')
require('usr.plugins.marks')
require('usr.plugins.indent')
require('usr.plugins.folds')
require('usr.plugins.listchars')
require('usr.plugins.cursorword')
require('usr.plugins.align')
require('usr.plugins.autoclose')
require('usr.plugins.bufjump')
require('usr.plugins.bullets')
require('usr.plugins.colorizer')
require('usr.plugins.markview')
require('usr.plugins.yaml')
require('usr.plugins.todo-comments')
