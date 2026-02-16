---@diagnostic disable: undefined-global

return {
  s("!", fmta("#!/usr/bin/env fish", {})),

  s("d", fmta([[
    function <>
      <><>
    end
    ]], { i(1, "name"), sel(), i(0) })),
}, {
}
