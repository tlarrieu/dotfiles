local _M = {}

_M.autocapitalize = function(pattern)
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

_M.autoformat = function(pattern)
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = pattern,
    callback = function() require('conform').format() end,
    group = vim.api.nvim_create_augroup('autoformat_' .. vim.inspect(pattern), {})
  })
end

_M.fiximports = function()
  local params = vim.lsp.util.make_range_params()
  params.context = { only = { 'source.organizeImports' } }
  local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, 1000)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local encoding = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
        vim.lsp.util.apply_workspace_edit(r.edit, encoding)
      end
    end
  end
end

_M.autoimport = function(pattern)
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = pattern,
    callback = _M.fiximports,
    group = vim.api.nvim_create_augroup('autoimport_' .. vim.inspect(pattern), {})
  })
end

return _M
