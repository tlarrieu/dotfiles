---@diagnostic disable: undefined-global

local curdate = function() return os.date('%m/%d') end

return {
  -- definitions
  s('e', fmta([[
  <> ! <> | <>
    <>  -<> €
    <>
  ]], { f(curdate), i(4, 'payee'), i(5, 'desc'), i(2, 'card:ce:j'), i(1, 'amount'), i(3, 'to') })),
  s('r', fmta([[
  <> ! <> | <>
    <>  <> €
    refund
  ]], { f(curdate), i(1, 'me'), i(2, 'desc'), i(3, 'card:ce:j'), i(4, 'amount') })),
  s('i', fmta([[
  <> * <>
    card:<>  <> €
    salary/<>
  ]], { f(curdate), i(1, 'me'), i(2, 'ce'), i(3, 'amount'), i(0, 'Thomas') })),
  s('t', fmta([[
  <> * <> | transfert
    <>  <> €
    <>
  ]], { f(curdate), i(1, 'me'), i(2, 'to'), i(3, 'amount'), i(0, 'from') })),

  s('l', fmta('<>  <> €', { i(1, 'account'), i(0, 'amount') })),

  -- Specific expenses
  s('c', fmta([[
  <> * me | retrait
    cash  <> €
    card:<>
  ]], { f(curdate), i(1, 'amount'), i(2, 'ce') })),
  s('g', fmta([[
  <> ! <> | courses
    <>  -<> €
    groceries
  ]], { f(curdate), i(3, 'grandfrais'), i(2, 'card:ce:j'), i(1, 'amount') })),
  s('q', fmta([[
  <> * église | quête
    <>  -<> €
    charities
  ]], {
    f(curdate),
    i(2, 'from'),
    i(1, 'amount')
  })),
  s('sfr', fmta([[
  <> * sfr | abonnement téléphone Miriam
    card:ce:j  -11.68 €
    phone
  ]], { f(curdate) })),
  s('rent', fmta([[
  <> * mme Evain | loyer + charges
    card:ce  -800 €
    rent      730 €
    charges   70  €
  ]], { f(curdate) })),
}, {
}
