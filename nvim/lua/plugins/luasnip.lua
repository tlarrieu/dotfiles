local edit_snippet = function(ft)
  require('luasnip.loaders').edit_snippet_files({
    ft_filter = function(filetype) return filetype == ft end
  })
end

return {
  'L3MON4D3/LuaSnip',
  version = '*',
  build = 'make install_jsregexp',
  event = { 'ModeChanged' },
  keys = {
    { '<leader>es', function() edit_snippet(vim.bo.filetype) end, desc = 'Edit snippets (current filetype)' },
    { '<leader>eS', function() edit_snippet('all') end, desc = 'Edit snippets (all)' },
  },
  config = function()
    local ls = require('luasnip')
    ls.setup({
      enable_autosnippets = true,
      store_selection_keys = '<tab>',
      update_events = { 'TextChanged', 'TextChangedI' },
      snip_env = {
        h = require('helpers'),
        sel = function(indent)
          indent = indent or 1
          return ls.indent_snippet_node(
            nil,
            { ls.function_node(function(_, snip) return snip.parent.env.TM_SELECTED_TEXT end) },
            '$PARENT_INDENT' .. ('\t'):rep(indent)
          )
        end,
        cap = function(i)
          return ls.function_node(function(_, snip) return snip.captures[i] end)
        end,
        rs = function(str, ...)
          return ls.snippet({ trig = str, regTrig = true }, ...)
        end,
      }
    })
    require('luasnip.loaders.from_lua').lazy_load({ paths = os.getenv('HOME') .. '/.config/nvim/snippets' })
  end
}
