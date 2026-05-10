return {
  snippets = {
    e = [[
${6:$MONTH/$DAY} ${7:!} ${4:payee} | ${5:desc}
  card:ce:${2:j}  -${1:amount} €
  ${3:from}]],
    r = [[
${5:$MONTH/$DAY} ${6:!} ${3:me} | ${4:desc}
  card:ce:${2:j}  ${1:amount} €
  refund]],
    i = [[
${6:$MONTH/$DAY} ${7:!} ${4:me} | ${5:desc}
  card:ce:${2:j}  ${1:amount} €
  salary/${3:Thomas}]],
    t = [[
${6:$MONTH/$DAY} ${7:!} ${4:me} | ${5:transfert}
  ${2:to}  ${1:amount} €
  ${3:from}]],
    l = '${1:account}  ${0:amount} €',

    g = [[
${5:$MONTH/$DAY} ${6:!} ${3:grandfrais} | ${4:courses}
  card:ce:${2:j}  -${1:amount} €
  groceries]],
    q = [[
${4:$MONTH/$DAY} ${5:*} ${3:église} | quête
  ${2:cash}  -${1:amount} €
  charities]],
  },
  skeletons = {}
}
