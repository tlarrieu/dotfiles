return {
  snippets = {
    e = [[
${6:$MONTH/$DAY} ${7:!} ${4:payee} | ${5:desc}
  ${3|card:ce:j,cash|}  -${1:amount} €
  ${2:from}]],
    i = [[
${6:$MONTH/$DAY} ${7:*} ${4|me,miriam|} | ${5:desc}
  ${3:card:ce:j}  ${1:amount} €
  ${2|salary/Thomas,CPAM,refund,transfers|}]],
    l = '${1:account}  ${0:amount} €',

    p = [[
${6:$MONTH/$DAY} ${7:!} ${4|parking,péage|}
  card:ce:j  -${1:amount} €
  ${2|car:parking,car:toll|}]],
    g = [[
${6:$MONTH/$DAY} ${7:!} ${4:grandfrais} | ${5:courses}
  ${3|card:ce:j,cash|}  -${1:amount} €
  groceries]],
    q = [[
${6:$MONTH/$DAY} ${7:*} église | quête
  ${3|cash,card:ce:j|}  -${1:amount} €
  charities]],
  },
  skeletons = {}
}
