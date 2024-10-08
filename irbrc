#!/usr/bin/ruby
# frozen_string_literal: true

require 'irb/completion'
require 'irb/ext/save-history'

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{Dir.home}/.irb_history"

IRB.conf[:PROMPT_MODE] = :CUSTOM

IRB.conf[:AUTO_INDENT] = true

IRB.conf[:PROMPT][:CUSTOM] = {
  PROMPT_I: "\e[34mλ\e[0m \e[3m(%M)\e[0m \e[32m󰄾\e[0m ",
  PROMPT_C: "\e[34mλ\e[0m \e[3m(%M)\e[0m \e[33m󰄼\e[0m ",
  PROMPT_S: "\e[34mλ\e[0m \e[3m(%M)\e[0m \e[31m󰝗\e[0m ",
  RETURN: "=> %s\n"
}
