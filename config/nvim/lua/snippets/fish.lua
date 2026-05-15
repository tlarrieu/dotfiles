return {
  snippets = {
    ['!'] = '#!/usr/bin/env fish',

    d = "function ${1:name}\n\t${0}\nend",
    r = 'return ',
  },
  skeletons = {}
}
