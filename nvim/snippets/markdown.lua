---@diagnostic disable: undefined-global

local warning = fmta([[
  >> [!warning]
  >> <>]], { i(0) })
local caution = fmta([[
  >> [!caution]
  >> <>]], { i(0) })
local error = fmta([[
  >> [!error]
  >> <>]], { i(0) })
local info = fmta([[
  >> [!info]
  >> <>]], { i(0) })
local question = fmta([[
  >> [!question]
  >> <>]], { i(0) })

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
  s("w", warning),
  s("W", warning),
  s("c", caution),
  s("C", caution),
  s("e", error),
  s("E", error),
  s("i", info),
  s("I", info),
  s("q", info),
  s("Q", question),

  -- link / image
  s("[", fmta("[<>](<>)", { i(1, "alttxt"), i(0, "url") })),
  s("!", fmta("![<>](<>)", { i(1, "alttxt"), i(0, "url") })),
}, {
}
