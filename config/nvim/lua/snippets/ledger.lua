return {
  snippets = {
    d = '$MONTH/$DAY',
    l = '\t${1:account}  ${0:amount} €',

    e = [[
$MONTH/${6:$DAY} ${7:!} ${4:payee} | ${5:description}
  ${3|card:ce:j,cash|}  -${1:amount} €
  ${2:from}]],
    i = [[
$MONTH/${6:$DAY} ${7:*} ${4|me,miriam|} | ${5:desc}
  ${3:card:ce:j}  ${1:amount} €
  ${2|salary/Thomas,CPAM,refund,transfers|}]],

    c = [[
$MONTH/${6:$DAY} ${7:!} ${4:payee} | ${5|parking,essence,lavage,péage|}
  card:ce:j  -${1:amount} €
  car:${2|parking,gas,wash,toll|}]],
    q = [[
$MONTH/${6:$DAY} ${7:*} église | quête
  ${3|cash,card:ce:j|}  -${1:amount} €
  charities]],
    g = [[
$MONTH/${6:$DAY} ${7:!} ${4|intermarché,grandfrais,jardin du lupin,leclerc,kazidomi|} | courses
  ${3|card:ce:j,cash|}  -${1:amount} €
  groceries]],
  },
  skeletons = {}
}
