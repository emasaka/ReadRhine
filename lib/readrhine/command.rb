# -*- coding: utf-8 -*-

module ReadRhine
  def self.insert_char(count)
    s = (count == 1 ? @@last_command_char : @@last_command_char * count)
    @@buffer.insert(s)
  end

  def self.backward_delete_char(count)
    @@buffer.delete_char(- count)
  end

  def self.delete_char(count)
    @@buffer.delete_char(count)
  end

  def self.unix_line_discard(count)
    @@buffer.delete_char(- @@buffer.point)
  end

  def self.kill_line(count)
    @@buffer.delete_char(@@buffer.size - @@buffer.point)
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

end
