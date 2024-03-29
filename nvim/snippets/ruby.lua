---@diagnostic disable: undefined-global

return {
  -- skeletons
  s("_skel", fmta([[
    #!/usr/bin/env ruby
    # frozen_string_literal: true

    <>
    ]], { i(0) })),

  s("#!", fmta("#!/usr/bin/env ruby", {})),
  s("fr", fmta("# frozen_string_literal: true", {})),

  -- requires / includes
  s("req", fmta("require '<>'", { i(1) })),
  s("reqr", fmta("require_relative '<>'", { i(1) })),
  s("inc", fmta("include <>", { i(1, "Module") })),
  s("gem", fmta("gem '<>'", { i(1, "name") })),

  -- definitions
  s("m", fmta([[
    module <>
      <><>
    end
    ]], { i(1, "Name"), visual(), i(0) })),
  s("c", fmta([[
    class <>

      <><>

    end
    ]], { i(1, h.pascalize(h.basename())), visual(), i(0) })),
  s("d", fmta([[
    def <>
      <><>
    end
    ]], { i(1, "name"), visual(), i(0) })),
  s("di", fmta([[
    def initialize<>
      <><>
    end
    ]], { i(1), visual(), i(0) })),

  -- accessors
  s("r", fmta("attr_reader :<>", { i(0) })),
  s("w", fmta("attr_writer :<>", { i(0) })),
  s("rw", fmta("attr_accessor :<>", { i(0) })),

  -- lambdas
  s("-", fmta("->>(<>) { <><> }", { i(1, "i"), visual(), i(2) })),
  s("fn", fmta([[
    lambda do |<>|
      <><>
    end
    ]], { i(1, "i"), visual(), i(2) })),

  -- methods
  rs("(.+).times", fmta("<>.times { |<>| <> }", { cap(1), i(1, "i"), i(2) })),
  rs("(.+).red", fmta("<>.reduce { |<>| <> }", { cap(1), i(1, "i"), i(2) })),
  rs("(.+).map", fmta("<>.map { |<>| <> }", { cap(1), i(1, "i"), i(2) })),
  rs("(.+).sel", fmta("<>.select { |<>| <> }", { cap(1), i(1, "i"), i(2) })),
  rs("(.+).tap", fmta("<>.tap { |<>| <> }", { cap(1), i(1, "i"), i(2) })),
  rs("(.+).i", fmta("<>.inspect { |<>| <> }", { cap(1), i(1, "i"), i(2) })),

  -- specs
  s("desc", fmta([[
    describe '<>' do
      <><>
    end
    ]], { i(1, "subject_name"), visual(), i(0) })),
  s("cont", fmta([[
    context '<>' do
      <><>
    end
    ]], { i(1, "context_name"), visual(), i(0) })),
  s("sh", fmta([[
    shared_example '<>' do
      <><>
    end
    ]], { i(1, "name"), visual(), i(0) })),
  s("sc", fmta([[
    shared_context '<>' do
      <><>
    end
    ]], { i(1, "name"), visual(), i(0) })),
  s("bef", fmta([[
    before do
      <><>
    end
    ]], { visual(), i(0) })),
  s("sub", fmta("subject(:<>) { <><> }", { i(1, "name"), visual(), i(0) })),
  s("let", fmta("let(:<>) { <><> }", { i(1, "name"), visual(), i(0) })),
  s("let!", fmta("let!(:<>) { <><> }", { i(1, "name"), visual(), i(0) })),
  s("it", fmta([[
  it '<>' do
    <><>
  end
  ]], { i(1, "example title"), visual(), i(0) })),
  s("exp", fmta("expect(<>).to <>)", { i(1, "subject"), i(0) })),

  -- debug
  s("pp", fmta("require 'pp'; pp(<><>)", { visual(), i(1) })),
  s("p", fmta("puts(<><>)", { visual(), i(1) })),
  s("red", fmta([[
    print("\e[31m")
    <><>
    print("\e[0m")
    ]], { visual(), i(1) })),
  s("gr", fmta([[
    print("\e[32m")
    <><>
    print("\e[0m")
    ]], { visual(), i(1) })),
  s("yel", fmta([[
    print("\e[33m")
    <><>
    print("\e[0m")
    ]], { visual(), i(1) })),
  s("blue", fmta([[
    print("\e[34m")
    <><>
    print("\e[0m")
    ]], { visual(), i(1) })),
  s("pink", fmta([[
    print("\e[35m")
    <><>
    print("\e[0m")
    ]], { visual(), i(1) })),
  s("cyan", fmta([[
    print("\e[36m")
    <><>
    print("\e[0m")
    ]], { visual(), i(1) })),
}, {
}
