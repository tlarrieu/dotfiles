vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main', data = { cmd = 'TSUpdate' } },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects', version = 'main' },
  'https://github.com/Wansmer/treesj'
}, { confirm = false })

---- Treesitter ----------------------------------------------------------------

local treesitter = require('nvim-treesitter')

treesitter.install({
  'bash',
  'fish',
  'gitcommit',
  'go',
  'gomod',
  'haskell',
  'javascript',
  'just',
  'lua',
  'luadoc',
  'markdown',
  'query',
  'ruby',
  'embedded_template',
  'sql',
  'yaml',
  'json',
  'tsx',
  'typescript',
  'ledger',
  'vim',
  'vimdoc',
  'xresources',
  'zathurarc',
  'xml'
})

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    local ok, _ = pcall(vim.treesitter.start)

    if not ok then return end

    local ft = vim.bo[ev.buf].filetype

    if not vim.b.to_treesitter_options then
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo.foldmethod = 'expr'
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    local map = function(keys, kind, scope)
      local basepath

      local globalpath = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'pack', 'core', 'opt')

      if scope == 'local' then
        basepath = '~/git/dotfiles/config/nvim/after/queries/'
      elseif kind == 'textobjects' then
        basepath = vim.fs.joinpath(globalpath, 'nvim-treesitter-textobjects', 'queries')
      else
        basepath = vim.fs.joinpath(globalpath, 'nvim-treesitter', 'runtime', 'queries')
      end

      vim.keymap.set('n', keys, function()
        vim.cmd.vsplit(vim.fs.joinpath(basepath, ft, kind .. '.scm'))
      end, { desc = 'Edit ' .. kind .. ' queries (' .. scope .. ')', buffer = true })
    end

    map('<leader>eh', 'highlights', 'local')
    map('<leader>et', 'textobjects', 'local')
    map('<leader>eH', 'highlights', 'global')
    map('<leader>eT', 'textobjects', 'global')
  end,
})

---- TS text-objects -----------------------------------------------------------

require('nvim-treesitter-textobjects').setup({ select = { lookahead = true, selection_modes = { ['@block.outer'] = 'V' } } })

local select = function(x)
  return function() require 'nvim-treesitter-textobjects.select'.select_textobject(x, 'textobjects') end
end

vim.keymap.set({ 'x', 'o' }, 'if', select('@function.inner'))
vim.keymap.set({ 'x', 'o' }, 'af', select('@function.outer'))
vim.keymap.set({ 'x', 'o' }, 'ia', select('@parameter.inner'))
vim.keymap.set({ 'x', 'o' }, 'aa', select('@parameter.outer'))
vim.keymap.set({ 'x', 'o' }, 'ie', select('@block.inner'))
vim.keymap.set({ 'x', 'o' }, 'ae', select('textobjects'))
vim.keymap.set({ 'x', 'o' }, 'ic', select('@conditional.inner'))
vim.keymap.set({ 'x', 'o' }, 'ac', select('@conditional.outer'))
vim.keymap.set({ 'x', 'o' }, 'iC', select('@class.inner'))
vim.keymap.set({ 'x', 'o' }, 'aC', select('textobjects'))
vim.keymap.set({ 'x', 'o' }, 'il', select('@assignment.lhs'))
vim.keymap.set({ 'x', 'o' }, 'ir', select('@assignment.rhs'))

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql' },
  callback = function()
    vim.keymap.set({ 'x', 'o' }, 'ip', select('@paragraph'), { buffer = true })
    vim.keymap.set({ 'x', 'o' }, 'ap', select('@paragraph'), { buffer = true })
    vim.keymap.set({ 'x', 'o' }, 'is', select('@sentence.inner'), { buffer = true })
    vim.keymap.set({ 'x', 'o' }, 'as', select('@sentence.outer'), { buffer = true })
  end,
})

---- treesj --------------------------------------------------------------------

local treesj = require('treesj')
treesj.setup({ max_join_length = 1000, use_default_keymaps = false })
vim.keymap.set('n', '<leader>,', treesj.toggle, { desc = 'Toggle split' })
vim.keymap.set('n', '<leader>;', function() treesj.toggle({ split = { recursive = true } }) end,
  { desc = 'Toggle split (recursive)' })
vim.keymap.set('i', '<c-cr>', function()
  treesj.split()
  vim.api.nvim_input('<esc>O')
end, { desc = 'Split' })
