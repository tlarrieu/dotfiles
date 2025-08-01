---@diagnostic disable: undefined-global

return {
  s("#!", fmta("#!/usr/bin/env ruby", {})),
  s("fr", fmta("# frozen_string_literal: true", {})),

  -- requires / includes
  s("req", fmta("require '<>'", { i(1) })),
  s("reqr", fmta("require_relative '<>'", { i(1) })),
  s("inc", fmta("include <>", { i(1, "Module") })),
  s("ex", fmta("extend <>", { i(1, "Module") })),
  s("gem", fmta("gem '<>'", { i(1, "name") })),

  -- definitions
  s("m", fmta([[
    module <>
      <><>
    end
    ]], { i(1, "Name"), sel(), i(0) })),
  s("c", fmta([[
    class <>
      <><>
    end
    ]], { i(1, h.pascalize(h.basename())), sel(), i(0) })),
  s("d", fmta([[
    def <>
      <><>
    end
    ]], { i(1, "name"), sel(), i(0) })),
  s("di", fmta([[
    def initialize<>
      <><>
    end
    ]], { i(1), sel(), i(0) })),
  s("do", fmta([[
    do<>
      <><>
    end
    ]], { i(1), sel(), i(0) })),
  s("r", fmta("return ", {})),
  s("l", fmta("<> = <>", { i(1, 'lhs'), i(2, 'rhs') })),
  s("if", fmta([[
    if <>
      <><>
    end
    ]], { i(1), sel(), i(0) })),
  s("unless", fmta([[
    unless <>
      <><>
    end
    ]], { i(1), sel(), i(0) })),
  s("raise", fmta([[
    raise <> <> <>
    ]], {
    i(1, "'houston we have a problem'"),
    i(2, 'if'),
    i(3, 'condition')
  })),

  -- accessors
  s("ar", fmta("attr_reader :<>", { i(0) })),
  s("aw", fmta("attr_writer :<>", { i(0) })),
  s("rw", fmta("attr_accessor :<>", { i(0) })),

  -- lambdas
  s("-", fmta("->>(<>) { <><> }", { i(1, "i"), sel(), i(2) })),
  s("fn", fmta([[
    lambda do |<>|
      <><>
    end
    ]], { i(1, "i"), sel(), i(2) })),

  -- methods
  rs("(.+)%.times", fmta("<>.times { <> }", { cap(1), i(1) })),
  rs("(.+)%.red", fmta("<>.reduce { <> }", { cap(1), i(1) })),
  rs("(.+)%.map", fmta("<>.map { <> }", { cap(1), i(1) })),
  rs("(.+)%.each", fmta("<>.each { <> }", { cap(1), i(1) })),
  rs("(.+)%.sel", fmta("<>.select { <> }", { cap(1), i(1) })),
  rs("(.+)%.tap", fmta("<>.tap { <> }", { cap(1), i(1) })),
  rs("(.+)%.ins", fmta("<>.inspect", { cap(1) })),

  -- minitest
  s("t", fmta([[
    test '<>' do
      <><>
    end
    ]], { i(1, "it works"), sel(), i(0) })),

  -- specs
  s("desc", fmta([[
    describe '<>' do
      <><>
    end
    ]], { i(1, "topic"), sel(), i(0) })),
  s("cont", fmta([[
    context '<>' do
      <><>
    end
    ]], { i(1, "when something"), sel(), i(0) })),
  s("with", fmta([[
    context 'with <>' do
      <><>
    end
    ]], { i(1, "something"), sel(), i(0) })),
  s("when", fmta([[
    context 'when <>' do
      <><>
    end
    ]], { i(1, "something"), sel(), i(0) })),
  s("se", fmta([[
    shared_examples '<>' do
      <><>
    end
    ]], { i(1, "name"), sel(), i(0) })),
  s("sc", fmta([[
    shared_context '<>' do
      <><>
    end
    ]], { i(1, "name"), sel(), i(0) })),
  s("bef", fmta([[
    before do
      <><>
    end
    ]], { sel(), i(0) })),
  s("sub", fmta("subject(:<>) { <><> }", { i(1, "name"), sel(), i(0) })),
  s("let", fmta("let(:<>) { <><> }", { i(1, "name"), sel(), i(0) })),
  s("lett", fmta("let!(:<>) { <><> }", { i(1, "name"), sel(), i(0) })),
  s("lib", fmta("let_it_be(:<>) { <><> }", { i(1, "name"), sel(), i(0) })),
  s("it", fmta([[
  it '<>' do
    <><>
  end
  ]], { i(1, "does something"), sel(), i(0) })),
  s("ibl", fmta("it_behaves_like '<>'", { i(1, "example") })),
  s("e", fmta("expect(<>).to <>", { i(1, "subject"), i(0) })),
  s("eb", fmta("expect { <> }.to <>", { i(1, "subject"), i(0) })),

  -- debug
  s("sentry", fmta([[
    Sentry.capture_exception(
      <>,
      level: <>,
      extra: <>,
    )
  ]], { i(1, "e"), i(2, ":info"), i(3, "{}") })),
  s("pry", fmta("Kernel.binding.pry", {})),
  s(".tp", fmta(".tap { |o| Kernel.binding.pry }", {})),
  s("bb", fmta("byebug", {})),
  s("p", fmta("puts <><>", { sel(), i(1) })),
  s("deb", fmta([[
    print "\e[31m"
    puts "------------->> <>: #{<>}"
    print "\e[0m"
    ]], { i(1), rep(1) })),
  s("red", fmta([[
    print "\e[31m"
    <><>
    print "\e[0m"
    ]], { sel(), i(1) })),
  s("gr", fmta([[
    print "\e[32m"
    <><>
    print "\e[0m"
    ]], { sel(), i(1) })),
  s("yel", fmta([[
    print "\e[33m"
    <><>
    print "\e[0m"
    ]], { sel(), i(1) })),
  s("blue", fmta([[
    print "\e[34m"
    <><>
    print "\e[0m"
    ]], { sel(), i(1) })),
  s("pink", fmta([[
    print "\e[35m"
    <><>
    print "\e[0m"
    ]], { sel(), i(1) })),
  s("cyan", fmta([[
    print "\e[36m"
    <><>
    print "\e[0m"
    ]], { sel(), i(1) })),
}, {
  -- skeletons
  s("__skel", fmta([[
    #!/usr/bin/env ruby
    # frozen_string_literal: true

    <>
    ]], { i(0) })),
  s("__spec", fmta([[
    # frozen_string_literal: true

    Rspec.describe <> do
      <>
    end
    ]], { i(1, 'class'), i(0) })),
  s("__short_spec", fmta([[
    # frozen_string_literal: true

    describe <> do
      <>
    end
    ]], { i(1, 'class'), i(0) })),
  s("pry", fmta("Kernel.binding.pry", {})),
  s(".tp", fmta(".tap { |o| binding.pry }", {})),
}
