---@diagnostic disable: undefined-global

local curdate = function() return os.date('%m/%d') end

return {
  -- definitions
  s('e', fmta([[
  <> ! <> | <>
    <>  -<> €
    <>
  ]], {
    f(curdate),
    i(4, 'payee'),
    i(5, 'desc'),
    i(2, 'card:ce'),
    i(1, 'amount'),
    i(3, 'to')
  })),
  s('r', fmta([[
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
  s('i', fmta([[
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
  s('t', fmta([[
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
  s('g', fmta([[
  <> ! <> | courses
    <>  -<> €
    groceries
  ]], {
    f(curdate),
    i(1, 'grandfrais'),
    i(3, 'card:bp'),
    i(2, 'amount'),
  })),

  s('l', fmta('<>  <> €', {
    i(1, 'account'),
    i(0, 'amount')
  })),

  -- Specific expenses
  s('m', fmta([[
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
  s('q', fmta([[
  <> * église | quête
    charities  <> €
    <>
  ]], {
    f(curdate),
    i(1, 'amount'),
    i(0, 'from')
  })),
}, {
}
