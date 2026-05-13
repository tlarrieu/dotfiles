vim.pack.add({ 'https://github.com/zbirenbaum/copilot.lua' }, { confirm = false })

require('copilot').setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})
