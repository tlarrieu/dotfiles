local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.iskeyword = o.iskeyword + '?' + '!'
o.spell = true

local runner = require('runner2')

local rspec = function(opts)
  local testbus = require('testbus')

  opts = opts or {}

  local fname = vim.api.nvim_buf_get_name(0)
  local line = vim.api.nvim_win_get_cursor(0)[1]

  local cmd = { 'bundle', 'exec', 'rspec' }
  for _, option in ipairs(testbus.adapters.rspec.options) do table.insert(cmd, option) end

  local location = fname .. (opts.at_cursor and (':' .. line) or '')
  if location then table.insert(cmd, location) end

  return {
    on_start = testbus.start,
    on_stdout = testbus.redraw,
    on_interrupt = testbus.interrupt,
    on_clean = function()
      testbus.interrupt()
      testbus.clear()
    end,
    on_bufenter = function() if testbus.is_awaiting() then vim.cmd.startinsert() end end,
    winbar = ' RSpec',
    cmd = cmd,
  }
end

vim.keymap.set('n', '<cr>',
  function() runner.run({ cmd = { 'ruby', vim.fn.expand('%') } }) end,
  { desc = 'Execute with ruby', buffer = true })

local bufname = vim.api.nvim_buf_get_name(0)
if bufname:match('Gemfile') or bufname:match('*.gemspec') then
  vim.keymap.set('n', '<cr>',
    function() runner.run({ cmd = { 'bundle', 'install' }, winbar = ' bundle install' }) end,
    { desc = 'Run bundler', buffer = true })
elseif bufname:match('config/routes.rb') then
  vim.keymap.set('n', '<cr>',
    function() runner.run({ cmd = { 'rails', 'routes' }, winbar = '󰑪 rails routes' }) end,
    { desc = 'Run rails routes', buffer = true })
elseif bufname:match('.*_spec.rb') then
  vim.keymap.set('n', '<leader>tr', function() runner.run(rspec({ at_cursor = true })) end,
    { desc = 'Run nearest test', buffer = true })
  vim.keymap.set('n', '<leader>tf', function() runner.run(rspec({ at_cursor = false })) end,
    { desc = 'Run test file', buffer = true })
end

require('utils').autoformat({ '*.json.jbuilder', '*.rake', '*.rb', '.pryrc', '.pryrc.local' })

require('alternator').setup({
  { pattern = "(.*)/tax_returns/consistency_checks/index.json.jbuilder", target = "%1/tax_returns/forms/show.json.jbuilder" },
  { pattern = "(.*)/tax_returns/forms/show.json.jbuilder", target = "%1/tax_returns/consistency_checks/index.json.jbuilder" },

  { pattern = "(.*)/spec/requests/(.*)_spec%.rb", target = "%1/app/controllers/%2.rb" },
  { pattern = "(.*)/app/controllers/(.*)%.rb", target = "%1/spec/requests/%2_spec.rb" },

  { pattern = "(.*)/spec/config/(.*)_spec%.rb", target = "%1/config/%2.rb" },
  { pattern = "(.*)/config/(.*)%.rb", target = "%1/spec/config/%2_spec.rb" },

  { pattern = "(.*)/spec/(.*)_spec%.rb", target = "%1/app/%2.rb" },
  { pattern = "(.*)/app/(.*)%.rb", target = "%1/spec/%2_spec.rb" },
})

local params_for = function(kind, root)
  return {
    hidden = true,
    path_display = { 'filename_first', shorten = { len = 1, exclude = { 1, -3, -2, -1 } } },
    find_command = { 'fd', '-tf', '--hidden', '-p', (root or 'app') .. '/' .. kind },
    results_title = ' ' .. kind,
  }
end

vim.keymap.set('n', '<a-c>', function()
  return require('telescope.builtin').find_files(params_for('controllers'))
end, { desc = 'Telescope controllers lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-m>', function()
  return require('telescope.builtin').find_files(params_for('models'))
end, { desc = 'Telescope models lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-v>', function()
  return require('telescope.builtin').find_files(params_for('views'))
end, { desc = 'Telescope views lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-s>', function()
  return require('telescope.builtin').find_files(params_for('services'))
end, { desc = 'Telescope services lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-j>', function()
  return require('telescope.builtin').find_files(params_for('jobs'))
end, { desc = 'Telescope jobs lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-d>', function()
  return require('telescope.builtin').find_files(params_for('lib'))
end, { desc = 'Telescope POROs lookup (Ruby on Rails)' })
vim.keymap.set('n', '<a-f>', function()
  return require('telescope.builtin').find_files(params_for('fixtures', 'spec'))
end, { desc = 'Telescope fixtures lookup (Ruby on Rails)' })

local rootnode = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, 'ruby', {})
  return parser and parser:parse()[1]:root() or nil
end

---@param cursor table<integer>
---@param region table<integer>
local cursor_in_region = function(cursor, region)
  local currow, curcol = cursor[1], cursor[2]
  local start_row, start_col, end_row, end_col = region[1], region[2], region[3], region[4]

  if start_row + 1 <= currow and currow <= end_row + 1 then
    if start_row + 1 == currow then
      return start_col <= curcol
    elseif end_row + 1 == currow then
      return end_col - 1 >= curcol
    else
      return true
    end
  end

  return false
end

local queries = {
  shared_examples = vim.treesitter.query.parse('ruby', [[
    (
      (identifier) @identifier (#any-of? @identifier "it_behaves_like" "include_examples")
      (argument_list
        (string (string_content) @label)+)) @block
  ]]),
  shared_context = vim.treesitter.query.parse('ruby', [[
    (
      (identifier) @identifier (#eq? @identifier "include_context")
      (argument_list
        (string (string_content) @label)+)) @block
  ]]),
}
local label_for = function(bufnr, cursor, qname)
  local query = queries[qname]
  if not query then return end

  local label, range
  for id, node in query:iter_captures(rootnode(bufnr), bufnr, 0, -1) do
    if query.captures[id] == 'block' then range = { node:range() } end
    if query.captures[id] == 'label' then label = vim.treesitter.get_node_text(node, bufnr) end

    if label and range then
      if cursor_in_region(cursor, range) then return label end
      label, range = nil, nil
    end
  end
end

vim.keymap.set('n', 'gd', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local shared_examples = label_for(bufnr, cursor, 'shared_examples')
  if shared_examples then return vim.cmd.grep { 'shared_examples[\\( ].' .. shared_examples, mods = { silent = true } } end

  local shared_context = label_for(bufnr, cursor, 'shared_context')
  if shared_context then return vim.cmd.grep { 'shared_context[\\( ].' .. shared_context, mods = { silent = true } } end

  require('telescope.builtin').lsp_definitions()
end, { silent = true, buffer = true })
