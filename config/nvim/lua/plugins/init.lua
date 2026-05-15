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
      if type(data.cmd) == 'function' then
        data.cmd()
      elseif type(data.cmd) == 'string' then
        vim.cmd(data.cmd)
      end
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

require('plugins.colors')
require('plugins.devicons')

require('plugins.oil')
require('plugins.telescope')
require('plugins.harpoon')
require('plugins.neogit')
require('plugins.gitsigns')
require('plugins.webify')

require('plugins.copilot')
require('plugins.completion')
require('plugins.treesitter')
require('plugins.lsp')
require('plugins.format')

require('plugins.testbus')
require('plugins.fidget')
require('plugins.dropbar')
require('plugins.statusline')

require('plugins.surround')
require('plugins.marks')
require('plugins.indent')
require('plugins.folds')
require('plugins.listchars')
require('plugins.cursorword')
require('plugins.align')
require('plugins.autoclose')
require('plugins.bufjump')
require('plugins.bullets')
require('plugins.colorizer')
require('plugins.markview')
require('plugins.yaml')
require('plugins.todo-comments')
