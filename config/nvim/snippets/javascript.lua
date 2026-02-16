---@diagnostic disable: undefined-global

return {
  -- debug
  s("log", fmta("console.log(<><>)", { sel(), i(0) })),
  s("info", fmta("console.info(<><>)", { sel(), i(0) })),
  s("warn", fmta("console.warn(<><>)", { sel(), i(0) })),

  -- scoping
  s("req", fmta("import <> from '<>'", { i(1), i(0) })),

  -- definitions
  s("c", fmta([[
    class <> {
      <><>
    }
    ]], { i(1, "name"), sel(), i(0) })),
  s("d", fmta([[
    function <>(<>) {
      <><>
    }
    ]], { i(1, "name"), i(2, "args"), sel(), i(0) })),
  s("di", fmta([[
    constructor(<>) {
      <><>
    }
    ]], { i(1, "args"), sel(), i(0) })),
  s("=", fmta([[
    <> = (<>) =>> {
      <><>
    }
    ]], { i(1, "name"), i(2, "args"), sel(), i(0) })),

  -- testing
  s("test", fmta("test('<>', (<>) =>> {<>})", { i(1, 'something'), i(2, 'args'), i(3) })),
}, {
}
