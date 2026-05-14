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
})

local excluded_filetypes = {
  ledger = true,
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    local ok, _ = pcall(vim.treesitter.start)

    if not ok then return end

    local ft = vim.bo[ev.buf].filetype

    if not excluded_filetypes[ft] then
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

local select = require 'nvim-treesitter-textobjects.select'

vim.keymap.set({ 'x', 'o' }, 'if', function() select.select_textobject('@function.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'af', function() select.select_textobject('@function.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ia', function() select.select_textobject('@parameter.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'aa', function() select.select_textobject('@parameter.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ie', function() select.select_textobject('@block.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ae', function() select.select_textobject('@block.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ic', function() select.select_textobject('@conditional.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ac', function() select.select_textobject('@conditional.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'iC', function() select.select_textobject('@class.inner', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'aC', function() select.select_textobject('@class.outer', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'il', function() select.select_textobject('@assignment.lhs', 'textobjects') end)
vim.keymap.set({ 'x', 'o' }, 'ir', function() select.select_textobject('@assignment.rhs', 'textobjects') end)

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sql' },
  callback = function()
    vim.keymap.set({ 'x', 'o' }, 'ip', function() select.select_textobject('@paragraph', 'textobjects') end,
      { buffer = true })
    vim.keymap.set({ 'x', 'o' }, 'ap', function() select.select_textobject('@paragraph', 'textobjects') end,
      { buffer = true })
    vim.keymap.set({ 'x', 'o' }, 'is', function() select.select_textobject('@sentence.inner', 'textobjects') end,
      { buffer = true })
    vim.keymap.set({ 'x', 'o' }, 'as', function() select.select_textobject('@sentence.outer', 'textobjects') end,
      { buffer = true })
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
