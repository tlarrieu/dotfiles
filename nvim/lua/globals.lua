local home = os.getenv("HOME")

local g = vim.g

-- {{{ ==| vimwiki |============================================================
g.vimwiki_global_vars = {}
g.vimwiki_hl_headers = 0
g.vimwiki_key_mappings = { all_maps = 0 }
g.vimwiki_list = {{
    path = home .. '/.vimwiki/home',
    syntax = 'markdown',
    ext = '.md'
  },
  {
    path = home .. '/.vimwiki/home/d&d-campaign',
    syntax = 'markdown',
    ext = '.md'
  },
  {
    path = home .. '/.vimwiki/work',
    syntax = 'markdown',
    ext = '.md'
}}
-- }}}

-- {{{ ==| bullets |============================================================
g.bullets_set_mappings = 0
-- }}}

-- {{{ ==| vim-test |===========================================================
g['test#strategy'] = 'neoterm'
-- }}}

-- {{{ ==| HighlightedYank |====================================================
g.highlightedyank_highlight_duration = 180
-- }}}

-- {{{ ==| Neoterm |============================================================
g.neoterm_default_mod = 'botright'
g.neoterm_autoscroll = 1
g.neoterm_size = 12
-- }}}

-- {{{ ==| Deoplete |===========================================================
g['deoplete#enable_at_startup'] = 1
vim.fn['deoplete#custom#option']({ smart_case = true, min_pattern_length = 3 })
g['deoplete#tag#cache_limit_size'] = 600000
vim.fn['deoplete#custom#source']('_', 'matchers', { 'matcher_fuzzy' })
-- }}}

-- {{{ ==| GitGutter |==========================================================
g.gitgutter_map_keys = 0
-- }}}

-- {{{ ==| Neomake |============================================================
vim.fn['neomake#configure#automake']('w')

g.neomake_vint_maker = { exe = 'vint', args = {'%:p'} }

g.neomake_error_sign = { text = '✖', texthl = 'ErrorMsg' }
g.neomake_warning_sign = { text = '', texthl = 'WarningMsg' }
g.neomake_message_sign = { text = '', texthl = 'NeomakeMessageSign' }
g.neomake_info_sign = { text = '', texthl = 'NeomakeInfoSign' }
-- }}}

-- {{{ ==| Surround |===========================================================
g.surround_no_insert_mappings = 1
g.surround_35 = "<%# \r %>"
g.surround_37 = "<% \r %>"
g.surround_61 = "<%= \r %>"
-- }}}

-- {{{ ==| Angry |==============================================================
g.angry_disable_maps = 1
-- }}}

-- {{{ ==| UltiSnips |==========================================================
g.UltiSnipsRemoveSelectModeMappings = 1
g.UltiSnipsEditSplit = 'vertical'
g.UltiSnipsJumpForwardTrigger = '<tab>'
g.UltiSnipsJumpBackwardTrigger = '<s-tab>'
g.UltiSnipsSnippetsDir = home .. '/.config/nvim/UltiSnips'
-- }}}

-- {{{ ==| Taboo |==============================================================
g.taboo_tab_format = ' %N %f%m '
g.taboo_renamed_tab_format = ' %N (%l)%m '
g.taboo_modified_tab_flag = ' ∙'
g.taboo_unnamed_tab_label = '…'
-- }}}
