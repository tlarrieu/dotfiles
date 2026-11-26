vim.g.flog_enable_extended_chars = true
vim.g.flog_enable_dynamic_commit_hl = true
vim.g.flog_default_opts = { format = '%h • %ah •%d %s [%an]', max_count = 200, skip = 0 }

vim.pack.add({
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/tpope/vim-rhubarb',
  'https://github.com/rbong/vim-flog',
  'https://github.com/esmuellert/codediff.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
}, { confirm = false })

------------------------------------------------------| Fugitive |------------------------------------------------------

local git = function(args)
  return function()
    local ok = nil
    if args == nil then
      ok, _ = pcall(vim.cmd, 'below Git')
      if ok then vim.cmd.normal(']/') end
    else
      ok, _ = pcall(vim.cmd, 'below Git ' .. table.concat(args or {}, ' '))
    end

    if ok then vim.cmd.checktime() else vim.notify('Not a git repository', vim.log.levels.ERROR) end
  end
end

local pending_jobs = {}
local next_job_id = 0

local set_pending = function(id, label)
  pending_jobs[id] = label
  vim.g.git_pending = vim.tbl_values(pending_jobs)
  pcall(function() require('lualine').refresh({ place = { 'statusline' } }) end)
end

-- Each job's start and result share a key: the result replaces the start notification
-- (fidget's system notifications update in place) instead of stacking a second one.
-- The group is the notification's title (the git command), `done` is the progress flag fidget expects in `data`,
-- `appname` picks the notification's color in awesome (see config/awesome/theme.lua).
local notify_job = function(job_id, title, msg, level, done, appname)
  vim.notify(msg, level, { key = job_id, group = title, data = done, appname = appname })
end

local async_git = function(cmd)
  local _cmd = { 'git' }
  for _, c in ipairs(cmd) do table.insert(_cmd, c) end
  local cmdstr = table.concat(_cmd, ' ')
  table.insert(_cmd, '--quiet')

  return function()
    next_job_id = next_job_id + 1
    local job_id = next_job_id
    notify_job(job_id, cmdstr, 'started...', vim.log.levels.INFO, false, 'nvim.job.started')
    for i, c in ipairs(_cmd) do _cmd[i] = vim.fn.expand(c) end
    set_pending(job_id, cmd[1])
    local ok, err = pcall(vim.system, _cmd, {}, function(obj)
      if obj.code == 0 then
        notify_job(job_id, cmdstr, 'done!', vim.log.levels.INFO, true, 'nvim.job.done')
      else
        notify_job(job_id, cmdstr, (obj.stderr:gsub('error: ', '')), vim.log.levels.ERROR, true)
      end

      vim.schedule(function()
        set_pending(job_id, nil)
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

    if not ok then
      set_pending(job_id, nil)
      notify_job(job_id, cmdstr, err, vim.log.levels.ERROR, true)
    end
  end
end

vim.keymap.set('n', '<c-s>', git(), { silent = true, desc = 'fugitive' })

vim.keymap.set('n', '<leader>cc', git({ 'commit' }), { desc = 'Git commit (new)' })
vim.keymap.set('n', '<leader>ca', git({ 'commit', '--amend', '--no-edit' }), { desc = 'Git commit (amend)' })
vim.keymap.set('n', '<leader>ce', git({ 'commit', '--amend' }), { desc = 'Git commit (edit)' })

vim.keymap.set({ 'n', 'v' }, 'gy', ':GBrowse!<cr>', { desc = 'Git(Hub) yank file/line URL' })

vim.keymap.set('n', '<leader>bo', '<cmd>Git pr<cr>', { desc = 'Git pull request' })

local t = require('telescope.builtin')
vim.keymap.set('n', '<leader>bb', t.git_branches, { desc = 'Git branch' })
vim.keymap.set('n', '<leader>bl', function()
  t.git_branches({ show_remote_tracking_branches = false })
end, { desc = 'Git branch (local)' })
vim.keymap.set('n', '<leader>ba', async_git({ 'checkout', '-' }), { desc = 'Git checkout -' })
vim.keymap.set('n', '<leader>bm', async_git({ 'checkout', 'master' }), { desc = 'Git checkout master' })
vim.keymap.set('n', '<leader>bw', async_git({ 'bw' }), { desc = 'Git branch wipe' })

vim.keymap.set('n', '<leader>gu', async_git({ 'pull', '--rebase' }), { desc = 'Git pull' })
vim.keymap.set('n', '<leader>gp', async_git({ 'push', '--force-with-lease' }), { desc = 'Git push' })
vim.keymap.set('n', '<leader>gf', async_git({ 'fetch', '--tags', '--force' }), { desc = 'Git fetch' })
vim.keymap.set('n', '<leader>gs', async_git({ 'stash' }), { desc = 'Git stash' })
vim.keymap.set('n', '<leader>gS', async_git({ 'stash', 'pop' }), { desc = 'Git stash pop' })

local gitclear = function(file)
  local target = file and { '--', file } or {}
  local cmds = {
    vim.list_extend({ 'git', 'reset' }, target),
    vim.list_extend({ 'git', 'checkout' }, file and target or { '.' }),
    vim.list_extend({ 'git', 'clean', '--force' }, target),
  }

  for _, cmd in ipairs(cmds) do vim.system(cmd):wait() end

  pcall(git())
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'fugitive' },
  callback = function()
    vim.keymap.set('n', 'x', function()
      vim.cmd.normal('$')
      gitclear(vim.fn.expand('<cfile>'))
      vim.cmd.normal('^')
    end, { buffer = true })
    vim.keymap.set('n', 'X', gitclear, { buffer = true })
    vim.keymap.set('n', 'o', '=', { remap = true, buffer = true })
    vim.keymap.set('n', 'þ', ']/', { remap = true, buffer = true })
    vim.keymap.set('n', 'ß', '[/', { remap = true, buffer = true })
    vim.keymap.set('n', 'ca', git({ 'commit', '--amend', '--no-edit' }), { buffer = true, desc = 'Git commit (amend)' })
    vim.keymap.set('n', 'ce', git({ 'commit', '--amend' }), { buffer = true, desc = 'Git commit (edit)' })
    vim.keymap.set('n', 'S', '<cmd>Git add .<cr>', { buffer = true, desc = 'Git stage (all)' })
    vim.keymap.set('n', '<c-s>', '<cmd>q<cr>', { buffer = true, desc = 'fugitive' })
    vim.keymap.set('n', 'P', async_git({ 'push', '--force-with-lease' }), { buffer = true, desc = 'Git push' })
    vim.keymap.set('n', 'p', async_git({ 'pull', '--rebase' }), { buffer = true, desc = 'Git pull' })
  end,
})

