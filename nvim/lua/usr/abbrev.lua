-- Command line shorthand
local abbr = {
  mkdir = 'Mkdir',
  mv = 'Rename',
  rm = 'Delete',
  ['rm!'] = 'Delete!',
  gv = 'GV',
  h = 'tab h',
  hi = "lua require('telescope.builtin').highlights()",
  lazy = 'Lazy',
  mason = 'Mason',
  map = "lua require('telescope.builtin').keymaps({lfs_filter = true })",
  ins = "Inspect",
  tree = "InspectTree",
}

for key, value in pairs(abbr) do
  vim.cmd.cnoreabbrev(
    '<expr>',
    key,
    [[getcmdtype() == ":" && getcmdline() == ']] .. key .. [[' ? "]] .. value .. [[" : ']] .. key .. [[']]
  )
end
