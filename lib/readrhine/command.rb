# -*- coding: utf-8 -*-

module ReadRhine
  def self.insert_char(count, key)
    s = (count == 1 ? key : key * count)
    @@undo.add(Undo::INSERT, @@buffer.point, s.size, nil)
    @@buffer.insert(s)
  end

  def self.backward_delete_char(count, key)
    deleted = @@buffer.delete_char(- count)
    @@undo.add(Undo::DELETE, @@buffer.point, nil, deleted) if deleted
  end

  def self.delete_char(count, key)
    deleted = @@buffer.delete_char(count)
    @@undo.add(Undo::DELETE, @@buffer.point, nil, deleted) if deleted
  end

  def self.unix_line_discard(count, key)
    deleted = @@buffer.delete_char(- @@buffer.point)
    @@undo.add(Undo::DELETE, @@buffer.point, nil, deleted) if deleted
  end

  def self.kill_line(count, key)
    deleted = @@buffer.delete_char(@@buffer.size - @@buffer.point)
    @@undo.add(Undo::DELETE, @@buffer.point, nil, deleted) if deleted
  end

  def self.backward_char(count, key)
    @@buffer.point -= count
    @@buffer.point = 0 if @@buffer.point < 0
  end

  def self.forward_char(count, key)
    @@buffer.point += count
    @@buffer.point = @@buffer.size if @@buffer.point > @@buffer.size
  end

  def self.beginning_of_line(count, key)
    @@buffer.point = 0
  end

  def self.end_of_line(count, key)
    @@buffer.point = @@buffer.size
  end

  def self.undo(count, key)
    count.times do
      @@undo.undo(@@buffer)
    end
  end

end
