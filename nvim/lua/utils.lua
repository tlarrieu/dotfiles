local M = {}

M.autocapitalize = function(pattern)
  vim.api.nvim_create_autocmd('InsertCharPre', {
    pattern = pattern,
    callback = function()
      if vim.fn.search("\\v(%^|[.!?]\\_s|\\n\\n)\\_s*%#", 'bcnw') ~= 0 then
        vim.cmd([[let v:char = toupper(v:char)]])
      end
    end,
    group = vim.api.nvim_create_augroup(vim.inspect(pattern) .. '_SENTENCE', {})
  })
end

M.autoformat = function(pattern)
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = pattern,
    callback = function() require('conform').format() end,
    group = vim.api.nvim_create_augroup('autoformat_' .. vim.inspect(pattern), {})
  })
end

M.trim_trailing_spaces = function()
  vim.cmd [[
    normal! m`
    let _s=@/
    %substitute/\v(^\s+$|[\\]\s\zs\s+$|[^\\]\zs\s+$)//e
    let @/=_s
    nohl
    normal! g``
  ]]
end

return M
