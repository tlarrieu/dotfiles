---@diagnostic disable: undefined-global

return {
  -- skeleton
  s("_skel", fmta([[
    CC=<>
    CFLAGS=<>

    all:<>

    clean:<>
    ]], { i(1), i(2), i(3), i(4) })),

  -- phony
  s(".ph", fmta(".PHONY: <>", { i(0) })),

  -- colors
  s("red", fmta('$(call cecho, 1, <><>)', { sel(), i(0) })),
  s("gr", fmta('$(call cecho, 2, <><>)', { sel(), i(0) })),
  s("yel", fmta('$(call cecho, 3, <><>)', { sel(), i(0) })),
  s("blue", fmta('$(call cecho, 4, <><>)', { sel(), i(0) })),
  s("pink", fmta('$(call cecho, 5, <><>)', { sel(), i(0) })),
  s("cyan", fmta('$(call cecho, 6, <><>)', { sel(), i(0) })),
}, {
}