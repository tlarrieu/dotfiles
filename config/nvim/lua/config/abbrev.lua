require('pack')

-- Command line shorthand
local abbr = {
  mkdir = 'Mkdir',
  mv = 'Rename',
  rm = 'Delete',
  ['rm!'] = 'Delete!',
  h = 'tab h',
  hi = "lua require('telescope.builtin').highlights()",
  map = "lua require('telescope.builtin').keymaps({lfs_filter = true })",
  mason = 'Mason',
  fid = 'Fidget',
  ins = 'Inspect',
  ts = 'InspectTree',
  man = 'tab Man',
  ls = 'PackUpdate',
  pp = 'PackPurge',
  dd = 'CodeDiff',
}

for key, value in pairs(abbr) do
  vim.cmd.cnoreabbrev(
    '<expr>',
    key,
    [[getcmdtype() == ":" && getcmdline() == ']] .. key .. [[' ? "]] .. value .. [[" : ']] .. key .. [[']]
  )
end
