local g = vim.g

-- {{{ ==| bullets |============================================================
g.bullets_set_mappings = 0
-- }}}

-- {{{ ==| HighlightedYank |====================================================
g.highlightedyank_highlight_duration = 180
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

require('backdrop'):setup({ transparency = 60 })
