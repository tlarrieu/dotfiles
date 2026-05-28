local code = function(lang)
  return [[``` ]] .. (lang or '${1:lang}') .. [[

$0
```]]
end

local callout = function(label)
  return [[
> [!]] .. label .. [[]
> $0]]
end

return {
  snippets = {
    code = code(),
    Code = code(),
    rb = code('ruby'),
    Rb = code('ruby'),
    js = code('javascript'),
    Js = code('javascript'),
    go = code('go'),
    Go = code('go'),

    ln = '[$1](${2:https://}$3)',
    Ln = '[$1](${2:https://}$3)',
    im = '![${1:alt}](${2:https://}$3)',
    Im = '![${1:alt}](${2:https://}$3)',

    w = callout('warning'),
    W = callout('warning'),
    c = callout('caution'),
    C = callout('caution'),
    e = callout('error'),
    E = callout('error'),
    i = callout('info'),
    I = callout('info'),
    q = callout('question'),
    Q = callout('question'),

    ['='] = '===',
    ['-'] = '---',
  },
  skeletons = {}
}
