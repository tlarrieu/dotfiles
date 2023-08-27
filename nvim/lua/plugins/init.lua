return {
  -- {{{ --| LSP |----------------------------
  { 'williamboman/mason.nvim', config = true },
  { 'hrsh7th/cmp-nvim-lsp', dependencies = { 'hrsh7th/nvim-cmp' } },
  { 'quangnguyen30192/cmp-nvim-ultisnips' },
  { 'folke/neodev.nvim', opts = {} },
  -- }}}
  -- {{{ --| ui |-----------------------------
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
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
  { 'kassio/neoterm' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'janko-m/vim-test' },
  { 'tlarrieu/vim-sniper' },
  { 'sbdchd/neoformat' },
  { 'milkypostman/vim-togglelist' },
  { 'vimwiki/vimwiki' },
  -- }}}
  -- {{{ --| Snippets |-----------------------
  { 'SirVer/ultisnips' },
  -- }}}
  -- {{{ --| Text manipulation |--------------
  { 'AndrewRadev/switch.vim' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-surround' },
  { 'FooSoft/vim-argwrap' },
  { 'dkarter/bullets.vim' },
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
  { 'vim-scripts/gnuplot-syntax-highlighting' },
  { 'othree/html5.vim' },
  { 'pangloss/vim-javascript' },
  { 'leafgarland/typescript-vim' },
  { 'mxw/vim-jsx' },
  { 'LaTeX-Box-Team/LaTeX-Box' },
  { 'wgwoods/vim-systemd-syntax' },
  { 'lmeijvogel/vim-yaml-helper' },
  { 'krisajenkins/vim-postgresql-syntax' },
  { 'tbastos/vim-lua' },
  { 'elixir-editors/vim-elixir' },
  { 'qbit/taskwarrior-vim' },
  -- }}}
  -- {{{ --| Good looking |-------------------
  { 'gcmt/taboo.vim' },
  -- }}}
  -- {{{ --| Other |--------------------------
  { 'ap/vim-css-color' },
  -- }}}
}
