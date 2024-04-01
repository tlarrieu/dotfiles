-- Command line shorthand
local abbr = {
  mkdir = '!mkdir',
  gv = 'GV',
  h = 'tab h',
}

for key, value in pairs(abbr) do
  vim.cmd.cnoreabbrev(
    '<expr>',
    key,
    [[getcmdtype() == ":" && getcmdline() == ']] .. key .. [[' ? ']] .. value .. [[' : ']] .. key .. [[']]
  )
end
