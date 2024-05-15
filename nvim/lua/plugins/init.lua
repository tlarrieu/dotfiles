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
  { 'vifm/vifm.vim' },
  -- }}}
  -- {{{ --| Other |--------------------------
  { 'ap/vim-css-color' },
  -- }}}
}