--------------------------------------------------------| Flog |--------------------------------------------------------

vim.keymap.set('n', '<leader>l', ':vertical Flog<cr>', { silent = true, desc = 'Git log' })
vim.keymap.set('n', '<leader>L', ':vertical 0Flog -no-patch<cr>', { silent = true, desc = 'Git history (file)' })
vim.keymap.set('v', '<leader>l', ':vertical Flog -no-patch<cr>', { silent = true, desc = 'Git history (visual)' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'floggraph' },
  callback = function()
    vim.keymap.del('n', '<tab>', { buffer = true })
    vim.keymap.set('n', 'þ', ']]', { remap = true, buffer = true })
    vim.keymap.set('n', 'ß', '[[gg', { remap = true, buffer = true })
  end,
})

------------------------------------------------------| Codediff |------------------------------------------------------

-- Whether each file with uncommitted changes is staged, partially staged or unstaged, by git root then path (relative
-- to it): the explorer shows it next to the file's status (see staging_glyphs). Read alongside each time codediff
-- loads the changes of the working tree (its status, or a revision against it), and handed over to the explorer with
-- them. Conflicted files get none: they have their own status. Untracked ones aren't listed (scanning for them takes
-- most of the time in a large repository): their status (??) tells they're unstaged (see file_staging)
local staging = {}

