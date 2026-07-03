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

require('config.options')

vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',

  'https://github.com/tommcdo/vim-exchange',
  'https://github.com/tpope/vim-eunuch',
  'https://github.com/tpope/vim-repeat',
  'https://github.com/vim-scripts/edifact.vim',
}, { confirm = false })

require('plug.devicons')
require('plug.fidget')
require('plug.oil')
require('plug.harpoon')
require('plug.telescope')
require('plug.git')

require('plug.completion')
require('plug.treesitter')
require('plug.lsp')
require('plug.format')

require('plug.testbus')
require('plug.dropbar')
require('plug.statusline')

require('plug.diff')
require('plug.surround')
require('plug.marks')
require('plug.indent')
require('plug.folds')
require('plug.cursorword')
require('plug.align')
require('plug.autoclose')
require('plug.bufjump')
require('plug.autolist')
require('plug.colorizer')
require('plug.markview')
require('plug.yaml')
require('plug.todo-comments')

require('config.filetypes')
require('config.keymaps')
require('config.abbrev')
require('config.autocmd')

vim.cmd.colorscheme('chromatic')
