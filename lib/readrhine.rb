# -*- coding: utf-8 -*-

require 'readrhine/system_extensions'
require 'readrhine/buffer'
require 'readrhine/display'
require 'readrhine/tty'
require 'readrhine/undo'
require 'readrhine/command'
require 'readrhine/keymap'

require 'readrhine/default_keymap'
require 'readrhine/readrhine'


if __FILE__ == $0
  # ReadRhine.keymap["\x00"] = :forward_char
  str = ReadRhine.readline('> ')
  p str
end
