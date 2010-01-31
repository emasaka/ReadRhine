# -*- coding: utf-8 -*-

require 'readrhine/system_extensions'
require 'readrhine/buffer'
require 'readrhine/display'
require 'readrhine/tty'
require 'readrhine/undo'
require 'readrhine/command'
require 'readrhine/keymap'
require 'readrhine/history'
require 'readrhine/completion'

require 'readrhine/default_keymap'
require 'readrhine/readrhine'


if __FILE__ == $0
  if ARGV[0] == '--rlcompat'
    puts 'ReadRhine compatible'
    require 'readrhine/rlcompat'
    while true
      str = ReadRhine.readline('> ', true)
      break if str.empty?
      p str
    end
  else
    rl = ReadRhine.new(prompt: '> ', history: true)
    while true
      str = rl.readline
      break if str.empty?
      p str
    end
  end
end
