return {
  snippets = {
    d = '$1:\n\t$0',
    doc = '[group("$1"), doc("$2")]',
    a = 'alias $1 := $2',
  },
  skeletons = {
    { pattern = '.*', template = '@_usage:\n\tjust -l\n\n' },
  }
}
