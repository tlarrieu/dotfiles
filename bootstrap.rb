#!/usr/bin/env ruby
require 'fileutils'

force = false
unless ARGV.empty?
  if ARGV.first == "-f"
    force = true
  else
    puts "Unknown argument #{ARGV.first}."
    exit
  end
end

Jobs = {
  'vimrc' => '~/.vimrc',
  'vim' => '~/.vim',
  'fish_theme/smockey' => '~/.oh-my-fish/themes/smockey',
  'gitconfig' => '~/.gitconfig',
  'gitignore' => '~/.gitignore',
  'tmux.conf' => '~/tmux.conf'
}

def install force=false
  basedir = File.realdirpath('.')
  Jobs.each do |from, to|
    safelink(basedir + '/' + from, to)
  end
end

def safelink source, target, force=false
  remove = force
  if File.exist?(target)
    puts "#{target} already exists, do you want to replace it? "
    remove = ["yes", "y"].include? gets
  end
  FileUtils.rm_rf(target) if remove
  FileUtils.ln_sf(source, target)
end

install(force)
