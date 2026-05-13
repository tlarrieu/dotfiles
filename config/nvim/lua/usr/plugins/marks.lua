vim.pack.add({ 'https://github.com/chentoast/marks.nvim' }, { confirm = false })

require('marks').setup({
  signs = true,
  default_mappings = true,
  builtin_marks = {},
  cyclic = true,
  force_write_shada = true,
  refresh_interval = 150,
  sign_priority = { lower = 0, upper = 15, builtin = 100, bookmark = 20 },
  excluded_filetypes = { 'harpoon', '', 'notify', 'TelescopePrompt' },
  bookmark_0 = {
    sign = '󰈾',
    virt_text = '✖ Something is weird in here',
    annotate = false,
  },
  mappings = {}
})