local file_staging = function(root, path, status)
  local state = staging[root] and staging[root][path]
  if not state and status == '??' then state = 'unstaged' end
  return state
end

local read_staging = function(root, done)
  vim.system({ 'git', '--no-optional-locks', 'status', '--porcelain', '-z', '-uno' }, { cwd = root, text = true },
    function(res)
      local files = {}
      local entries = vim.split(res.stdout or '', '\0', { trimempty = true })
      local i = 1
      while i <= #entries do
        local index, worktree, path = entries[i]:sub(1, 1), entries[i]:sub(2, 2), entries[i]:sub(4)
        -- A rename's (or copy's) old path comes as the next entry
        if index == 'R' or index == 'C' or worktree == 'R' or worktree == 'C' then i = i + 1 end
        local conflict = index == 'U' or worktree == 'U' or (index == worktree and (index == 'A' or index == 'D'))
        if not conflict then
          local staged, unstaged = index ~= ' ' and index ~= '?', worktree ~= ' '
          files[path] = staged and (unstaged and 'partial' or 'staged') or 'unstaged'
        end
        i = i + 1
      end
      staging[root] = files
      done()
    end)
end

-- The loaders comparing against the working tree, with the position of their git root argument (their callback
-- follows it, called with an error and the files). Not get_diff_revisions_with_line_stats: two revisions, nothing
-- staged there. The staging is read while they load, their callback waiting for both. Each file gets its staging
-- state too: codediff redraws its list only when the files it loads differ from the last ones, which staging alone
-- doesn't change against a revision (see refresh_policy below)
local codediff_git = require('codediff.core.git')
for name, root_at in pairs({ get_status_with_line_stats = 1, get_diff_revision_with_line_stats = 2 }) do
  local load = codediff_git[name]
  codediff_git[name] = function(...)
    local args, count = { ... }, select('#', ...)
    local root, callback = args[root_at], args[root_at + 1]
    local waiting, results, results_count = 2, {}, 0
    local finish = vim.schedule_wrap(function()
      waiting = waiting - 1
      if waiting > 0 then return end
      for _, files in pairs(type(results[2]) == 'table' and results[2] or {}) do
        for _, file in ipairs(type(files) == 'table' and files or {}) do
          if type(file) == 'table' and file.path then file.staging = file_staging(root, file.path, file.status) end
        end
      end
      callback(unpack(results, 1, results_count))
    end)
    read_staging(root, finish)
    args[root_at + 1] = function(...)
      results, results_count = { ... }, select('#', ...)
      finish()
    end
    return load(unpack(args, 1, count))
  end
end

-- Staging (a hunk, a file) only touches the index. The staging glyphs follow it at once: the staging read again, the
-- explorer's rows redrawn, without codediff reloading its files (slow in a large repository) when it needn't. Against
-- a revision (HEAD, the base branch) it doesn't: the files compared stay the same. In the status view it still does,
-- after: files move between its Changes and Staged Changes
local restage = function(panel)
  local data, view = panel.data, panel.view
  read_staging(data.git_root, vim.schedule_wrap(function()
    for _, files in pairs(data.status_result or {}) do
      for _, file in ipairs(type(files) == 'table' and files or {}) do
        if type(file) == 'table' and file.path then file.staging = file_staging(data.git_root, file.path, file.status) end
      end
    end
    if view and view.tree and not view.is_hidden and vim.api.nvim_buf_is_valid(view.bufnr) then view.tree:render() end
  end))
end

local refresh_policy = require('codediff.ui.refresh.policy')
local panel_needed = refresh_policy.panel_needed
refresh_policy.panel_needed = function(panel, event)
  local needed = panel_needed(panel, event)
  local data = panel and panel.name == 'explorer' and panel.data or {}
  if event.index and data.git_root then
    local refs = data.source_revisions or {}
    if not data.base_revision or refresh_policy.is_working(refs.modified or data.target_revision) then restage(panel) end
  end
  return needed
