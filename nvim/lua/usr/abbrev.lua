-- Command line shorthand
local abbr = {
  mkdir = 'Mkdir',
  mv = 'Rename',
  rm = 'Delete',
  gv = 'GV',
  h = 'tab h',
  hi = 'lua require("telescope.builtin").highlights()',
  lazy = 'Lazy',
  mason = 'Mason',
  map = "Map",
}

vim.api.nvim_create_user_command('Map', function(opts)
  local window_name = 'mappings'
  -- clear previous buffer if it exists
  pcall(vim.cmd.bd, { window_name, bang = true })
  vim.cmd.vnew(window_name)

  vim.opt_local.buftype = 'nofile'
  vim.opt_local.bufhidden = 'wipe'
  vim.opt_local.swapfile = false

  vim.keymap.set('n', 'q', ':quit<cr>', { buffer = true, silent = true })

  vim.cmd("put=execute('map " .. opts.args .. "')")
  vim.cmd("put=execute('imap " .. opts.args .. "')")
  vim.cmd("g/^$/d_")
  vim.cmd("g/No mapping found/d_")

  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end, { nargs = 1, desc = 'show map result in a split' })

for key, value in pairs(abbr) do
  vim.cmd.cnoreabbrev(
    '<expr>',
    key,
    [[getcmdtype() == ":" && getcmdline() == ']] .. key .. [[' ? "]] .. value .. [[" : ']] .. key .. [[']]
  )
end
