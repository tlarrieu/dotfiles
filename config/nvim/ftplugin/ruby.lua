vim.opt_local.conceallevel = 0
vim.opt_local.concealcursor = 'cni'
vim.opt_local.iskeyword:append({ '?', '!' })
vim.opt_local.spell = true

local helpers = require('helpers')
local telescope = require('telescope.builtin')

local grep = function(pattern, bang, prefill)
  vim.cmd.grep { pattern, bang = bang, mods = { silent = true } }

  local qflist = vim.fn.getqflist({ size = 0, items = {} })
  local size = tonumber(qflist.size)

  if size > 1 then
    telescope.quickfix({ results_title = '󰁨 quickfix', show_line = false, default_text = prefill })
  elseif size == 1 then
    local item = qflist.items[1]
    vim.cmd.buffer(item.bufnr)
    vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
  else
    vim.notify('No result', vim.log.levels.WARN)
  end
end
local lgrep = function(pattern, bang) vim.cmd.lgrep { pattern, bang = bang, mods = { silent = true } } end

local rspec = function(opts)
  opts = opts or {}

  local cmd

  if helpers.fileexists('bin/rspec') then
    cmd = { 'bin/rspec' }
  elseif helpers.fileexists('Gemfile') then
    cmd = { 'bundle', 'exec', 'rspec' }
  else
    cmd = { 'rspec' }
  end

  local locations = {}
  local scope

  if opts.all then
    if helpers.fileexists('bin/rspec-auto') then
      scope = '(bin/rspec-auto)'
      cmd = { os.getenv('HOME') .. '/scripts/rspec-auto' }
    else
      scope = '(all)'
    end
  else
    locations = { vim.api.nvim_buf_get_name(0) .. (opts.at_cursor and (':' .. vim.api.nvim_win_get_cursor(0)[1]) or '') }
    scope = opts.at_cursor and '(cursor)' or '(file)'
  end

  local testbus = require('testbus')

  table.insert(cmd, '--fail-fast')
  for _, option in ipairs(testbus.adapters.rspec.options) do table.insert(cmd, option) end
  for _, location in ipairs(locations) do table.insert(cmd, location) end

  return {
    on_start = function()
      if #locations > 0 then
        vim.notify('Running rspec on:', vim.log.levels.INFO)
        for _, location in ipairs(locations) do
          local short_location = location:gsub('^' .. vim.uv.cwd() .. '/', '')
          local length = #short_location
          if length > 77 then
            short_location = '  ' .. short_location:sub(length - 71, length)
          end
          vim.notify(short_location, vim.log.levels.INFO)
        end
      else
        vim.notify('Running rspec (all)', vim.log.levels.INFO)
      end
      testbus.start()
    end,
    on_stdout = testbus.redraw,
    on_interrupt = testbus.interrupt,
    on_clean = function()
      testbus.interrupt()
      testbus.clear()
    end,
    on_bufenter = function() if testbus.is_awaiting() then vim.cmd.startinsert() end end,
    winbar = ' RSpec ' .. scope,
    cmd = cmd,
  }
end

require('runner').setup({
  main = { args = { cmd = { 'ruby', vim.fn.expand('%') }, winbar = ' ruby %%' }, desc = 'Execute with ruby' },
  all = { args = function() return rspec({ all = true }) end, desc = 'Run test suite' },
  repl = {
    args = function()
      if helpers.fileexists('bin/rails') then
        return { cmd = { 'bin/rails', 'console' }, winbar = '󰫏 rails console' }
      else
        return { cmd = { 'pry' }, winbar = ' pry' }
      end
    end,
    desc = 'Start ruby console'
  },
  overrides = {
    {
      patterns = { 'Gemfile', '*.gemspec' },
      main = { args = { cmd = { 'bundle', 'install' }, winbar = ' bundle install', }, desc = 'Run bundler' },
    },
    {
      patterns = { '.*_spec.rb' },
      nearest = { args = function() return rspec({ at_cursor = true }) end, desc = 'Run nearest test' },
      file = { args = function() return rspec({ at_cursor = false }) end, desc = 'Run test file' },
    },
  }
})

require('alternator').setup({
  { pattern = "(.*)/tax_returns/consistency_checks/index.json.jbuilder", target = "%1/tax_returns/forms/show.json.jbuilder" },
  { pattern = "(.*)/tax_returns/forms/show.json.jbuilder", target = "%1/tax_returns/consistency_checks/index.json.jbuilder" },

  { pattern = "(.*)/spec/requests/(.*)_spec%.rb", target = "%1/app/controllers/%2.rb" },
  { pattern = "(.*)/app/controllers/(.*)%.rb", target = "%1/spec/requests/%2_spec.rb" },

  { pattern = "(.*)/spec/config/(.*)_spec%.rb", target = "%1/config/%2.rb" },
  { pattern = "(.*)/config/(.*)%.rb", target = "%1/spec/config/%2_spec.rb" },

  { pattern = "(.*)/spec/(.*)_spec%.rb", target = "%1/app/%2.rb" },
  { pattern = "(.*)/app/(.*)%.rb", target = "%1/spec/%2_spec.rb" },

  { pattern = "(.*)_spec%.rb", target = "%1.rb" },
  { pattern = "(.*)%.rb", target = "%1_spec.rb" },
})

