local smallbreak = '\n\\smallbreak\n\n'
local psalmus = '\\psalmus{$1}{$2}{\n$3\n}'
local env = '\\begin{$1}\n$2\n\\end{$1}'
return {
  snippets = {
    sb = smallbreak,
    Sb = smallbreak,
    ps = psalmus,
    Ps = psalmus,
    env = env,
    Env = env,
  },
  skeletons = {}
}
