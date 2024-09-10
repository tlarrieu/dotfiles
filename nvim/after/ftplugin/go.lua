vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'cni'
vim.opt_local.expandtab = false

local runner = require('runner')

runner.default({
  main = runner.term('go run .'),
  alt = runner.test.last(),
})

runner.match({ '*_test.go' }, {
  main = runner.test.nearest(),
  alt = runner.test.file()
})

local group = vim.api.nvim_create_augroup('GO_AUTOCMD', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
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
  end,
  group = group
})
