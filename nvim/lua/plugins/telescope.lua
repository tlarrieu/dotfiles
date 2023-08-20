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

        ["<c-a>"] = { "<home>", type = "command" },
        ["<c-e>"] = { "<end>", type = "command" },
      },
    }
  },
  pickers = {
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}

require('telescope').load_extension('fzf')
