---@diagnostic disable: undefined-global

return {
  -- definition
  s("d", fmta([[
  define <>
  	<>
  endef
  ]], { i(1, 'name'), i(0) })),
  s("r", fmta([[
  .PHONY: <>
  <>:
  	<>
  ]], { i(1, 'name'), rep(1), i(0) })),

  -- check root privileges
  s("root", fmta([[
  ifeq ($(shell id -u), 0)
  <><>
  endif
  ]], { sel(), i(0) })),

  -- phony
  s(".ph", fmta(".PHONY: <>", { i(0) })),

  -- colors
  s("cecho", fmta([[
  define cecho
  	@tput setaf $(1)
  	@echo $(2)
  	@tput sgr0
  endef
  ]], {})),
  s("red", fmta('$(call cecho, 1, <><>)', { sel(), i(0) })),
  s("gr", fmta('$(call cecho, 2, <><>)', { sel(), i(0) })),
  s("yel", fmta('$(call cecho, 3, <><>)', { sel(), i(0) })),
  s("blue", fmta('$(call cecho, 4, <><>)', { sel(), i(0) })),
  s("pink", fmta('$(call cecho, 5, <><>)', { sel(), i(0) })),
  s("cyan", fmta('$(call cecho, 6, <><>)', { sel(), i(0) })),
}, {
  -- skeleton
  s("__skel", fmta([[
    CC=<>
    CFLAGS=<>

    .PHONY: all
    all: install

    .PHONY: install
    install:<>

    .PHONY: clean
    clean:<>
    ]], { i(1), i(2), i(3), i(4) })),

}
