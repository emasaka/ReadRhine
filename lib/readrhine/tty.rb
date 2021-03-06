# -*- coding: utf-8 -*-

require 'termios'
require 'singleton'

class ReadRhine
  class TTY
    include Singleton

    def initialize
      @orig_state = Termios.tcgetattr(STDIN)
      @state = @orig_state.dup
    end

    def start
      @state.lflag &=
        ~Termios::ECHO & ~Termios::ICANON & Termios::ISIG & ~Termios::INLCR
      Termios.tcsetattr(STDIN, Termios::TCSANOW, @state)
    end

    def finish
      Termios.tcsetattr(STDIN, Termios::TCSANOW, @orig_state)
    end

    def read_key
      STDIN.getc
    end

    def print(*args)
      STDOUT.print *args
    end

    def stdout
      STDOUT
    end

    def eof_char
      @state.cc[Termios::VEOF].chr
    end

  end
end
