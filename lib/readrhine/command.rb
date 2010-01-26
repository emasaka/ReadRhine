# -*- coding: utf-8 -*-

module ReadRhine
  def self.insert_char(count)
    s = (count == 1 ? @@last_command_char : @@last_command_char * count)
    Undo.add(Undo::INSERT, @@buffer.point, s.size, nil)
    @@buffer.insert(s)
  end

  def self.backward_delete_char(count)
    deleted = @@buffer.delete_char(- count)
    Undo.add(Undo::DELETE, @@buffer.point, nil, deleted) if deleted
  end

  def self.delete_char(count)
    deleted = @@buffer.delete_char(count)
    Undo.add(Undo::DELETE, @@buffer.point, nil, deleted) if deleted
  end

  def self.unix_line_discard(count)
    deleted = @@buffer.delete_char(- @@buffer.point)
    Undo.add(Undo::DELETE, @@buffer.point, nil, deleted) if deleted
  end

  def self.kill_line(count)
    deleted = @@buffer.delete_char(@@buffer.size - @@buffer.point)
    Undo.add(Undo::DELETE, @@buffer.point, nil, deleted) if deleted
  end

  def self.backward_char(count)
    @@buffer.point -= count
    @@buffer.point = 0 if @@buffer.point < 0
  end

  def self.forward_char(count)
    @@buffer.point += count
    @@buffer.point = @@buffer.size if @@buffer.point > @@buffer.size
  end

  def self.beginning_of_line(count)
    @@buffer.point = 0
  end

  def self.end_of_line(count)
    @@buffer.point = @@buffer.size
  end

  def self.undo(count)
    count.times do
      Undo.undo(@@buffer)
    end
  end

end
