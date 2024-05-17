vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'COMMIT_EDITMSG',
  callback = function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    print(vim.inspect(first_line))
    if first_line == '' then
      vim.cmd.startinsert({ bang = true })
    end
    vim.keymap.set( { 'n', 'i' }, '<c-s>', vim.cmd.x, { silent = true, buffer = 0 })
  end,
  group = vim.api.nvim_create_augroup('GIT_AUTOCMD', {})
})

require('utils').autocapitalize('COMMIT_EDITMSG')

vim.opt_local.spell = true
