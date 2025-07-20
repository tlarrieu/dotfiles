local o = vim.opt_local

o.conceallevel = 0
o.concealcursor = 'cni'
o.iskeyword = o.iskeyword + '?' + '!'
o.spell = true

local group = vim.api.nvim_create_augroup('ruby_autocmd', {})
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.rb' },
  callback = function() o.indentkeys:remove({ '.', ':' }) end,
  group = group
})

local runner = require('runner')
runner.default({ main = runner.term('ruby %', { open = false }) })
runner.match({ 'Gemfile', '*.gemspec' }, { main = runner.term('bundle') })
runner.match('config/routes.rb', { main = runner.term('rails routes') })

require('utils').autoformat({ '*.rb', '*.json.jbuilder' })

local alternate = function()
  local path = vim.api.nvim_buf_get_name(0)
  local alt
  if path:match("spec") then
    alt = path
        :gsub("(.*)/spec/requests/(.*)_spec%.rb", "%1/app/controllers/%2.rb")
        :gsub("(.*)/spec/(.*)_spec%.rb", "%1/app/%2.rb")
  else
    alt = path
        :gsub("(.*)/app/controllers/(.*)%.rb", "%1/spec/requests/%2_spec.rb")
        :gsub("(.*)/app/(.*)%.rb", "%1/spec/%2_spec.rb")
  end
  vim.cmd.edit(alt)
end

vim.keymap.set('n', '<c-$>', alternate, { silent = true, buffer = true })

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
