vim.g.flog_enable_extended_chars = true
vim.g.flog_default_opts = { format = '[%h]%d %s', max_count = 200, skip = 0 }

vim.pack.add({
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',
  'https://github.com/rbong/vim-flog',
  'https://github.com/esmuellert/codediff.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
}, { confirm = false })

-------------------------------------------------- Fugitive --------------------------------------------------

vim.keymap.set('n', '<c-s>', '<cmd>below Git<cr>', { silent = true, desc = 'neogit' })

vim.keymap.set('n', '<leader>cc', '<cmd>below Git commit<cr>',
  { silent = true, desc = 'Git commit (new)' })
vim.keymap.set('n', '<leader>ca', '<cmd>below Git commit --amend --no-edit<cr>',
  { silent = true, desc = 'Git commit (amend)' })
vim.keymap.set('n', '<leader>ce', '<cmd>below Git commit --amend<cr>',
  { silent = true, desc = 'Git commit (edit)' })

vim.keymap.set({ 'n', 'v' }, 'gy', ':GBrowse!<cr>', { silent = true, desc = 'Git(Hub) yank file/line URL' })

vim.keymap.set('n', '<leader>bo', ':Git pr<cr>', { silent = true, desc = 'Git pull request' })
vim.keymap.set('n', '<leader>bb', '<cmd>Telescope git_branches<cr>', { desc = 'Git branch' })
vim.keymap.set('n', '<leader>bl',
  function() require('telescope.builtin').git_branches({ show_remote_tracking_branches = false }) end,
  { desc = 'Git branch (local)' })

local async_git = function(cmd)
  local _cmd = { 'git' }
  for _, c in ipairs(cmd) do table.insert(_cmd, c) end
  local cmdstr = table.concat(_cmd, ' ')
  table.insert(_cmd, '--quiet')

  return function()
    vim.notify(cmdstr, vim.log.levels.INFO)
    vim.system(_cmd, {}, function(obj)
      if obj.code == 0 then
        vim.notify(obj.stdout == '' and 'done' or obj.stdout, vim.log.levels.INFO)
      else
        vim.notify(obj.stderr:gsub('error: ', ''), vim.log.levels.ERROR)
      end
      vim.schedule(function()
        vim.cmd.mode()
        vim.cmd.checktime()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].filetype == 'fugitive' then
            local curbuf = vim.api.nvim_get_current_buf()
            vim.cmd.Git()
            if curbuf ~= vim.api.nvim_get_current_buf() then vim.fn.feedkeys('') end
            break
          end
        end
      end)
    end)
  end
end

vim.keymap.set('n', '<leader>gu', async_git({ 'pull', '--rebase', }), { desc = 'Git pull' })
vim.keymap.set('n', '<leader>gp', async_git({ 'push', '--force-with-lease', }), { desc = 'Git pull' })
vim.keymap.set('n', '<leader>gf', async_git({ 'fetch', '--tags', '--force', }), { desc = 'Git fetch' })
vim.keymap.set('n', '<leader>gs', async_git({ 'stash', }), { desc = 'Git stash' })
vim.keymap.set('n', '<leader>gS', async_git({ 'stash', 'pop', }), { desc = 'Git stash pop' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'fugitive' },
  callback = function()
    vim.keymap.set('n', 'x', 'X', { remap = true, buffer = true })
    vim.keymap.set('n', 'o', '=', { remap = true, buffer = true })
    vim.keymap.set('n', 'þ', ']/', { remap = true, buffer = true })
    vim.keymap.set('n', 'ß', '[/', { remap = true, buffer = true })
    vim.keymap.set('n', 'S', '<cmd>Git add .<cr>', { buffer = true })
    vim.keymap.set('n', '<c-s>', '<cmd>q<cr>', { buffer = true })
  end,
})

---------------------------------------------------- Flog ----------------------------------------------------

vim.keymap.set('n', '<leader>l', ':vertical Flogsplit<cr>', { silent = true, desc = 'Git log' })
vim.keymap.set('n', '<leader>L', ':vertical 0Flogsplit -no-patch<cr>', { silent = true, desc = 'Git history (file)' })
vim.keymap.set('v', '<leader>l', ':vertical Flogsplit -no-patch<cr>', { silent = true, desc = 'Git history (visual)' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'floggraph' },
  callback = function()
    vim.keymap.del('n', '<tab>', { buffer = true })
    vim.keymap.set('n', 'þ', ']]', { remap = true, buffer = true })
    vim.keymap.set('n', 'ß', '[[gg', { remap = true, buffer = true })
    vim.opt_local.listchars = {}
  end,
})

