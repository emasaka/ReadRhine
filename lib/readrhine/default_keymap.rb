# -*- coding: utf-8 -*-

class ReadRhine
  @@default_keymap = Keymap.new

  @@default_keymap["\C-a"] = :beginning_of_line
  @@default_keymap["\C-b"] = :backward_char
  @@default_keymap["\C-d"] = :delete_char
  @@default_keymap["\C-e"] = :end_of_line
  @@default_keymap["\C-f"] = :forward_char
  @@default_keymap["\C-h"] = :backward_delete_char
  @@default_keymap["\C-j"] = :done
  @@default_keymap["\C-k"] = :kill_line
  @@default_keymap["\C-m"] = :done
  @@default_keymap["\C-n"] = :next_history
  @@default_keymap["\C-p"] = :previous_history
  @@default_keymap["\C-u"] = :unix_line_discard
  @@default_keymap["\C-_"] = :undo
  @@default_keymap["\x7f"] = :backward_delete_char

  @@default_keymap["\C-x\C-u"] = :undo

  @@default_keymap["\e[D"] = :backward_char
  @@default_keymap["\e[C"] = :forward_char

end
