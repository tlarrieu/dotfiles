---@diagnostic disable: undefined-global

local callout = function(label)
  return fmta([[
  >> [!]] .. label .. [[]
  >> <>]], { i(0) })
end

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
  s("w", callout('warning')),
  s("W", callout('warning')),
  s("c", callout('caution')),
  s("C", callout('caution')),
  s("e", callout('error')),
  s("E", callout('error')),
  s("i", callout('info')),
  s("I", callout('info')),
  s("q", callout('info')),
  s("Q", callout('question')),

  -- link / image
  s("[", fmta("[<>](<>)", { i(1, "alttxt"), i(0, "url") })),
  s("!", fmta("![<>](<>)", { i(1, "alttxt"), i(0, "url") })),
}, {
}
