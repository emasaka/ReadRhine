# -*- coding: utf-8 -*-

class ReadRhine
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
end

module Signal
  @@handlers = {}

  class << self
    alias :trap_orig :trap

    def trap(signal, cmd = nil, &blk)
      signal = signal.to_sym if String === signal
      proc =
        if blk
          blk
        elsif ['SYSTEM_DEFAULT', :SYSTEM_DEFAULT,
               'SIG_IGN', :SIG_IGN, 'SIG_DFL', :SIG_DFL,
               'DEFAULT', :DEFAULT, 'IGNORE', :IGNORE,
               'EXIT', :EXIT, '', nil ].member?(cmd)
          @@handlers.delete(signal)
          return trap_orig(signal, cmd)
          'Not reached'
        else
          ->{ eval cmd }
        end

      if @@handlers[signal]
        @@handlers[signal] << proc
      else
        @@handlers[signal] = [ proc ]
        trap_orig(signal) { @@handlers[signal].each {|h| h.call } }
      end
      nil
    end
  end
end
