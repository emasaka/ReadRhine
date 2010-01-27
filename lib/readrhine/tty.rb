# -*- coding: utf-8 -*-

require 'termios'

module ReadRhine
  class TTY
    def initialize(buffer)
      @buffer = buffer
      @state = Termios.tcgetattr(STDIN)
      @eof_char = @state.cc[Termios::VEOF].chr
      newstate = @state.dup
      newstate.lflag &= ~Termios::ECHO & ~Termios::ICANON & Termios::ISIG
      Termios.tcsetattr(STDIN, Termios::TCSANOW, newstate)
    end

    def finalize
      Termios.tcsetattr(STDIN, Termios::TCSANOW, @state)
    end

    def read_key
      c = STDIN.getc
      raise EOFError if c == @eof_char && @buffer.empty?
      c
    end

    def print(*args)
      STDOUT.print *args
    end

    def stdout
      STDOUT
    end

  end
end
