---@diagnostic disable: undefined-global

return {
  -- debug
  s("log", fmta("console.log(<><>)", { sel(), i(0) })),
  s("err", fmta("console.error(<><>)", { sel(), i(0) })),
  s("info", fmta("console.info(<><>)", { sel(), i(0) })),
  s("warn", fmta("console.warn(<><>)", { sel(), i(0) })),

  -- definitions
  s("l", fmta("const <> = <>", { i(1, 'lhs'), i(0, 'rhs') })),

  -- scoping
  s("req", fmta("import <> from '<>'", { i(1), i(0) })),

  -- testing
  s("desc", fmta([[describe('<>', () =>> {
  <>
})]], { i(1, 'something'), i(2) })),
  s("it", fmta([[it('<>', async () =>> {
  <>
})]], { i(1, 'something'), i(2) })),
  s("test", fmta([[test('<>', async () =>> {
  <>
})]], { i(1, 'something'), i(2) })),
}, {
}
