-- Source local nvimrc on save
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '.nvim.lua',
  callback = function()
    vim.secure.trust({ action = 'allow', bufnr = 0 })
    vim.cmd.source('.nvim.lua')
  end,
})

-- Balance splits size upon changing host window size
vim.api.nvim_create_autocmd('VimResized', { callback = function() vim.api.nvim_input('<esc><c-w>=') end })

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ctx)
    -- Do not insert comments upon <cr> or o/O
    vim.opt_local.formatoptions:remove({ 'o', 'r' })

    -- do not show listchars on certain filetypes
    for _, ft in ipairs({ 'help', 'man', 'codediff-explorer', 'floggraph' }) do
      if ctx.match == ft then vim.opt_local.list = false end
    end
  end
})

-- Toggle relative numbering for active window only
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' },
  { callback = function() if vim.wo.number then vim.wo.relativenumber = true end end })
vim.api.nvim_create_autocmd('WinLeave', { callback = function() vim.wo.relativenumber = false end })

-- highlight yank
vim.api.nvim_create_autocmd('TextYankPost',
  { callback = function() vim.hl.on_yank({ higroup = "Visual", timeout = 200, on_visual = false }) end })

-- set git root directory as local working directory (useful when editing snippets on the fly for instance)
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if vim.bo.filetype == 'oil' then
      vim.cmd.lcd(require('oil').get_current_dir())
      return
    end

    local path = vim.system({
      'git',
      '-C',
      vim.fs.dirname(vim.fn.resolve(vim.fn.expand('%'))),
      'rev-parse',
      '--show-toplevel',
    }):wait().stdout:gsub('\n', '')
    if path ~= '' then vim.cmd.lcd(path) end
  end,
})

-- auto hide statusline when entering command line
vim.api.nvim_create_autocmd('CmdlineEnter', { callback = function() vim.opt.laststatus = 0 end })
vim.api.nvim_create_autocmd('CmdlineLeave', { callback = function() vim.opt.laststatus = 3 end })