-------------------------------------------------- Codediff --------------------------------------------------

require('codediff').setup({
  diff = {
    layout = 'inline',
    compute_moves = true,
    cycle_hunks_across_files = true,
  },
  explorer = {
    width = 45,
    icons = { folder_closed = '', folder_open = '' },
    view_mode = 'tree',
    flatten_dirs = true,
    file_filter = { ignore = { '*.pdf' } },
  },
  keymaps = {
    view = { next_hunk = 'þ', prev_hunk = 'ß', next_file = '<c-n>', prev_file = '<c-p>' },
  },
  highlights = {
    line_move = 'DiffMove',
  }
})

vim.keymap.set('n', '<leader>dm', '<cmd>CodeDiff origin/master...<cr>',
  { silent = true, desc = 'code(diff) review (origin/master...)' })
vim.keymap.set('n', '<leader>dd', '<cmd>CodeDiff HEAD<cr>', { silent = true, desc = 'code(diff) review (HEAD~)' })

-------------------------------------------------- Gitsigns --------------------------------------------------

local signs = {
  add          = { text = '┃󰐕' },
  change       = { text = '┃~' },
  delete       = { text = '┃_' },
  topdelete    = { text = '┃‾' },
  changedelete = { text = '┃󰦒' },
  untracked    = { text = '╏󰐕' },
}

local gitsigns = require('gitsigns')

gitsigns.setup({
  signs = signs,
  signs_staged = signs,
  signs_staged_enable = true,
  signcolumn = true,
  numhl = true,
  linehl = false,
  word_diff = false,
  watch_gitdir = { follow_files = true },
  auto_attach = true,
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 0,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '  <abbrev_sha> • <author> (<author_time:%R>) • <summary> ',
  current_line_blame_formatter_nc = '  Not committed yet ',
  sign_priority = 6,
  update_debounce = 50,
  status_formatter = nil,
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  on_attach = function()
    local nav_hunk = function(dir)
      if vim.wo.diff then return vim.cmd.normal({ dir == 'prev' and '[c' or ']c', bang = true }) end
      gitsigns.nav_hunk(dir, { wrap = false, target = 'all' })
    end

    vim.keymap.set('n', 'ß', function() nav_hunk('prev') end, { desc = 'Previous hunk' })
    vim.keymap.set('n', 'þ', function() nav_hunk('next') end, { desc = 'Next hunk' })
    vim.keymap.set('n', '7', gitsigns.stage_hunk, { remap = true, desc = 'Toggle stage hunk' })
    vim.keymap.set('n', '8', gitsigns.reset_hunk, { remap = true, desc = 'Reset hunk' })

    local line_of = function(mark) return vim.api.nvim_buf_get_mark(0, mark)[1] end
    vim.keymap.set('x', '7', function()
      vim.cmd([[execute "normal! \<ESC>"]])
      gitsigns.stage_hunk({ line_of('<'), line_of('>') })
    end, { remap = true, desc = 'Toggle stage hunk (VISUAL)' })
    vim.keymap.set('x', '8', function()
      vim.cmd([[execute "normal! \<ESC>"]])
      gitsigns.reset_hunk({ line_of('<'), line_of('>') })
    end, { remap = true, desc = 'Reset hunk (VISUAL)' })

    local modes = { 'n', 'o', 'x' }
    vim.keymap.set(modes, '<leader>gd', gitsigns.diffthis, { desc = 'Diff (current)' })
    vim.keymap.set(modes, '<leader>gD', function() gitsigns.diffthis('master') end, { desc = 'Diff (master)' })
    vim.keymap.set(modes, '<leader>gb', gitsigns.blame, { desc = 'Blame (buffer)' })
    vim.keymap.set(modes, '<leader>gB', gitsigns.toggle_current_line_blame, { desc = 'Blame (line)' })
    vim.keymap.set(modes, '<leader>gw', gitsigns.stage_buffer, { desc = 'Stage all hunks' })
    vim.keymap.set(modes, '<leader>gr', ':silent !git checkout %<cr>', { remap = true, desc = 'Git checkout' })
    vim.keymap.set(modes, '<leader>gR', gitsigns.reset_buffer_index, { remap = true, desc = 'Git reset buffer' })
    vim.keymap.set(modes, '<leader>gq', function()
      gitsigns.setqflist('all')
    end, { remap = true, desc = 'Git reset' })
  end
})
