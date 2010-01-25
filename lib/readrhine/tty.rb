# -*- coding: utf-8 -*-

require 'termios'

module ReadRhine
  class TTY
    def initialize
      @state = Termios.tcgetattr(STDIN)
      newstate = @state.dup
      newstate.lflag &= ~Termios::ECHO & ~Termios::ICANON & Termios::ISIG
      Termios.tcsetattr(STDIN, Termios::TCSANOW, newstate)
    end

    def finalize
      Termios.tcsetattr(STDIN, Termios::TCSANOW, @state)
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

  end
end
