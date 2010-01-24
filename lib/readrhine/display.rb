# -*- coding: utf-8 -*-

module ReadRhine

  class Display
    TERM_CUB = "\e[%dD"         # cursor back n
    TERM_CUB1 = "\b"            # cursor back 1
    TERM_CUF = "\e[%dC"         # cursor forward n
    TERM_CUF1 = "\e[C"          # cursor forward 1
    TERM_CUU = "\e[%dA"         # cursor up n
    TERM_CUU1 = "\e[A"          # cursor up 1
    TERM_CUD = "\e[%dB"         # cursor down n
    TERM_EL = "\e[K"            # clear to end-of-line
    TERM_EL1 = "\e[1K"          # clear to begenning-of-line
    TERM_SC = "\e7"             # save cursor position
    TERM_RC = "\e8"             # restore cursor position

    def initialize(buffer, tty, prompt = '')
      @buffer = buffer
      @tty = tty
      @line = WString.new('')

      sync_screen_size
      Signal.trap(:WINCH) { sync_screen_size }

      @tty.print prompt if prompt
      @prompt = WString.new(prompt)
      @prompt_width = @prompt.width
      @col = @prompt_width
    end

    def redisplay
      buf_str = @buffer.to_s
      w = buf_str.width
      point_col = buf_str.width(0, @buffer.point) + @prompt_width

      if buf_str == @line
        cursor_move(@col, point_col)
      else
        off = w.times do |i|
          break i if buf_str[i] != @line[i]
        end

        cursor_move(@col, buf_str.width(0, off) + @prompt_width)
        @tty.print(off == 0 ? buf_str : buf_str[off .. -1])
        erase_eol(w + @prompt_width)
        cursor_move(w + @prompt_width, point_col)

        @line = buf_str.dup
      end

      @col = point_col
    end

    private

    def cursor_move(from, to)
      m = calculate_move(from, to)
      if m[:rows] < 0
        cursor_up(- m[:rows])
      elsif m[:rows] > 0
        cursor_down(m[:rows])
      end
      if m[:cols] < 0
        cursor_left(- m[:cols])
      elsif m[:cols] > 0
        cursor_right(m[:cols])
      end
    end

    def cursor_left(n)
      s = TERM_CUB % n
      @tty.print(n < s.bytesize * TERM_CUB1.bytesize ? TERM_CUB1 * n : s)
    end

    def cursor_right(n)
      @tty.print(n == 1 ? TERM_CUF1 : (TERM_CUF % n))
    end

    def cursor_up(n)
      @tty.print(n == 1 ? TERM_CUU1 : (TERM_CUU % n))
    end

    def cursor_down(n)
      @tty.print(TERM_CUD % n)
    end

    def calculate_move(from, to)
      { rows: to / @screen_cols - from / @screen_cols,
        cols: to % @screen_cols - from % @screen_cols }
    end

    def erase_eol(col)
      lw = @line.width + @prompt_width
      if col < lw
        @tty.print TERM_EL
        m = calculate_move(col, lw)
        if m[:rows] > 0
          m[:rows].times do
            cursor_down 1
            @tty.print TERM_EL1, TERM_EL
          end
          cursor_up m[:rows]
        end
      end
    end

    def sync_screen_size
      sz = @tty.screen_size
      @screen_cols = sz[:cols]
      @screen_rows = sz[:rows]
    end

  end
end
