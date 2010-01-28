# -*- coding: utf-8 -*-

class WString < String
  def width(from = 0, to = size) # XXX: workaround
    count = 0
    i = from
    while i < to
      c = self[i]
      count += (c.ascii_only? && c.ord >= 0x20 ? 1 : 2)
      i += 1
    end
    count
  end
end
