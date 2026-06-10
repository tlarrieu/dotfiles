vim.opt_local.conceallevel = 0
vim.opt_local.concealcursor = 'cni'
vim.opt_local.iskeyword:append({ '?', '!' })
vim.opt_local.spell = true

local helpers = require('helpers')

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
    if require('helpers').fileexists('bin/rspec-auto') then
      scope = '(bin/rspec-auto)'
      cmd = { 'bundle', 'exec', 'rspec' }

      local handle = io.popen([[
        bin/rspec-auto --list 2> /dev/null |
          grep 'Specs related to your changes' -A 100 |
          sed 1d |
          awk '{print $2}'
      ]])
      if handle then
        for line in string.gmatch(handle:read("*a"), '([^\n]+)') do table.insert(locations, line) end
        handle:close()
      else
        cmd = { 'echo', "couldn't not run bin/rspec-auto" }
      end
    else
      scope = '(all)'
    end
  else
    locations = { vim.api.nvim_buf_get_name(0) .. (opts.at_cursor and (':' .. vim.api.nvim_win_get_cursor(0)[1]) or '') }
    scope = opts.at_cursor and '(cursor)' or '(file)'
  end

  local testbus = require('testbus')

  for _, option in ipairs(testbus.adapters.rspec.options) do table.insert(cmd, option) end
  for _, location in ipairs(locations) do table.insert(cmd, location) end

  return {
    on_start = function()
      vim.notify('Running rspec on:', vim.log.levels.INFO)
      for _, location in ipairs(locations) do
        local short_location = location:gsub('^' .. vim.uv.cwd() .. '/', '')
        local length = #short_location
        if length > 77 then
          short_location = '  ' .. short_location:sub(length - 71, length)
        end
        vim.notify(short_location, vim.log.levels.INFO)
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
      if require('helpers').fileexists('bin/rails') then
        return { cmd = { 'bin/rails', 'console' }, winbar = '󰫏 rails console' }
      else
        return { cmd = { 'pry', }, winbar = ' pry' }
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

vim.keymap.set('n', '<c-s-p>', '<cmd>silent grep! Kernel.binding.pry<cr>')

local find_files = function(kind, root)
  local params = {
    hidden = true,
    path_display = { 'filename_first', shorten = { len = 1, exclude = { 1, -3, -2, -1 } } },
    find_command = { 'fd', '-tf', '--hidden', '-p', (root or 'app') .. '/' .. kind },
    results_title = ' ' .. kind,
  }
  return function() require('telescope.builtin').find_files(params) end
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

local t = require('telescope.builtin')
local globs = '-g "*.{rb,erb,rake}" -g "bin/*"'
local def_pattern = '(def( self.)?|module|class)'
local cword = function() return vim.fn.expand('<cword>') .. '([ :(]|\\$)' end
local grep = function(pattern, bang) vim.cmd.grep { pattern, bang = bang, mods = { silent = true } } end
local lgrep = function(pattern, bang) vim.cmd.lgrep { pattern, bang = bang, mods = { silent = true } } end

vim.keymap.set('n', 'gd', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)

  local shared_examples = label_for(bufnr, cursor, 'shared_examples')
  if shared_examples then return lgrep(('"shared_examples[\\( ].%s"'):format(shared_examples)) end

  local shared_context = label_for(bufnr, cursor, 'shared_context')
  if shared_context then return lgrep(('"shared_context[\\( ].%s"'):format(shared_context)) end

  grep(('-s "%s %s" %s'):format(def_pattern, cword(), globs))
  t.quickfix { results_title = '  definition(s)', show_line = false }
end, { silent = true, buffer = true })

vim.keymap.set('n', 'gr', function()
  grep(('-s "%s" %s'):format(cword(), globs))
  t.quickfix { results_title = '  reference(s)', show_line = false }
end, { silent = true, buffer = true })
