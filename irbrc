#!/usr/bin/env ruby
# frozen_string_literal: true

require 'irb/completion'

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{Dir.home}/.irb_history"

IRB.conf[:PROMPT_MODE] = :CUSTOM

IRB.conf[:AUTO_INDENT] = true

prompt = " \e[29m\e[0m \e[3m(%M)\e[0m"

IRB.conf[:PROMPT][:CUSTOM] = {
  PROMPT_I: "#{prompt} \e[32m󰄾\e[0m ",
  PROMPT_C: "#{prompt} \e[33m󰄼\e[0m ",
  PROMPT_S: "#{prompt} \e[31m󰝗\e[0m ",
  RETURN: "=> %s\n"
}

begin
  load "#{Dir.home}/.irbrc.local"
rescue LoadError
end
