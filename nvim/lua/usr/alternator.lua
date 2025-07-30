local M = {}

M.alternate = function(mapping)
  local path = vim.api.nvim_buf_get_name(0)

  for pattern, replacement in pairs(mapping) do
    if path:match(pattern) then
      path = path:gsub(pattern, replacement)
      return vim.cmd.edit(path)
    end
  end
end

return M