end

-- Staging from neovim (gitsigns' hunks, fugitive) refreshes codediff at once, rather than once its watcher notices
-- the index changed. Tabs without codediff have nothing to refresh; one not shown refreshes once it is
vim.api.nvim_create_autocmd('User', {
  pattern = { 'GitSignsChanged', 'FugitiveChanged' },
  callback = function()
    local refresh = require('codediff.ui.refresh')
    for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do refresh.request(tabpage, { index = true }) end
  end,
})

-- The formatter only gets a file's path: the git root it is relative to comes along from its node
local row_root
local explorer_nodes = require('codediff.ui.explorer.nodes')
local prepare_node = explorer_nodes.prepare_node
explorer_nodes.prepare_node = function(node, ...)
  row_root = node.data and node.data.git_root
  return prepare_node(node, ...)
end

local staging_glyphs = {
  staged = { '●', 'CodeDiffStaged' },
  partial = { '◐', 'CodeDiffPartiallyStaged' },
  unstaged = { '○', 'CodeDiffUnstaged' },
}

-- codediff's file row, the staging glyph before the status (M, A, D…), its last segment.
local default_file_row = require('codediff.ui.explorer.formatters').file
-- Untracked files' status as a single ? (git's ??), lined up with the others' single letter
local file_row = function(ctx)
  local glyph = staging_glyphs[row_root and file_staging(row_root, ctx.path, ctx.status)]
  if ctx.status == '??' then ctx = vim.tbl_extend('force', ctx, { status = '?' }) end
  local row = default_file_row(ctx)
  if glyph then
    local segments = row.right[#row.right].segments
    table.insert(segments, 1, { text = ' ', hl = 'Normal' })
    table.insert(segments, 1, { text = glyph[1], hl = glyph[2] })
  end
  return row
end

require('codediff').setup({
  diff = {
    compute_moves = true,
    cycle_hunks_across_files = false,
    cycle_next_hunk = false,
    cycle_next_file = false,
    filler_text = '╳'
  },
  explorer = {
    width = 45,
    icons = { folder_closed = '', folder_open = '' },
    view_mode = 'tree',
    flatten_dirs = true,
    file_filter = { ignore = { '*.pdf' } },
    formatters = { file = file_row },
  },
  keymaps = {
    view = { next_hunk = 'þ', prev_hunk = 'ß', next_file = 'Þ', prev_file = 'ẞ' },
  },
  highlights = {
    line_move = 'DiffMove',
  }
})

-- No "First/Last hunk", "First/Last file" (or commit) warning when hitting either end. codediff echoes them, as
-- WarningMsg, with no option to turn that off: swallow those echoes while navigating. Its keymaps bind these
-- functions when a view opens, so they get ours.
local navigation = require('codediff.ui.view.navigation')
for _, name in ipairs({ 'next_hunk', 'prev_hunk', 'next_file', 'prev_file' }) do
  local navigate = navigation[name]
  navigation[name] = function(...)
    local echo = vim.api.nvim_echo
    vim.api.nvim_echo = function(chunks, ...)
      if chunks[1] and chunks[1][2] == 'WarningMsg' then return end
      return echo(chunks, ...)
    end
    local result = { pcall(navigate, ...) }
    vim.api.nvim_echo = echo
    if not result[1] then error(result[2], 0) end
    return unpack(result, 2)
  end
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'CodeDiffOpen',
  callback = function()
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      vim.wo[win].cursorline = false
    end
  end,
})

vim.keymap.set('n', '<leader>dm', '<cmd>CodeDiff origin/master...<cr>',
  { silent = true, desc = 'code(diff) review (origin/master...)' })
vim.keymap.set('n', '<leader>dd', '<cmd>CodeDiff HEAD<cr>', { silent = true, desc = 'code(diff) review (HEAD~)' })

