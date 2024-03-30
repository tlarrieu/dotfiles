---@diagnostic disable: undefined-global

return {
  -- skeletons
  s("_skel", fmta([[
      #!/bin/sh

      <>
    ]], { i(0) })),
  s("!", fmta([[
      #!/bin/sh

      <>
    ]], { i(0) })),

  -- definitions
  s("d", fmta([[
    function <> {
      <><>
    }
    ]], { i(1, "name"), sel(), i(0) })),

  -- control structures
  s("if", fmta([[
    if [ <> ]; then
      <><>
    fi
    ]], { i(1, "statement"), sel(), i(0) })),

  s("case", fmta([[
    case <> in
      <>)
        <>
        ;;
      *)
        <>
        ;;}
    esac
    ]], { i(1, "var"), i(2, "value"), i(3), i(4) })),

  -- colors
  s("red", fmta('echo "$(tput setaf 1)<><>$(tput sgr0)"', { sel(), i(0) })),
  s("gr", fmta('echo "$(tput setaf 2)<><>$(tput sgr0)"', { sel(), i(0) })),
  s("yel", fmta('echo "$(tput setaf 3)<><>$(tput sgr0)"', { sel(), i(0) })),
  s("blue", fmta('echo "$(tput setaf 4)<><>$(tput sgr0)"', { sel(), i(0) })),
  s("pink", fmta('echo "$(tput setaf 5)<><>$(tput sgr0)"', { sel(), i(0) })),
  s("cyan", fmta('echo "$(tput setaf 6)<><>$(tput sgr0)"', { sel(), i(0) })),
}, {
}
