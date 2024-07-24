---@diagnostic disable: undefined-global

return {
  s("e", fmta([[
  <> ! <> | <>
    <>  <> €
    <>
  ]], {
    f(function() return os.date('%m/%d') end),
    i(1, 'payee'),
    i(2, 'desc'),
    i(3, 'to'),
    i(4, 'amount'),
    i(5, 'card:main')
  })),
  s("i", fmta([[
  <> ! me
    card:main  <> €
    <>
  ]], {
    f(function() return os.date('%m/%d') end),
    i(1, 'amount'),
    i(2, 'unemployment')
  })),
}, {
}
