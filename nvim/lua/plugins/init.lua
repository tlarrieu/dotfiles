return {
  -- {{{ --| LSP |----------------------------
  { 'williamboman/mason.nvim', config = true },
  { 'hrsh7th/cmp-nvim-lsp', dependencies = { 'hrsh7th/nvim-cmp' } },
  { 'folke/neodev.nvim', opts = {} },
  -- }}}
  -- {{{ --| File Manipulation |--------------
  { 'duggiefresh/vim-easydir' },
  { 'tpope/vim-eunuch' },
  -- }}}
  -- {{{ --| Project manipulation |-----------
  { 'tpope/vim-projectionist' },
  { 'airblade/vim-gitgutter' },
  { 'tpope/vim-fugitive' },
  { 'junegunn/gv.vim' },
  -- }}}
  -- {{{ --| Functionnalities |---------------
  { 'AndrewRadev/linediff.vim', cmd = 'Linediff' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'janko-m/vim-test' },
  { 'tlarrieu/vim-sniper' },
  { 'sbdchd/neoformat' },
  { 'milkypostman/vim-togglelist' },
  -- }}}
  -- {{{ --| Text manipulation |--------------
  { 'AndrewRadev/switch.vim' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },
  { 'FooSoft/vim-argwrap' },
  -- }}}
  -- {{{ --| Text objects |-------------------
  { 'austintaylor/vim-indentobject' },
  { 'tommcdo/vim-exchange' },
  { 'b4winckler/vim-angry' },
  -- }}}
  -- {{{ --| Languages suport |---------------
  { 'neovimhaskell/haskell-vim' },
  { 'vifm/vifm.vim' },
  { 'dag/vim-fish' },
  { 'othree/html5.vim' },
  { 'pangloss/vim-javascript' },
  { 'leafgarland/typescript-vim' },
  { 'mxw/vim-jsx' },
  { 'LaTeX-Box-Team/LaTeX-Box' },
  { 'wgwoods/vim-systemd-syntax' },
  { 'krisajenkins/vim-postgresql-syntax' },
  { 'elixir-editors/vim-elixir' },
  { 'qbit/taskwarrior-vim' },
  -- }}}
  -- {{{ --| Other |--------------------------
  { 'ap/vim-css-color' },
  -- }}}
}
