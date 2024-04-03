-- Command line shorthand
local abbr = {
  mkdir = '!mkdir',
  gv = 'GV',
  h = 'tab h',
  hi = 'lua require("telescope.builtin").highlights()',
}

for key, value in pairs(abbr) do
  vim.cmd.cnoreabbrev(
    '<expr>',
    key,
    [[getcmdtype() == ":" && getcmdline() == ']] .. key .. [[' ? ']] .. value .. [[' : ']] .. key .. [[']]
  )
end
