return {
  'NeogitOrg/neogit',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    {
      'esmuellert/codediff.nvim',
      opts = {
        diff = {
          layout = 'side-by-side',
          compute_moves = true,
        },
        explorer = {
          width = 45,
          icons = { folder_closed = '', folder_open = '' },
          file_filter = { ignore = { '*.pdf' } },
        },
        keymaps = {
          view = { next_hunk = 'þ', prev_hunk = 'ß', next_file = '<c-n>', prev_file = '<c-p>' },
        },
      },
    }
  },
  opts = {
    disable_hint = true,
    signs = {
      section = { '󰅂', '󰅀' },
      item = { '󰄾', '󰄼' },
      hunk = { '󰶻', '󰶹' },
    },
    integrations = { telescope = false }, -- weird, but this disables neogit custom telescope config, and uses mine instead
    prompt_amend_commit = false,
    graph_style = 'kitty',
    use_per_project_settings = false,
    remember_settings = true,
    kind = 'split',
    status = {
      show_head_commit_hash = true,
      recent_commit_count = 10,
      HEAD_padding = 7,
      HEAD_folded = false,
      mode_padding = 1,
      mode_text = {
        M = '',
        N = '',
        A = '',
        D = '',
        C = '',
        U = '',
        R = '',
        T = '',
        DD = '',
        AU = '',
        UD = '',
        UA = '',
        DU = '',
        AA = '',
        UU = '',
        ['?'] = '󱪘',
      },
    },
    commit_editor = {
      kind = 'split',
      show_staged_diff = false,
      staged_diff_split_kind = 'split',
      spell_check = true,
    },
    log_view = { kind = 'vsplit' },
    commit_view = { kind = 'vsplit' },
    commit_select_view = { kind = 'vsplit' },
    reflog_view = { kind = 'vsplit' },
  },
  config = function(_, opts)
    local neogit = require('neogit')
    neogit.setup(opts)
    vim.keymap.set('n', '<c-y>', '<cmd>Neogit<cr>', { desc = 'neogit' })
    vim.keymap.set('v', '<leader>l', ':NeogitLog<cr>', { desc = 'neogit history (visual)' })
    vim.keymap.set('n', '<leader>L', ':NeogitLog<cr>', { desc = 'neogit history (file)' })
    vim.keymap.set('n', '<leader>l', neogit.action('log', 'log_current', { '--graph', '--decorate', '--max-count=100' }),
      { desc = 'neogit log' })
    vim.keymap.set('n', '<leader>cc', neogit.action('commit', 'commit', {}), { desc = 'neogit commit' })
    vim.keymap.set('n', '<leader>ce', neogit.action('commit', 'extend', {}), { desc = 'neogit commit extend' })
    vim.keymap.set('n', '<leader>ca', neogit.action('commit', 'amend', {}), { desc = 'neogit commit amend' })
    vim.keymap.set('n', '<c-s-b>', neogit.action('branch', 'checkout_local_branch', {}),
      { desc = 'neogit branch checkout' })
    vim.keymap.set('n', '<leader>gu', neogit.action('pull', 'from_upstream', { '--rebase' }), { desc = 'neogit pull' })
    vim.keymap.set('n', '<leader>gp', neogit.action('push', 'to_upstream', { '--force-with-lease', '-u' }),
      { desc = 'neogit push' })
    vim.keymap.set('n', '<leader>gs', ':silent !git stash --quiet &<cr>', { desc = 'Git stash' })
    vim.keymap.set('n', '<leader>gS', ':silent !git stash pop --quiet &<cr>', { desc = 'Git stash pop' })
  end
}
