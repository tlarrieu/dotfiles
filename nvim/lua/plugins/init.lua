return {
  -- {{{ --| File Manipulation |--------------
  {
    'tpope/vim-eunuch',
    cmd = {
      'Delete',
      'Mkdir',
      'Move',
      'Remove',
      'Rename',
      'SudoWrite',
    }
  },
  -- }}}
  -- {{{ --| Project manipulation |-----------
  { 'tpope/vim-projectionist' },
  -- }}}
  -- {{{ --| Functionalities |---------------
  {
    'AndrewRadev/linediff.vim',
    cmd = 'Linediff'
  },
  { 'tlarrieu/vim-sniper' },
  -- }}}
  -- {{{ --| Text manipulation |--------------
  { 'AndrewRadev/switch.vim', },
  { 'tpope/vim-repeat', },
  {
    'FooSoft/vim-argwrap',
    cmd = { 'ArgWrap' }
  },
  -- }}}
  -- {{{ --| Text objects |-------------------
  { 'austintaylor/vim-indentobject' },
  { 'tommcdo/vim-exchange' },
  -- }}}
  -- {{{ --| Languages support |---------------
  {
    'vifm/vifm.vim',
    ft = 'vifm'
  },
  -- }}}
  -- {{{ --| Other |--------------------------
  { 'ap/vim-css-color' },
  -- }}}
}
