local list = function() return require('harpoon'):list() end

return {
  'ThePrimeagen/harpoon',
  branch = "harpoon2",
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<c-$>', function() list():add() end,     desc = 'Harpoon: add file' },

    { '<c-">', function() list():select(1) end, desc = 'Harpoon: open #1' },
    { '<c-«>', function() list():select(2) end, desc = 'Harpoon: open #2' },
    { '<c-»>', function() list():select(3) end, desc = 'Harpoon: open #3' },
    { '<c-(>', function() list():select(4) end, desc = 'Harpoon: open #4' },
    { '<c-)>', function() list():select(5) end, desc = 'Harpoon: open #5' },

    {
      "<c-,>",
      function()
        local harpoon = require('harpoon')
        harpoon.ui:toggle_quick_menu(harpoon:list(), {
          title = ' ⇁ Harpoon ',
          title_pos = 'left',
          border = 'single',
        })
      end,
      desc = 'Harpoon: edit list'
    },
  },
  config = true,
}
