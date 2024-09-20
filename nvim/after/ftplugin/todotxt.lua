vim.keymap.set('n', 'gs', function()
  local line = vim.api.nvim_get_current_line()
  if line:match('^x ') then
    local newline = line:gsub('^x ', '')
    vim.api.nvim_set_current_line(newline)
  else
    vim.api.nvim_set_current_line('x ' .. line)
  end
end)
