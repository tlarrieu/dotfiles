vim.pack.add({ 'https://github.com/FylerOrg/fyler.nvim' }, { confirm = false })

local fyler = require('fyler')

local show_hidden = true

local apply_hidden = function(inst) inst.cache.ui.hidden_items.switches.dotfiles = not show_hidden end

local toggle_hidden = function(inst)
  show_hidden = not show_hidden
  apply_hidden(inst)
  inst:refresh()
end

local show_help = function(inst)
  local lines = {}
  for key, mapping in pairs(inst.opts.mappings.n) do
    if not mapping.disabled and mapping.desc then table.insert(lines, ('%-12s %s'):format(key, mapping.desc)) end
  end
  table.sort(lines)
  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO, { title = 'Fyler' })
end

fyler.setup({
  auto_confirm_simple_mutation = false,
  follow_root_dir = false,
  use_as_default_explorer = true,
  extensions = { git = { enabled = true }, watcher = { enabled = true } },
  integrations = { icon = 'nvim_web_devicons' },
  win_opts = {
    wrap = false,
    number = true,
    relativenumber = true,
    cursorline = true,
    cursorcolumn = false,
    foldcolumn = '0',
    spell = false,
    list = false,
    conceallevel = 3,
  },
  mappings = {
    n = {
      ['g?'] = { action = show_help, desc = 'Show help' },
      ['<C-CR>'] = { action = 'visit', args = { cursor = true }, desc = 'Enter directory under cursor' },
      ['<C-l>'] = { action = 'refresh', args = { recursive = true, force = true }, desc = 'Refresh' },
      ['s'] = { action = function(inst) inst:mutate() end, desc = 'Save changes' },
      ['-'] = { action = 'visit', args = { parent = true }, desc = 'Go to parent directory' },
      ['<BS>'] = { action = 'visit', args = { parent = true }, desc = 'Go to parent directory' },
      ['_'] = { action = function(inst) inst:visit({ path = vim.fn.getcwd() }) end, desc = 'Open cwd' },
      ['<leader>cd'] = {
        action = function(inst) vim.cmd.cd(vim.fn.fnameescape(inst.state.pseudo_root_path)) end,
        desc = 'Change cwd to current directory',
      },
      ['g.'] = { action = toggle_hidden, desc = 'Toggle hidden files' },
      ['.'] = { disabled = true },
      ['='] = { disabled = true },
      ['q'] = { disabled = true },
      ['<C-R>'] = { disabled = true },
      ['<C-S>'] = { disabled = true },
      ['<C-T>'] = { disabled = true },
      ['<C-V>'] = { disabled = true },
    },
  },
})

vim.keymap.set('n', '<leader>.', fyler.open, { desc = 'Open Fyler', silent = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'fyler_finder' },
  callback = function()
    vim.keymap.set('n', '<leader>.', fyler.close, { buffer = true, silent = true, desc = 'Close fyler' })
    vim.opt_local.autoindent = true
    local inst = require('fyler.finder').instance_get_or_nil()
    if inst then apply_hidden(inst) end
    local win = vim.api.nvim_get_current_win()
    vim.schedule(function()
      vim.wo[win][0].signcolumn = 'yes:2'
      vim.wo[win][0].concealcursor = 'n'
    end)
  end,
})
