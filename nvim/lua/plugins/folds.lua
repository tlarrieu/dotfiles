return {
  'anuvyklack/pretty-fold.nvim',
  -- NOTE: local commit until ffi error fix gets merged into main repo
  -- see https://github.com/anuvyklack/pretty-fold.nvim/issues/38
  commit = '587fbce',
  opts = {
    sections = {
      left = {
        'content',
      },
      right = {
        ' ',
        'number_of_folded_lines',
        ' ',
        '󰁂',
        ' ',
        function(config) return config.fill_char:rep(3) end
      }
    },
    fill_char = '-',
    ft_ignore = {},
  },
  config = function(_, opts)
    local o = vim.opt

    o.foldcolumn = '0'
    o.foldclose = ''
    o.foldmethod = 'indent'
    o.foldnestmax = 3
    o.foldlevelstart = 10
    o.foldminlines = 2

    require('pretty-fold').setup(opts)
  end
}
