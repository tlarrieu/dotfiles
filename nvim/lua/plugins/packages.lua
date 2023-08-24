vim.cmd([[ packadd packer.nvim ]])

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = 'packages.lua',
  command = 'source <afile> | PackerCompile',
  group = vim.api.nvim_create_augroup("packer_setup", {}),
})

return require('packer').startup(function(use)
  -- {{{ --| packer |-------------------------
  use { 'wbthomason/packer.nvim' }
  -- }}}
  -- {{{ --| LSP |----------------------------
  use { 'williamboman/mason.nvim' }
  use { 'williamboman/mason-lspconfig.nvim' }
  use { 'WhoIsSethDaniel/mason-tool-installer.nvim' }
  use { 'neovim/nvim-lspconfig' }
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'quangnguyen30192/cmp-nvim-ultisnips' }
  -- }}}
  -- {{{ --| ui |-----------------------------
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/plenary.nvim'}
    }
  }
  use { "folke/noice.nvim",
    requires = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  }
  -- }}}
  -- {{{ --| File Manipulation |--------------
  use { 'folke/todo-comments.nvim',
    requires = {
      {'nvim-lua/plenary.nvim'}
    }
  }
  use { 'duggiefresh/vim-easydir' }
  use { 'tpope/vim-eunuch' }
  -- }}}
  -- {{{ --| Project manipulation |-----------
  use { 'tpope/vim-projectionist' }
  use { 'airblade/vim-gitgutter' }
  use { 'tpope/vim-fugitive' }
  use { 'junegunn/gv.vim' }
  -- }}}
  -- {{{ --| Functionnalities |---------------
  use { 'AndrewRadev/linediff.vim', on = 'Linediff' }
  use { 'kassio/neoterm' }
  use { 'nvim-tree/nvim-web-devicons' }
  use { 'stevearc/oil.nvim' }
  use { 'janko-m/vim-test' }
  use { 'tlarrieu/vim-sniper' }
  use { 'sbdchd/neoformat' }
  use { 'milkypostman/vim-togglelist' }
  use { 'vimwiki/vimwiki' }
  -- }}}
  -- {{{ --| Snippets |-----------------------
  use { 'SirVer/ultisnips' }
  -- }}}
  -- {{{ --| Text manipulation |--------------
  use { 'AndrewRadev/switch.vim' }
  use { 'tpope/vim-commentary' }
  use { 'tpope/vim-repeat' }
  use { 'tpope/vim-surround' }
  use { 'FooSoft/vim-argwrap' }
  use { 'dkarter/bullets.vim' }
  -- }}}
  -- {{{ --| Text objects |-------------------
  use { 'kana/vim-textobj-function' }
  use { 'kana/vim-textobj-user' }
  use { 'austintaylor/vim-indentobject' }
  use { 'tommcdo/vim-exchange' }
  use { 'b4winckler/vim-angry' }
  use { 'RRethy/vim-illuminate' }
  -- }}}
  -- {{{ --| Languages suport |---------------
  use { 'neovimhaskell/haskell-vim' }
  use { 'vifm/vifm.vim' }
  use { 'dag/vim-fish' }
  use { 'vim-scripts/gnuplot-syntax-highlighting' }
  use { 'othree/html5.vim' }
  use { 'pangloss/vim-javascript' }
  use { 'leafgarland/typescript-vim' }
  use { 'mxw/vim-jsx' }
  use { 'LaTeX-Box-Team/LaTeX-Box' }
  use { 'wgwoods/vim-systemd-syntax' }
  use { 'lmeijvogel/vim-yaml-helper' }
  use { 'krisajenkins/vim-postgresql-syntax' }
  use { 'tbastos/vim-lua' }
  use { 'elixir-editors/vim-elixir' }
  use { 'qbit/taskwarrior-vim' }
  -- }}}
  -- {{{ --| Good looking |-------------------
  use { 'maxmx03/solarized.nvim', }
  use { 'gcmt/taboo.vim' }
  use { 'chentoast/marks.nvim' }
  -- }}}
  -- {{{ --| Other |--------------------------
  use { 'ap/vim-css-color' }
  -- }}}
end)
