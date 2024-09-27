local list = function() return require('harpoon'):list() end

return {
  'ThePrimeagen/harpoon',
  branch = "harpoon2",
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { '<c-$>', function() list():add() end },

    { '<c-">', function() list():select(1) end },
    { '<c-«>', function() list():select(2) end },
    { '<c-»>', function() list():select(3) end },
    { '<c-(>', function() list():select(4) end },
    { '<c-)>', function() list():select(4) end },

    { "<c-b>", function()
      local harpoon = require('harpoon')
      harpoon.ui:toggle_quick_menu(harpoon:list(), {
        title = ' ⇁ Harpoon ',
        title_pos = 'left',
        border = 'single',
      })
    end },
  },
  config = true,
}
