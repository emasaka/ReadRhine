# -*- coding: utf-8 -*-

class ReadRhine
  class NoMoreUndo < StandardError; end

  class Undo
    INSERT = 1
    DELETE = 2
    G_BEGIN = 3
    G_END = 4

    Entry = Struct.new('Entry', :what, :point, :size, :text, :next)

    def initialize(buffer)
      @undo_list = nil
      @buffer = buffer
    end

    def add(what, point, size, text)
      entry = Undo::Entry.new(what, point, size, text, @undo_list)
      @undo_list = entry
    end

    def undo
      raise ReadRhine::NoMoreUndo unless @undo_list
      case @undo_list.what
      when Undo::INSERT
        @buffer.point = @undo_list.point
        @buffer.delete_char(@undo_list.size)
      when Undo::DELETE
        @buffer.point = @undo_list.point
        @buffer.insert(@undo_list.text)
      when Undo::G_END
        @undo_list = @undo_list.next
        undo until @undo_list.what == Undo::G_BEGIN
      end
      @undo_list = @undo_list.next
    end

  end
end