vim.keymap.set('n', '<c-s-é>', function()
  grep('Kernel.binding.pry')
end)

local find_files = function(kind, root)
  local params = {
    hidden = true,
    path_display = { 'filename_first', shorten = { len = 1, exclude = { 1, -3, -2, -1 } } },
    find_command = { 'fd', '-tf', '--hidden', '-p', (root or 'app') .. '/' .. kind },
    results_title = ' ' .. kind,
  }
  return function() telescope.find_files(params) end
end
local lookup = function(kind) return 'Telescope ' .. kind .. ' lookup (Ruby on Rails)' end

vim.keymap.set('n', '<a-c>', find_files('controller'), { desc = lookup('controllers') })
vim.keymap.set('n', '<a-m>', find_files('models'), { desc = lookup('models') })
vim.keymap.set('n', '<a-v>', find_files('views'), { desc = lookup('views') })
vim.keymap.set('n', '<a-s>', find_files('services'), { desc = lookup('services') })
vim.keymap.set('n', '<a-j>', find_files('jobs'), { desc = lookup('jobs') })
vim.keymap.set('n', '<a-d>', find_files('lib'), { desc = lookup('POROs') })
vim.keymap.set('n', '<a-f>', find_files('fixtures', 'spec'), { desc = lookup('fixtures') })

local rootnode = function(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, 'ruby', {})
  return parser and parser:parse()[1]:root() or nil
end

---@param cursor table<integer>
---@param region table<integer>
local cursor_in_region = function(cursor, region)
  local currow, curcol = cursor[1], cursor[2]
  local start_row, start_col, end_row, end_col = region[1] + 1, region[2], region[3] + 1, region[4]

  if start_row <= currow and currow <= end_row then
    if start_row == currow then return start_col <= curcol end
    if end_row == currow then return end_col - 1 >= curcol end
    return true
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

local locate = function(expression, scope)
  grep(('-s "%s" -g "*.{rb,erb,rake}" -g "bin/*"'):format(expression), true, scope)
end

local locate_usage = function()
  locate(vim.fn.expand('<cword>') .. '([ :(.,]|\\$)')
end

local find_scope = function(cword)
  local cursor = vim.api.nvim_win_get_cursor(0)

  local query = vim.treesitter.query.parse('ruby', ([[
    ((call
      receiver: (scope_resolution
        scope: (_)
        name: (constant) @scope)?
      method: (identifier) @target) (#eq? @target "%s")) @range

    ((call
      receiver: ((constant) @scope)?
      method: (identifier) @target) (#eq? @target "%s")) @range

    ((scope_resolution
      scope: (scope_resolution
        scope: (_)
        name: (constant) @scope)
      name: (constant) @target) (#eq? @target "%s")) @range

    ((scope_resolution
      scope: (constant) @scope
      name: (constant) @target) (#eq? @target "%s")) @range
  ]]):format(cword, cword, cword, cword))

  local scope, range
  for id, node in query:iter_captures(rootnode(0), 0, 0, -1) do
    if query.captures[id] == 'range' then range = { node:range() } end
    if query.captures[id] == 'scope' then scope = vim.treesitter.get_node_text(node, 0) end

    if scope and range then
      if cursor_in_region(cursor, range) then break end
      scope, range = nil, nil
    end
  end

  if scope then return helpers.snakify(scope) end
end

local locate_definition = function()
  local cword = vim.fn.expand('<cword>')

  local scope = find_scope(cword)

  if cword == 'new' then cword = 'initialize' end

  local attr_expression = '(attr_reader|attr_writer|attr_accessor|has_one|belongs_to|has_many|Data.define).*:'
  local def_expression = '(def (self.)?|' .. attr_expression .. '|(module|class) )' .. cword .. '([ :(.,]|\\$)'
  local assign_expression = cword .. ' ?= ?'
  local full_expression = '(' .. def_expression .. ')|(' .. assign_expression .. ')'

  locate(full_expression, scope)
end

vim.keymap.set('n', 'gd', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local shared_examples = label_for(bufnr, cursor, 'shared_examples')
  if shared_examples then return lgrep(('"shared_examples[\\( ].%s"'):format(shared_examples)) end

  local shared_context = label_for(bufnr, cursor, 'shared_context')
  if shared_context then return lgrep(('"shared_context[\\( ].%s"'):format(shared_context)) end

  locate_definition()
end, { silent = true, buffer = true })

vim.keymap.set('n', 'gr', locate_usage, { silent = true, buffer = true })
