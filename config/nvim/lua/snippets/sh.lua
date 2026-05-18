local shebang = '#!/usr/bin/env bash'

local case = [[
case ${1:var} in
  ${2:value})
    $3
    ;;
  *)
    $4
    ;;
esac]]

return {
  snippets = {
    ['!'] = shebang,

    d = "${1:name}($2) {\n\t$0\n}",
    ['if'] = "if [ ${1:statement} ]; then\n\t$0\nfi",
    case = case,
  },
  skeletons = {
    { pattern = '.*', template = shebang .. '\n\n' },
  }
}
