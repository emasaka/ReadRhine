# -*- coding: utf-8 -*-

require 'termios'

module ReadRhine
  class TTY
    def start
      @orig_state = Termios.tcgetattr(STDIN)
      @state = @orig_state.dup
      @state.lflag &= ~Termios::ECHO & ~Termios::ICANON & Termios::ISIG
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
