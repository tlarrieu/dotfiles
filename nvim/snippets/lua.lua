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
  s("mod", fmta([[
    local _M = {}

    <>

    return _M]],
    { i(0) }
  )),

  -- control structures
  s("for", fmta([[
    for <> in <> do
      <>
    end]],
    { i(1, "x"), i(2, "xs"), i(0) }
  )),

  -- common patterns
  s("req", fmta("require('<>')", { i(1) })),
  s("ins", fmta("print(vim.inspect(<><>))", { sel(1), i(1) })),
  s("dump", fmta("require('gears.debug').dump_return(<>)", { i(0) })),
  s("notif", fmta("require('naughty').notify({ text = <> })", { i(0) })),

  -- snippets
  rs("(r?s)", fmta([[<>("<>", fmta(<>, {<>})),]], { cap(1), i(1, "expr"), i(2), i(3) })),

  -- nvim
  s("au", fmta([[
    vim.api.nvim_create_autocmd('<>', {
      pattern = { <> },
      callback = function()
        <>
      end,
      group = <>
    })
    ]], { i(1, 'event'), i(2, "'pattern'"), i(0), i(3, 'group') })),
  s("aug", fmta([[vim.api.nvim_create_augroup('<>', {})]], { i(1, 'groupname') })),
  s("map", fmta([[
    vim.keymap.set(<>, '<>', '<>', { <> })
    ]], { i(1, "mode"), i(2, "lhs"), i(3, "rhs"), i(4, "options") })),
}, {
  s("__snippets", fmta([[
    ---@diagnostic disable: undefined-global

    return {
      <>
    }, {
    }
    ]], { i(0) })),
  s("__plugin", fmta([[
    return {
      '<>',
      <>
    }]], { i(1, 'repo'), i(0) })),
}
