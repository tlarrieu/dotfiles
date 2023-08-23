require("noice").setup({
  cmdline = {
    enabled = true,
    view = "cmdline_popup",
    opts = {
      position = {
        row = "25%",
        col = "50%",
      }
    },
    ---@type table<string, CmdlineFormat>
    format = {
      -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
      -- view: (default is cmdline view)
      -- opts: any options passed to the view
      -- icon_hl_group: optional hl_group for the icon
      -- title: set to anything or empty string to hide
      cmdline = { pattern = "^:", icon = " ", lang = "vim", title = '' },
      replace = { kind = 'search', pattern = "^:%%s/", icon = " ", lang = "regex", title = '' },
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex", title = '' },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex", title = '' },
      shell = { pattern = "^:!", icon = " ", lang = "bash", title = '' },
      lua = { pattern = { "^:lua " }, icon = " ", lang = "lua", title = '' },
    },
  },
  -- we don't want that notify UI (too clunky for my taste)
  messages = {
    enabled = false
  },
})
