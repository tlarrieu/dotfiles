-- do not set any keymaps
vim.g.no_plugin_maps = true

vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = 'cni'
vim.opt_local.expandtab = false
vim.opt_local.spell = true

local runner = require('runner')
runner.default({
  main = runner.term('go run .'),
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params(0, 'utf-8')
    params.context = { only = { 'source.organizeImports' } }
    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({ async = false })
  end
})
