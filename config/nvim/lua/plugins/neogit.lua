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
          layout = 'inline',
          compute_moves = true,
        },
        explorer = {
          width = 45,
          icons = { folder_closed = '', folder_open = '' },
          view_mode = 'tree',
          flatten_dirs = true,
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
    diff_viewer = 'codediff',
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
    use_default_keymaps = false,
    mappings = {
      status = {
        ['j']      = 'MoveDown',
        ['k']      = 'MoveUp',
        ['<c-s>']  = 'Close',
        ['I']      = 'InitRepo',
        ['Q']      = 'Command',
        ['x']      = 'Discard',
        ['s']      = 'Stage',
        ['S']      = 'StageAll',
        ['u']      = 'Unstage',
        ['U']      = 'UnstageStaged',
        ['K']      = 'Untrack',
        ['Y']      = 'ShowRefs',
        ['g?']     = 'CommandHistory',
        ['yy']     = 'YankSelected',
        ['gp']     = 'GoToParentRepo',
        ['"']      = 'Depth1',
        ['«']      = 'Depth2',
        ['»']      = 'Depth3',
        ['(']      = 'Depth4',
        ['o']      = 'Toggle',
        ['<c-r>']  = 'RefreshBuffer',
        ['<cr>']   = 'GoToFile',
        ['<s-cr>'] = 'PeekFile',
        ['<c-v>']  = 'VSplitOpen',
        ['<c-x>']  = 'SplitOpen',
        ['<c-t>']  = 'TabOpen',
        ['ß']      = 'GoToPreviousHunkHeader',
        ['þ']      = 'GoToNextHunkHeader',
        ['[c']     = 'OpenOrScrollUp',
        [']c']     = 'OpenOrScrollDown',
        ['<c-k>']  = 'PeekUp',
        ['<c-j>']  = 'PeekDown',
      },
      popup = {
        ['?'] = 'HelpPopup',
        ['A'] = 'CherryPickPopup',
        ['d'] = 'DiffPopup',
        ['M'] = 'RemotePopup',
        ['X'] = 'ResetPopup',
        ['t'] = 'StashPopup',
        -- ['i'] = 'IgnorePopup',
        ['T'] = 'TagPopup',
        ['b'] = 'BranchPopup',
        ['B'] = 'BisectPopup',
        ['w'] = 'WorktreePopup',
        ['c'] = 'CommitPopup',
        ['f'] = 'FetchPopup',
        ['l'] = 'LogPopup',
        ['m'] = 'MergePopup',
        ['p'] = 'PushPopup',
        ['P'] = 'PullPopup',
        ['r'] = 'RebasePopup',
        ['R'] = 'RevertPopup',
      },
      commit_editor = {
        ['<c-p>'] = 'PrevMessage',
        ['<c-n>'] = 'NextMessage',
        ['<m-r>'] = 'ResetMessage',
        ['<c-c>'] = 'Abort',
      },
      commit_editor_I = {
        ['<c-c>'] = 'Abort',
      },
      commit_view = {
        ['i'] = 'OpenFileInWorktree',
        ['o'] = 'OpenCommitLinkInBrowser',
      },
      rebase_editor = {
        ['p']     = 'Pick',
        ['r']     = 'Reword',
        ['e']     = 'Edit',
        ['s']     = 'Squash',
        ['f']     = 'Fixup',
        ['x']     = 'Execute',
        ['d']     = 'Drop',
        ['b']     = 'Break',
        ['q']     = 'Close',
        ['<cr>']  = 'OpenCommit',
        ['gk']    = 'MoveUp',
        ['gj']    = 'MoveDown',
        ['<c-c>'] = 'Abort',
        ['[c']    = 'OpenOrScrollUp',
        [']c']    = 'OpenOrScrollDown',
      },
      rebase_editor_I = {
        ['<c-c>'] = 'Abort',
      },
      finder = {
        ['<cr>']               = 'Select',
        ['<c-c>']              = 'Close',
        ['<esc>']              = 'Close',
        ['<c-n>']              = 'Next',
        ['<c-p>']              = 'Previous',
        ['<down>']             = 'Next',
        ['<up>']               = 'Previous',
        ['<tab>']              = 'InsertCompletion',
        ['<c-y>']              = 'CopySelection',
        ['<space>']            = 'MultiselectToggleNext',
        ['<s-space>']          = 'MultiselectTogglePrevious',
        ['<c-j>']              = 'NOP',
        ['<ScrollWheelDown>']  = 'ScrollWheelDown',
        ['<ScrollWheelUp>']    = 'ScrollWheelUp',
        ['<ScrollWheelLeft>']  = 'NOP',
        ['<ScrollWheelRight>'] = 'NOP',
        ['<LeftMouse>']        = 'MouseClick',
        ['<2-LeftMouse>']      = 'NOP',
      },
    },
  },
  config = function(_, opts)
    local neogit = require('neogit')
    neogit.setup(opts)
    vim.keymap.set('n', '<c-s>', '<cmd>Neogit<cr>', { desc = 'neogit' })

    vim.keymap.set('v', '<leader>l', ':NeogitLog<cr>', { desc = 'neogit history (visual)' })
    vim.keymap.set('n', '<leader>L', ':NeogitLog<cr>', { desc = 'neogit history (file)' })
    vim.keymap.set('n', '<leader>l', neogit.action('log', 'log_current', { '--graph', '--decorate', '--max-count=100' }),
      { desc = 'neogit log' })

    vim.keymap.set('n', '<leader>dm', '<cmd>CodeDiff origin/master...<cr>',
      { desc = 'code(diff) review (origin/master...)' })
    vim.keymap.set('n', '<leader>dd', '<cmd>CodeDiff HEAD<cr>', { desc = 'code(diff) review (HEAD~)' })

    vim.keymap.set('n', '<leader>cc', neogit.action('commit', 'commit', {}), { desc = 'neogit commit' })
    vim.keymap.set('n', '<leader>ce', neogit.action('commit', 'extend', {}), { desc = 'neogit commit extend' })
    vim.keymap.set('n', '<leader>ca', neogit.action('commit', 'amend', {}), { desc = 'neogit commit amend' })

    vim.keymap.set('n', '<leader>bo', neogit.action('branch', 'open_pull_request', {}), { desc = 'neogit pull request' })
    vim.keymap.set('n', '<c-y>', neogit.action('branch', 'checkout_local_branch', {}),
      { desc = 'neogit branch checkout' })
    vim.keymap.set('n', '<c-s-y>', neogit.action('branch', 'checkout_recent_branch', {}),
      { desc = 'neogit branch checkout (recent)' })

    vim.keymap.set('n', '<leader>gu', neogit.action('pull', 'from_upstream', { '--rebase' }), { desc = 'neogit pull' })
    vim.keymap.set('n', '<leader>gp', neogit.action('push', 'to_upstream', { '--force-with-lease', '-u' }),
      { desc = 'neogit push' })

    vim.keymap.set('n', '<leader>gs', ':silent !git stash --quiet<cr><cmd>bufdo checktime<cr>',
      { desc = 'Git stash' })
    vim.keymap.set('n', '<leader>gS', ':silent !git stash pop --quiet<cr><cmd>bufdo checktime<cr>',
      { desc = 'Git stash pop' })
  end
}
