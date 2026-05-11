return {
  snippets = {
    e = [[
${1:$MONTH/$DAY} ${2:!} ${6:payee} | ${7:desc}
  card:ce:${4:j}  -${3:amount} €
  ${5:from}]],
    r = [[
${1:$MONTH/$DAY} ${2:!} ${6:payee} | ${7:desc}
  card:ce:${4:j}  ${3:amount} €
  ${5:refund}]],
    i = [[
${1:$MONTH/$DAY} ${2:!} ${6:me} | ${7:salary}
  card:ce:${4:j}  ${3:amount} €
  ${5:salary/Thomas}]],
    t = [[
${1:$MONTH/$DAY} ${2:!} ${6:me} | ${7:transfert}
  ${4:to}  ${3:amount} €
  ${5:from}]],
    l = '${1:account}  ${0:amount} €',

    g = [[
${1:$MONTH/$DAY} ${2:!} ${6:grandfrais} | ${7:courses}
  card:ce:${4:j}  -${3:amount} €
  groceries]],
    q = [[
${1:$MONTH/$DAY} ${2:*} ${6:église} | ${7:quête}
  ${4:cash}  -${3:amount} €
  charities]],
  },
  skeletons = {}
}
