# -*- coding: utf-8 -*-

class WString < String
  def width(from = 0, to = size) # XXX: workaround
    count = 0
    i = from
    while i < to
      count += (self[i].ascii_only? ? 1 : 2)
      i += 1
    end
    count
  end
end
