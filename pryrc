Pry.config.pager = false

prompt = lambda do |level, instance|
  color, suffix = if instance.last_file.nil?
    ["[29m", ""]
  else
    ["[31m", "-dbg"]
  end
  if level > 0
    " \e#{color}\e[0m \e[3m(pry#{suffix}:#{level})\e[0m"
  else
    " \e#{color}\e[0m \e[3m(pry#{suffix})\e[0m"
  end
end

Pry.config.prompt = Pry::Prompt.new(
  "custom",
  "my custom prompt",
  [ proc { "#{prompt.(_2, _3)} \e[32m󰄾\e[0m " }, proc { "#{prompt.(_2, _3)} \e[33m󰄼\e[0m " }]
)

begin
  load "#{Dir.home}/.pryrc.local"
rescue LoadError
end

# vim:ft=ruby
