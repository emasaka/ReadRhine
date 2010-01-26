# -*- coding: utf-8 -*-

module ReadRhine
  module Undo
    INSERT = 1
    DELETE = 2

    Entry = Struct.new('Entry', :what, :point, :size, :text, :next)

    @@undo_list = nil

    def self.add(what, point, size, text)
      entry = Undo::Entry.new(what, point, size, text, @@undo_list)
      @@undo_list = entry
    end

    def self.undo(buffer)
      entry = @@undo_list
      case entry.what
      when Undo::INSERT
        buffer.point = entry.point
        buffer.delete_char(entry.size)
      when Undo::DELETE
        buffer.point = entry.point
        buffer.insert(entry.text)
      end
      @@undo_list = entry.next
    end

  end
end
