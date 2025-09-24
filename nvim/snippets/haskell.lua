---@diagnostic disable: undefined-global

return {
  s("{", fmta("{-# LANGUAGE <> #-}", { i(1) })),

  rs("^main", fmta([[
    main :: IO ()
    main = <>
    ]], { i(1, "return()") })),

  rs("^mod", fmta([[
    module <> (
      <>
    ) where

    <><>
    ]], { dl(1, h.pascalize(fname), {}), sel(), i(0) })),
  s("d", fmta([[
    <> :: <>
    <> <> = <>
    ]], { i(1, "name"), i(2, "Type"), rep(1), i(3, "lhs"), i(0, "rhs") })),

  s("type", fmta("type <> = <>", { i(1, "name"), i(2, "expression") })),
  s("data", fmta("data <> = <>", { i(1, "name"), i(2, "expression") })),

  s("\\", fmta("\\<> ->> <>", { i(1, "x"), i(2, "expression") })),
  s("l", fmta([[
    let <> = <>
      in <><>
    ]], { i(1, "lhs"), i(2, "rhs"), sel(), i(3) })),

  -- common paterns
  s("match", fmta('[(_:matchResult)] = <> =~ "<>" :: [[String]]', { i(1, "string"), i(2, "pattern") })),
  s("open", fmta([[
    withFile "<>" <> $ \handle ->> do
      list <<- lines <<$>> hGetContents handle
    ]], { i(1, "filename"), i(2, "ReadMode") })),

  -- debug
  s("trace", fmta("traceShowId <>", { sel() })),

  -- tests
  s("desc", fmta([[
    describe "<>" $ do
      <>
    ]], { i(1), i(0) })),
  s("it", fmta('it "<>" $ <>', { i(1), i(0) })),
  s("should", fmta("`shouldBe` ", {})),
}, {
  s("é", fmta('|>>', {})),
  s("è", fmta('<<|', {})),
}
