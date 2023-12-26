return {
  'SirVer/ultisnips',
  config = function()
    vim.g.UltiSnipsRemoveSelectModeMappings = 1
    vim.g.UltiSnipsEditSplit = 'vertical'
    vim.g.UltiSnipsExpandOrJumpTrigger = '<tab>'
    vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
    vim.g.UltiSnipsSnippetDirectories = { os.getenv("HOME") .. '/.config/nvim/UltiSnips' }
  end
}
