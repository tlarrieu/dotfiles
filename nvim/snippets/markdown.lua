---@diagnostic disable: undefined-global

return {
  -- fence
  rs("^`", fmta([[
    ``` <>
    <><>
    ```
    ]], { i(1, "lang"), sel(), i(0) })),
  rs("^[Cc]ode", fmta([[
    ``` <>
    <><>
    ```
    ]], { i(1, "lang"), sel(), i(0) })),
  rs("^[Rr]b", fmta([[
    ``` ruby
    <><>
    ```
    ]], { sel(), i(0) })),
  rs("^[Jj]s", fmta([[
    ``` javascript
    <><>
    ```
    ]], { sel(), i(0) })),
  rs("^[Gg]o", fmta([[
    ``` go
    <><>
    ```
    ]], { sel(), i(0) })),

  -- callouts
  s("warn", fmta([[
    >> [!warning]
    >> <>]], { i(0) })),
  s("caution", fmta([[
    >> [!caution]
    >> <>]], { i(0) })),
  s("error", fmta([[
    >> [!error]
    >> <>]], { i(0) })),
  s("info", fmta([[
    >> [!info]
    >> <>]], { i(0) })),

  -- link / image
  s("[", fmta("[<>](<>)", { i(1, "alttxt"), i(0, "url") })),
  s("!", fmta("![<>](<>)", { i(1, "alttxt"), i(0, "url") })),

  -- formatting
  s("b", fmta("**<><>**", { sel(), i(0) })),
  s("i", fmta("_<><>_", { sel(), i(0) })),
}, {
}
