---@diagnostic disable: undefined-global

return {
  -- fence
  s("`", fmta([[
    ``` <>
    <><>
    ```
    ]], { i(1, "lang"), sel(), i(0) })),

  -- link / image
  s("[", fmta("[<>](<>)", { i(1, "alttxt"), i(0, "url") })),
  s("!", fmta("![<>](<>)", { i(1, "alttxt"), i(0, "url") })),

  -- formatting
  s("b", fmta("**<><>**", { sel(), i(0) })),
  s("i", fmta("_<><>_", { sel(), i(0) })),
}, {
}
