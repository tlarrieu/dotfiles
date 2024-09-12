---@diagnostic disable: undefined-global

return {
  s("todo", fmta('TODO: ', {})),
  s("fix", fmta('FIXME: ', {})),
  s("warn", fmta('WARN: ', {})),
  s("perf", fmta('PERF: ', {})),
  s("note", fmta('NOTE: ', {})),
  s("test", fmta('TEST: ', {})),
  s("hack", fmta('HACK: ', {})),
  s("skel", fmta('s("__<>", fmta([[<>]], {<>})),', { i(1, 'skel'), i(2), i(3) })),

  s("r", fmta("return <><>", { sel(), i(0) })),
}, {
}
