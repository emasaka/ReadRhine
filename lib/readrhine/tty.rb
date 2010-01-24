# -*- coding: utf-8 -*-

module ReadRhine
  class TTY
    def initialize
      @state = `stty -g`
      system 'stty -echo -icanon isig'
    end

    def finalize
      system "stty #{@state}"
    end

    def read_key
      STDIN.getc
    end

    def print(*args)
      STDOUT.print *args
    end

    def screen_size
      r = {}
      r[:rows], r[:cols] = `stty size`.split.map {|e| e.to_i}
      r
    end

  end
end
