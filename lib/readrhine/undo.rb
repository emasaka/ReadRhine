# -*- coding: utf-8 -*-

class ReadRhine
  class Undo
    INSERT = 1
    DELETE = 2

    Entry = Struct.new('Entry', :what, :point, :size, :text, :next)

    def initialize
      @undo_list = nil
    end

    def add(what, point, size, text)
      entry = Undo::Entry.new(what, point, size, text, @undo_list)
      @undo_list = entry
    end

    def undo(buffer)
      entry = @undo_list
      if entry
        case entry.what
        when Undo::INSERT
          buffer.point = entry.point
          buffer.delete_char(entry.size)
        when Undo::DELETE
          buffer.point = entry.point
          buffer.insert(entry.text)
        end
        @undo_list = entry.next
      end
    end

  end
end
