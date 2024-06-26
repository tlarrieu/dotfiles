local g = vim.g

-- {{{ ==| bullets |============================================================
g.bullets_set_mappings = 0
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

require('backdrop'):setup({ transparency = 60 })
