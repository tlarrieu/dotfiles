return {
  settings = {
    Lua = {
      format = {
        defaultConfig = {
          indent_style = 'space',
          indent_size = '2',
          align_array_table = 'false',
        },
      },
      diagnostics = {
        neededFileStatus = { ['codestyle-check'] = 'Any' },
      },
    }
  }
}
