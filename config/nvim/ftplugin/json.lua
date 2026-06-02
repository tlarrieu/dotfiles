require('runner').setup({
  overrides = {
    {
      patterns = { 'coloriage/palettes' },
      main = {
        args = function()
          return {
            cmd = { 'just', 'apply', vim.fn.expand('%:t:r') },
            cwd = vim.fs.normalize(vim.fs.abspath(vim.fn.expand('%:r') .. '/../..')),
            winbar = '󰸌 coloriage',
          }
        end,
        desc = 'Run coloriage',
      },
    }
  },
})