-- Diff against the local branch this one was forked from, guessed as the one whose merge base is the fewest commits
-- behind HEAD (then the one with the fewest commits of its own, then the default branch). The remote default branch
-- competes too: the local one lags behind it until pulled, and a branch forked off the local one in between would
-- otherwise win, its own commits showing in the diff. Prints the remote default branch, the current branch, the git
-- common dir, then "<commits ahead of HEAD> <commits HEAD is ahead> <branch>" for every local branch and the remote
-- default one.
local base_candidates = [[
  remote_default=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null)
  echo "$remote_default"
  git branch --show-current
  git rev-parse --path-format=absolute --git-common-dir
  git for-each-ref --format='%(ahead-behind:HEAD) %(refname:short)' refs/heads ${remote_default:+"refs/remotes/$remote_default"}
]]

-- A branch's oldest reflog entry: its time, and whether it is the branch's creation (older ones may have expired)
local first_reflog_entry = function(git_dir, branch)
  local file = io.open(git_dir .. '/logs/refs/heads/' .. branch)
  if not file then return end
  local line = file:read('l') or ''
  file:close()
  return tonumber(line:match('^[^>]*> (%d+) ')), line:find('\tbranch: Created from', 1, true) ~= nil
end

vim.keymap.set('n', '<leader>db', function()
  vim.system({ 'sh', '-c', base_candidates }, { text = true }, function(res)
    local lines = vim.split(res.stdout or '', '\n', { trimempty = false })
    local remote_default = lines[1] ~= '' and lines[1] or nil
    local default = remote_default and remote_default:gsub('^origin/', '')
    local current, git_dir = lines[2], lines[3]
    if current == default then
      return vim.schedule(function()
        vim.notify(default .. ' is the default branch, nothing to show', vim.log.levels.WARN, { title = 'CodeDiff' })
      end)
    end
    -- A branch created after this one can't be its base: it was forked from it, and has diverged since
    local since = first_reflog_entry(git_dir, current)
    local younger = function(branch)
      local time, creation = first_reflog_entry(git_dir, branch)
      return since and time and creation and time > since
    end
    local closer = function(a, b)
      if a.distance ~= b.distance then return a.distance < b.distance end
      if a.own ~= b.own then return a.own < b.own end
      return a.ref == remote_default or a.ref == default and b.ref ~= remote_default
    end
    local base
    for i = 4, #lines do
      local own, distance, ref = lines[i]:match('^(%d+) (%d+) (.+)$')
      local candidate = { own = tonumber(own), distance = tonumber(distance), ref = ref }
      -- A distance of 0 means the branch contains HEAD (the current branch, or one stacked on top of it)
      if ref and candidate.distance > 0 and not younger(ref) and (not base or closer(candidate, base)) then
        base = candidate
      end
    end
    base = base and base.ref or remote_default
    vim.schedule(function()
      if not base then
        return vim.notify('Could not determine base branch', vim.log.levels.WARN, { title = 'CodeDiff' })
      end
      vim.notify('Diffing against ' .. base, vim.log.levels.INFO, { title = 'CodeDiff' })
      vim.cmd('CodeDiff ' .. base .. '...')
    end)
  end)
end, { desc = 'code(diff) review (base branch...)' })

------------------------------------------------------| Gitsigns |------------------------------------------------------

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
    vim.keymap.set(modes, '<leader>gw', gitsigns.stage_buffer, { desc = 'Stage all hunks (buffer)' })
    vim.keymap.set(modes, '<leader>gR', gitsigns.reset_buffer_index, { desc = 'Unstage all hunks (buffer)' })
    vim.keymap.set(modes, '<leader>gr', async_git({ 'checkout', '%' }), { desc = 'Git checkout' })
    vim.keymap.set(modes, '<leader>gq', function()
      gitsigns.setqflist('all')
    end, { remap = true, desc = 'Git reset' })
  end
})
