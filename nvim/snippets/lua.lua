---@diagnostic disable: undefined-global

return {
  -- annotations
  s("e", fmta([[---@]], {})),

  -- modules
  s("req", fmta("require('<>')", { i(1) })),
  s("mod", fmta([[
    local M = {}

    <>

    return M]],
    { i(0) }
  )),

  -- definitions
  rs("^%s*d", fmta([[
    local <> = function(<>)
      <><>
    end]],
    { i(1), i(2), sel(1), i(0) }
  )),
  s("d", fmta([[function(<>) <><> end]], { i(1), sel(1), i(0) })),
  s("l", fmta("local <> = <>", { i(1), i(0) })),
  s("r", fmta("return <><>", { sel(1), i(0) })),
  s("ret", fmta("return <><>", { sel(1), i(0) })),

  -- control structures
  s("for", fmta([[
    for <> in <> do
      <><>
    end]],
    { i(1, "x"), i(2, "xs"), sel(1), i(3) }
  )),
  s("if", fmta([[
    if <> then
      <><>
    end]],
    { i(1, "cond"), sel(1), i(2) }
  )),

  -- files
  s("open", fmta([[local <> = io.open(<>, <>)]], { i(1, 'file'), i(2, 'path'), i(3, "'r'") })),
  s("readl", fmta([[local <> = <>:read('*l')]], { i(1, 'str'), i(2, 'file') })),
  s("reada", fmta([[local <> = <>:read('*a')]], { i(1, 'str'), i(2, 'file') })),
  s("write", fmta([[<>:write(<>)]], { i(1, 'file'), i(2, 'str') })),

  -- misc
  s("p", fmta([[print(<><>)]], { sel(), i(1) })),
  s("pc", fmta([[pcall(function() <><> end)]], { sel(), i(1) })),

  -- awesome
  s("dump", fmta("require('gears.debug').dump_return(<>)", { i(0) })),
  s("notif", fmta("require('naughty').notify({ text = <> })", { i(0) })),

  -- snippets
  rs("(r?s)", fmta([[<>("<>", fmta(<>, {<>})),]], { cap(1), i(1, "expr"), i(2), i(3) })),

  -- nvim
  s("n", fmta([[vim.notify(<><>)]], { sel(), i(1) })),
  s("i", fmta("vim.inspect(<><>)", { sel(1), i(1) })),
  s("au", fmta([[
    vim.api.nvim_create_autocmd('<>', {
      pattern = { <> },
      callback = function()
        <>
      end,
      group = <>
    })
    ]], { i(1, 'event'), i(2, "'pattern'"), i(0), i(3, 'group') })),
  s("aug", fmta([[vim.api.nvim_create_augroup('<>', {})]], { i(0, 'groupname') })),
  s("key", fmta([[
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
    }]], { i(1), i(0) })),
}
