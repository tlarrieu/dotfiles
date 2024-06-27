return {
  'ThePrimeagen/harpoon',
  branch = "harpoon2",
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local harpoon = require('harpoon')

    harpoon:setup()

    local k = vim.keymap

    k.set('n', '<leader>$', function() harpoon:list():add() end)

    k.set('n', '<c-">', function() harpoon:list():select(1) end)
    k.set('n', '<c-«>', function() harpoon:list():select(2) end)
    k.set('n', '<c-»>', function() harpoon:list():select(3) end)
    k.set('n', '<c-(>', function() harpoon:list():select(4) end)
    k.set('n', '<c-)>', function() harpoon:list():select(4) end)

    vim.keymap.set("n", "<c-b>", function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), {
        title = 'Harpoon',
        title_pos = 'left',
        border = 'single',
      })
    end)
  end,
}
