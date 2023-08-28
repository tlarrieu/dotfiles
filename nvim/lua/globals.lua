local home = os.getenv("HOME")

local g = vim.g

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
g.neoterm_automap_keys = ''
-- }}}

-- {{{ ==| GitGutter |==========================================================
g.gitgutter_map_keys = 0
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
g.UltiSnipsSnippetDirectories = { home .. '/.config/nvim/UltiSnips' }
-- }}}

-- {{{ ==| Taboo |==============================================================
g.taboo_tab_format = ' %N %f%m '
g.taboo_renamed_tab_format = ' %N (%l)%m '
g.taboo_modified_tab_flag = ' ∙'
g.taboo_unnamed_tab_label = '…'
-- }}}
