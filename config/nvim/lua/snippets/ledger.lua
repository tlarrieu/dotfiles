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

    c = [[
${6:$MONTH/$DAY} ${7:!} ${4:payee} | ${5|parking,essence,péage|}
  card:ce:j  -${1:amount} €
  car:${2|parking,gas,toll|}]],
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
