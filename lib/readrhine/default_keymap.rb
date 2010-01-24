# -*- coding: utf-8 -*-

module ReadRhine
  @@keymap = Keymap.new

  @@keymap["\C-a"] = :beginning_of_line
  @@keymap["\C-b"] = :backward_char
  @@keymap["\C-d"] = :delete_char
  @@keymap["\C-e"] = :end_of_line
  @@keymap["\C-f"] = :forward_char
  @@keymap["\C-h"] = :backward_delete_char
  @@keymap["\C-k"] = :kill_line
  @@keymap["\C-u"] = :unix_line_discard
  @@keymap["\x7f"] = :backward_delete_char

  @@keymap["\e[D"] = :backward_char
  @@keymap["\e[C"] = :forward_char
end
