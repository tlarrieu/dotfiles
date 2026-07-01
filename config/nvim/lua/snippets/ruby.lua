local base = function(template) return '# frozen_string_literal: true\n\n' .. template end

local class = function(ancestor)
  return base('class $RB_CLASS_NAME < ' .. ancestor .. [[

  $0
end]])
end

local modclass = function(ancestor)
  return base([[module $RB_MODULE_NAME
  class $RB_CLASS_NAME < ]] .. ancestor .. [[

    $0
  end
end]])
end

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
    c = 'class ${1:$RB_CLASS_NAME}\n\t$0\nend',
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
    it = "it('${1:does something}') { $0 }",
    ibl = "it_behaves_like '${1:name}'",
    e = 'expect($1).${2|to,not_to|} ',
    eb = 'expect { $1 }.${2|to,not_to|} ',
    dc = 'described_class ',

    p = 'puts ',
    pry = 'Kernel.binding.pry',
    ['.tp'] = '.tap { |o| ${1:Kernel.binding.pry} }',

    flip = 'Flipper.enable?(:${1:feature}, ${2:actor})',
    sentry = [[
Sentry.capture_exception(
  $1,
  level: ${2::info},
  extra: ${3:{\}},
)]],
    so = 'SENTRY_OWNER = Constants::SentryOwners::TAX_CONNECT',
  },
  skeletons = {
    { pattern = 'app/models/.+/.*%.rb', template = modclass('ShardedRecord') },
    { pattern = 'app/services/.+/.*%.rb', template = modclass('ApplicationService') },
    { pattern = 'app/controllers/.+/.*%.rb', template = modclass('ApplicationController') },
    { pattern = 'app/mailer/.+/.*%.rb', template = modclass('ApplicationMailer') },

    { pattern = 'app/models/.*%.rb', template = class('ApplicationRecord') },
    { pattern = 'app/services/.*%.rb', template = class('ApplicationService') },
    { pattern = 'app/controllers/.*%.rb', template = class('ApplicationController') },
    { pattern = 'app/mailer/.*%.rb', template = class('ApplicationMailer') },
    { pattern = 'app/tasks/maintenance/.*%.rb', template = class('MaintenanceTasks::Task') },

    { pattern = '_spec%.rb$', template = base('describe ${1:$RB_SPEC_NAME} do\n\t$0\nend') },
    { pattern = '.*', template = '# frozen_string_literal: true\n\n' },
  }
}
