require('telescope').setup{
  defaults = {
    border = true,

    prompt_prefix = '   ',
    selection_caret = ' ',
    multi_icon = ' ',

    sorting_strategy = "ascending",
    layout_config = {
      prompt_position="top",
    },

    mappings = {
      i = {
        ["<esc>"] = require('telescope.actions').close,
      },
    }
  },
  pickers = {
  },
  extensions = {
  }
}
