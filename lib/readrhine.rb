# -*- coding: utf-8 -*-

require 'readrhine/system_extensions'
require 'readrhine/buffer'
require 'readrhine/display'
require 'readrhine/tty'
require 'readrhine/undo'
require 'readrhine/command'
require 'readrhine/keymap'
require 'readrhine/history'

require 'readrhine/default_keymap'
require 'readrhine/readrhine'


if __FILE__ == $0
  while true
    str = ReadRhine.readline('> ', true)
    break if str.empty?
    p str
  end
end
