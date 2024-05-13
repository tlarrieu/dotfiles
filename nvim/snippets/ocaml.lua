---@diagnostic disable: undefined-global

return {
  s("l", fmta('let <> = <>', { i(1, '()'), i(2) })),
  s("p", fmta('print_endline ', {})),
}, {
  s("é", fmta('|>>', {})),
  s("è", fmta('<<|', {})),
}
