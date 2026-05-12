local base = [[
# frozen_string_literal: true

]]

local spec = [[
# frozen_string_literal: true

describe ${1:topic} do
  $0
end]]

local sentry = [[
Sentry.capture_exception(
  $1,
  level: ${2::info},
  extra: ${3:{\}},
)
]]

return {
  snippets = {
    ['!'] = '#!/usr/bin/env ruby',
    ['#!'] = '#!/usr/bin/env ruby',
    fr = {
      inline = 'freeze',
      block = '# frozen_string_literal: true',
    },

    req = "require '${1:module}'",
    reqr = "require_relative '${1:module}'",
    inc = 'include ${1:Module}',
    ex = 'extend ${1:Module}',
    gem = "gem '${1:name}'",

    m = 'module ${1:Name}\n\t$0\nend',
    c = 'class ${1:$PASCALIZE_FNAME}\n\t$0\nend',
    d = 'def ${1:name}\n\t$0\nend',
    di = 'def initialize$1\n\t$0\nend',
    l = '@${1:var} = $1',
    ['if'] = 'if ${1:cond}\n\t$0\nend',
    ['unless'] = 'unless ${1:cond}\n\t$0\nend',
    ['eif'] = 'elsif ${1:cond}\n\t$0',
    raise = 'raise ${1:\'houston we have a problem\'} ${2:if} ${3:condition}',

    ar = 'attr_reader :',
    aw = 'attr_writer :',
    rw = 'attr_accessor :',

    ['-'] = '->(${1:i}) { $0 }',

    times = 'times { $0 }',
    red = 'reduce { $0 }',
    map = 'map { $0 }',
    each = 'each { $0 }',
    sel = 'select { $0 }',
    tap = 'tap { $0 }',
    ['then'] = 'then { $0 }',
    ins = 'inspect { $0 }',

    desc = 'describe ${1:topic} do\n\t$0\nend',
    cont = "context '${1:when ...}' do\n\t$0\nend",
    with = "context 'with ${1}' do\n\t$0\nend",
    when = "context 'when ${1}' do\n\t$0\nend",
    se = "shared_examples '${1:name}' do\n\t$0\nend",
    sc = "shared_context '${1:name}' do\n\t$0\nend",
    bef = 'before { $0 }',
    sub = 'subject(:${1:name}) { $0 }',
    let = 'let(:${1:name}) { $0 }',
    lett = 'let!(:${1:name}) { $0 }',
    lib = 'let_it_be(:${1:name}) { $0 }',
    it = "it '${1:does something}' { $0 }",
    ibl = "it_behaves_like '${1:name}'",
    e = 'expect($1).to ',
    eb = 'expect { $1 }.to ',

    p = 'puts ',
    pry = 'Kernel.binding.pry',
    ['.tp'] = '.tap { |o| ${1:Kernel.binding.pry} }',

    flip = 'Flipper.enable?(:${1:feature}, ${2:actor})',
    sentry = sentry,
  },
  skeletons = {
    ['base'] = base,
    ['spec'] = spec,
  }
}
