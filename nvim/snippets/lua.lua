---@diagnostic disable: undefined-global

return {
  -- definitions
  rs("^%s*d", fmta([[
    local <> = function(<>)
      <>
    end]],
    { i(1), i(2), i(0) }
  )),
  s("d", fmta([[
    function(<>)
      <>
    end]],
    { i(1), i(0) }
  )),
  s("l", fmta("local <> = <>", { i(1), i(0) })),

  -- control structures
  s("for", fmta([[
    for <> in <> do
      <>
    end]],
    { i(1, "x"), i(2, "xs"), i(0) }
  )),

  -- common patterns
  s("req", fmta("require('<>')", { i(0) })),
  s("dump", fmta("require('gears.debug').dump_return(<>)", { i(0) })),
  s("notif", fmta("require('naughty').notify({ text = <> })", { i(0) })),

  -- snippets
  rs("(r?s)", fmta([[<>("<>", fmta(<>, {<>})),]], { cap(1), i(1, "expr"), i(2), i(3) })),
}, {
}
