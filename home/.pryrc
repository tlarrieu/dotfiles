# frozen_string_literal: true

Pry.config.pager = false

prompt = lambda do |level, instance|
  color, suffix =
    if instance.last_file.nil?
      ['[29m', defined?(Rails) ? '-rails' : '']
    else
      ['[31m', '-dbg']
    end
  if level.positive?
    " \e#{color}\e[0m \e[3m(pry#{suffix}:#{level})\e[0m"
  else
    " \e#{color}\e[0m \e[3m(pry#{suffix})\e[0m"
  end
end

Pry.config.prompt = Pry::Prompt.new(
  'custom',
  'my custom prompt',
  [proc { "#{prompt.call(_2, _3)} \e[32m󰄾\e[0m " }, proc { "#{prompt.call(_2, _3)} \e[33m󰄼\e[0m " }]
)

def write(str)
  File.open("#{Dir.home}/output.txt", 'w+') { _1.write str }
end

begin
  load "#{Dir.home}/.pryrc.local"
rescue LoadError
  nil
end

# vim:ft=ruby
