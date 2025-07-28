return {
  'mbbill/undotree',
  keys = {
    {
      '<leader>c',
      function()
        vim.cmd.UndotreeToggle()
        vim.cmd.UndotreeFocus()
      end,
    },
  },
  config = function()
    vim.g.undotree_WindowLayout = '2'
  end
}
