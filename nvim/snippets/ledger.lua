---@diagnostic disable: undefined-global

local curdate = function() return os.date('%m/%d') end

return {
  -- definitions
  s("e", fmta([[
  <> ! <> | <>
    <>  <> €
    <>
  ]], {
    f(curdate),
    i(1, 'payee'),
    i(2, 'desc'),
    i(3, 'to'),
    i(4, 'amount'),
    i(0, 'card:ce')
  })),
  s("r", fmta([[
  <> ! <> | <>
    <>  <> €
    refund
  ]], {
    f(curdate),
    i(1, 'me'),
    i(2, 'desc'),
    i(3, 'card:ce'),
    i(4, 'amount'),
  })),
  s("i", fmta([[
  <> * <>
    card:<>  <> €
    salary/<>
  ]], {
    f(curdate),
    i(1, 'me'),
    i(2, 'ce'),
    i(3, 'amount'),
    i(0, 'Thomas')
  })),
  s("t", fmta([[
  <> * <> | transfert
    <>  <> €
    <>
  ]], {
    f(curdate),
    i(1, 'me'),
    i(2, 'to'),
    i(3, 'amount'),
    i(0, 'from')
  })),
  s("del", fmta([[
  <> ! deliveroo | <>
    restaurant  <> €
    swile      -<> €
    card:ce    -<> €
  ]], {
    f(curdate),
    i(1, 'desc'),
    i(2, 'amount'),
    i(3, 'amount'),
    i(4, 'amount')
  })),
  s("g", fmta([[
  <> ! <> | courses
    groceries  <> €
    <>
  ]], {
    f(curdate),
    i(1, 'grandfrais'),
    i(2, 'amount'),
    i(3, 'card:bp'),
  })),

  s("l", fmta("<>  <> €", {
    i(1, 'account'),
    i(0, 'amount')
  })),

  -- Specific expenses
  s("m", fmta([[
  <> * caisse d'épargne | échéance crédit
    card:ce  -1403.16 €
    mortgage  1051.63 €
    bank:loans
  <> * caisse d'épargne | assurance crédit
    bank:fees  3.05 €
    card:ce
  ]], {
    f(curdate), f(curdate),
  })),
  s("q", fmta([[
  <> * église | quête
    charities  <> €
    <>
  ]], {
    f(curdate),
    i(1, 'amount'),
    i(0, 'from')
  })),
  s("c", fmta([[
  <> <> <> | courses
    groceries  <> €
    <>
  ]], {
    f(curdate),
    i(1, '!'),
    i(2, 'amazon'),
    i(3, 'amount'),
    i(0, 'card:ce')
  })),
}, {
}
