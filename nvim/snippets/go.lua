---@diagnostic disable: undefined-global

return {
  -- main
  rs("^main", fmta([[
    package <>

    func main() {
    	<>
    }]],
    { i(1, "main"), i(0) }
  )),

  -- bindings
  s("c", fmta("const <> = <>", { i(1, "lhs"), i(0, "rhs") })),
  s("l", fmta("<> := <>", { i(1, "lhs"), i(0, "rhs") })),

  -- function definition
  rs("^d", fmta([[
      func <>(<>) <> {
      	<>
      }]],
    { i(1, "name"), i(2, "arg"), i(3, "type"), i(0) }
  )),
  s("d", fmta([[ func (<>) <> {<>}]], { i(1, "arg"), i(2, "type"), i(0) })),
  rs("^m", fmta([[
      func (<>) <>(<>) <> {
      	<>
      }]],
    { i(1, "receiver"), i(2, "name"), i(3), i(4, "type"), i(0) }
  )),
  rs("^iter", fmta([[
  func <>(<>) func(yield func(<>) bool) {
    <>
    return func(yield func(<>) bool) {
      if !yield(<>) {
        return
      }
    }
  }
  ]], { i(1, "name"), i(2, "arg"), i(3, "arg"), i(4), rep(3), i(0) })),

  -- types
  rs("^i", fmta("type <> interface {<>}", { i(1, "name"), i(0) })),
  rs("^s", fmta("type <> struct {<>}", { i(1, "name"), i(0) })),
  rs("^t", fmta("type <> <>", { i(1, "name"), i(2, "type") })),

  s("i", fmta([[<> interface {<>}]], { i(1, "name"), i(0) })),
  s("s", fmta([[<> struct {<>}]], { i(1, "name"), i(0) })),
  s("t", fmta("<> <>", { i(1, "name"), i(2, "type") })),

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
  s("if", fmta([[
  if <> {
    <>
  }
  ]], { i(1, 'cond'), i(2) })),
  s("else", fmta([[
  else {
    <>
  }
  ]], { i(1) })),
  s("ei", fmta([[
  else if <> {
    <>
  }
  ]], { i(1, 'cond'), i(2) })),

  -- common patterns
  s("exit", fmta("os.Exit(<>)", { i(0, "0") })),
  s("p", fmta("fmt.Println(<><>)", { sel(), i(1) })),
  s("pf", fmta([[fmt.Printf("<><>", <>)]], { sel(), i(1), i(2) })),
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
    }]], { cap(1), i(1, "err"), rep(1) }
  )),
}, {
  -- Skeleton
  s("__skel", fmta([[
    package <>

    <>
    ]],
    { f(h.dirname), i(0) }
  )),
}
