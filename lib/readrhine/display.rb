# -*- coding: utf-8 -*-

require 'terminfo'

module ReadRhine

  class Display
    def initialize(buffer, tty, prompt = '')
      @buffer = buffer
      @tty = tty
      @line = WString.new('')

      @terminfo = TermInfo.new(ENV['TERM'], @tty.stdout)
      sync_screen_size
      Signal.trap(:WINCH) { sync_screen_size }

      @prompt = WString.new(prompt)
      @prompt_width = @prompt.width
      @col = @prompt_width

      @tty.print prompt if prompt
      redisplay if buffer.size > 0
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

    Movement = Struct.new('Movement', :rows, :cols)

    def cursor_move(from, to)
      m = calculate_move(from, to)
      if m.rows < 0
        cursor_up(- m.rows)
      elsif m.rows > 0
        cursor_down(m.rows)
      end
      if m.cols < 0
        cursor_left(- m.cols)
      elsif m.cols > 0
        cursor_right(m.cols)
      end
    end

    def cursor_left(n)
      s = @terminfo.tputs(@terminfo.tparm(@terminfo.tigetstr('cub'), n), 1)
      s1 = @terminfo.tputs(@terminfo.tigetstr('cub1'), 1)
      @tty.print(s.bytesize < s1.bytesize * n ? s : s1 * n)
    end

    def cursor_right(n)
      @tty.print(n == 1 ? 
                 @terminfo.tputs(@terminfo.tigetstr('cuf1'), 1) :
                 @terminfo.tputs(@terminfo.tparm(@terminfo.tigetstr('cuf'),
                                                 n ), 1))
    end

    def cursor_up(n)
      @tty.print(n == 1 ? 
                 @terminfo.tputs(@terminfo.tigetstr('cuu1'), 1) :
                 @terminfo.tputs(@terminfo.tparm(@terminfo.tigetstr('cuu'),
                                                 n ), 1))
    end

    def cursor_down(n)
      @tty.print(@terminfo.tputs(@terminfo.tparm(@terminfo.tigetstr('cud'),
                                                 n ), 1))
    end

    def calculate_move(from, to)
      Movement.new(to / @screen_cols - from / @screen_cols,  # rows
                   to % @screen_cols - from % @screen_cols ) # cols
    end

    def erase_eol(col)
      lw = @line.width + @prompt_width
      if col < lw
        el = @terminfo.tputs(@terminfo.tigetstr('el'), 1)
        @tty.print el
        m = calculate_move(col, lw)
        if m.rows > 0
          el1 = @terminfo.tputs(@terminfo.tigetstr('el1'), 1)
          m.rows.times do
            cursor_down 1
            @tty.print el1, el
          end
          cursor_up m.rows
        end
      end
    end

    def sync_screen_size
      @screen_rows, @screen_cols = TermInfo.tiocgwinsz(@tty.stdout)
    end

  end
end
