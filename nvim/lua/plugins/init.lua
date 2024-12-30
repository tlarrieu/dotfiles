return {
  -- {{{ --| File Manipulation |--------------
  { 'tpope/vim-eunuch',       cmd = { 'Remove', 'Delete', 'Move', 'Rename', 'Mkdir', 'SudoWrite' } },
  -- }}}
  -- {{{ --| Project manipulation |-----------
  { 'tpope/vim-projectionist' },
  -- }}}
  -- {{{ --| Functionalities |---------------
  { 'AndrewRadev/linediff.vim',     cmd = 'Linediff' },
  {
    'janko-m/vim-test',
    cmd = { 'TestNearest', 'TestFile', 'TestLast' },
    dependencies = { 'akinsho/toggleterm.nvim' }
  },
  { 'tlarrieu/vim-sniper' },
  -- }}}
  -- {{{ --| Text manipulation |--------------
  { 'AndrewRadev/switch.vim', },
  { 'tpope/vim-repeat', },
  { 'FooSoft/vim-argwrap',          cmd = { 'ArgWrap' } },
  -- }}}
  -- {{{ --| Text objects |-------------------
  { 'austintaylor/vim-indentobject' },
  { 'tommcdo/vim-exchange' },
  -- }}}
  -- {{{ --| Languages support |---------------
  { 'vifm/vifm.vim',                ft = 'vifm' },
  -- }}}
  -- {{{ --| Other |--------------------------
  { 'ap/vim-css-color' },
  -- }}}
}
