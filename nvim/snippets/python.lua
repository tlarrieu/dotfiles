---@diagnostic disable: undefined-global

return {
	s("#!", fmta("#!/usr/bin/env ruby", {})),
	-- imports
	s("req", fmta("import <>", { i(1) })),
	s("from", fmta("from <> import <>", { i(1, 'modname'), i(2, 'funcname') })),

	-- definitions
	s("c", fmta([[
		class <>:
			<><>
		]], { i(1, 'Name'), sel(), i(0) })),
	s("d", fmta([[
		def <>(<>):
			<><>
    ]], { i(1, "name"), i(2), sel(), i(0) })),
	s("di", fmta([[
		def __init__(self<>):
			<><>
		]], { i(1), sel(), i(0) })),
	s("ret", fmta("return ", {})),

	-- misc
	s("p", fmta('print(<>)', { i(1) })),
}, {
}
-- vim: ts=2 sts=2 sw=2 noet
