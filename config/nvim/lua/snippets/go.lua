return {
  snippets = {
    d = 'func ${1:name}(${2:args}) ${3:type} {\n\t$0\n}',
    s = 'type ${1:Name} struct {\n\t$0\n}',
    a = 'type ${1:Name} = ${2:type}',
    p = 'fmt.Println(${1:args})',
  },
  skeletons = {}
}
