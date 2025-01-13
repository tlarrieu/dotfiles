prompt = lambda do
  if _1 > 0
    " \e[31m\e[0m \e[3m(pry:#{_1})\e[0m"
  else
    " \e[31m\e[0m \e[3m(pry)\e[0m"
  end
end

Pry.config.prompt = Pry::Prompt.new(
  "custom",
  "my custom prompt",
  [ proc { "#{prompt.(_2)} \e[32m󰄾\e[0m " }, proc { "#{prompt.(_2)} \e[33m󰄼\e[0m " }]
)

begin
  load "#{Dir.home}/.pryrc.local"
rescue LoadError
end

# vim:ft=ruby
