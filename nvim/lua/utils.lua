local _M = {}

_M.autocapitalize = function(pattern)
  vim.api.nvim_create_autocmd('InsertCharPre', {
    pattern = pattern,
    callback = function()
      if vim.fn.search( "\\v(%^|[.!?]\\_s|\\n\\n)\\_s*%#", 'bcnw') ~= 0 then
        vim.cmd([[let v:char = toupper(v:char)]])
      end
    end,
    group = vim.api.nvim_create_augroup(vim.inspect(pattern) .. '_SENTENCE', {})
  })
end

return _M
