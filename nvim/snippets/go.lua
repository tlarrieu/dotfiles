---@diagnostic disable: undefined-global

return {
  -- Skeleton
  s("_skel", fmta([[
    package <>

    func main() {
      <>
    }]],
    { i(1, "main"), i(0) }
  )),

  -- main
  rs("^%s*main", fmta([[
      func main() {
        <>
      }]],
    { i(0) }
  )),

  -- bindings
  s("l", fmta("<> := <>", { i(1, "lhs"), i(0, "rhs") })),

  -- function definition
  rs("^d", fmta([[
      func <>(<>) <> {
        <>
      }]],
    { i(1, "name"), i(2, "arg"), i(3, "type"), i(0) }
  )),
  s("d", fmta([[ func (<>) <> {<>}]], { i(1, "arg"), i(2, "type"), i(0) })),

  -- types
  rs("^i", fmta([[type <> interface {<>}]], { i(1, "name"), i(0) })),
  rs("^s", fmta([[type <> struct {<>}]], { i(1, "name"), i(0) })),
  rs("^t", fmta("type <> <>", { i(1, "name"), i(2, "type") })),

  -- control structures
  s("for", fmta([[
    for <> := <>; <> << <>; <>++ {
      <>
    }
  ]], { i(1, "i"), i(2, "0"), rep(1), i(3, "N"), rep(1), i(0) })),
  s("range", fmta([[
    for <>, <> := range <> {
      <>
    }
  ]], { i(1, "i"), i(2, "x"), i(3, "xs"), i(0) })),
  s("sw", fmta([[
    switch <> {
      case <>:
        <>
    }
  ]], { i(1, "var"), i(2, "val"), i(0) })),

  -- common patterns
  s("exit", fmta("os.Exit(<>)", { i(0, "0") })),
  s("print", fmta("fmt.Println(<><>)", { sel(), i(0) })),
  s("open", fmta([[
    <>, <> := os.Open("<>")
    if <> != nil {
      panic(<>)
    }
    defer <>.Close()
  ]], { i(1, "file"), i(2, "err"), i(3, "path"), rep(2), rep(2), rep(1) })),
  s("scan", fmta([[
    <> := bufio.NewScanner(<>)
    for <>.Scan() {
      line := <>.Text()
      <>
    }
    if <>.Err() != nil {
      panic(<>.Err())
    }
  ]], { i(1, "scanner"), i(2, "file"), rep(1), rep(1), i(0), rep(1), rep(1) })),
  rs("^(%s*)err", fmta([[
      <>if <> != nil {
        panic(<>)
      }]],
    { cap(1), i(1, "err"), rep(1) }
  )),
}, {
}