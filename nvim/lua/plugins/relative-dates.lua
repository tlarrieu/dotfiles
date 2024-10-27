return {
  'tlarrieu/nvim-relative-date',
  ft = { 'todotxt' },
  opts = {
    filetypes = {
      'todotxt',
    },
    format = ' ( %s)',
    highlight_groups = {
      early = '@date.early',
      late = '@date.late',
      today = '@date.today',
    },
  },
}
