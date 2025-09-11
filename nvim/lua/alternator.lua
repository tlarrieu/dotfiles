local M = {}

M.alternate = function(mapping)
  local path = vim.api.nvim_buf_get_name(0)

  for _, opts in ipairs(mapping) do
    if path:match(opts.pattern) then
      path = path:gsub(opts.pattern, opts.target)
      return vim.cmd.edit(path)
    end
  end
end

return M
