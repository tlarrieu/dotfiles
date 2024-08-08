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
    i(5, 'card:ce')
  })),
  s("i", fmta([[
  <> ! me
    card:ce  <> €
    <>
  ]], {
    f(function() return os.date('%m/%d') end),
    i(1, 'amount'),
    i(2, 'unemployment')
  })),
  s("t", fmta([[
  <> ! me | transfert
    <>  <> €
    <>
  ]], {
    f(function() return os.date('%m/%d') end),
    i(1, 'to'),
    i(2, 'amount'),
    i(3, 'from')
  })),
  s("m", fmta([[
  <> * caisse d'épargne | échéance crédit
    card:ce  -1403.16 €
    mortgage  1051.63 €
    bank:loans
  ]], {
    f(function() return os.date('%m/%d') end),
  })),
}, {
}
