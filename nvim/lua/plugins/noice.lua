return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline_popup",
      opts = {
        position = {
          row = "25%",
          col = "50%",
        }
      },
      format = {
        -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
        -- view: (default is cmdline view)
        -- opts: any options passed to the view
        -- icon_hl_group: optional hl_group for the icon
        -- title: set to anything or empty string to hide
        cmdline = { pattern = "^:", icon = " ", lang = "vim", title = '' },
        replace = { kind = 'search', pattern = "^:%%s/", icon = " ", lang = "regex", title = '' },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex", title = '' },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex", title = '' },
        shell = { pattern = "^:!", icon = " ", lang = "bash", title = '' },
        filter = { pattern = "^:%%s!", icon = " ", lang = "bash", title = '' },
        lua = { pattern = "^:lua ", icon = " ", lang = "lua", title = '' },
        vim = { pattern = "^:call ", icon = " ", lang = "vim", title = '' },
        input = { title = '' },
      },
    },
    -- we don't want that notify UI (too clunky for my taste)
    messages = {
      enabled = false
    },
  }
}
