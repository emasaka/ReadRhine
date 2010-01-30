# -*- coding: utf-8 -*-

require 'terminfo'

module ReadRhine
  class Display
    def initialize(rl, prompt = '')
      @buffer = rl.buffer
      @tty = rl.tty
      @line = WString.new('')

      @terminfo = TermInfo.new(ENV['TERM'], @tty.stdout)
      sync_screen_size
      Signal.trap(:WINCH) { redisplay_after_sigwinch }
      @term_str_cache = {}

      @prompt = WString.new(prompt)
      @prompt_width = @prompt.width
      @col = @prompt_width

      printq @prompt unless @prompt.empty?
      redisplay unless @buffer.empty?
    end

    def redisplay
      buf_str = @buffer.to_s
      w = buf_str.width
      point_col = buf_str.width(0, @buffer.point) + @prompt_width

      if buf_str == @line
        cursor_move(@col, point_col)
      else
        off = buf_str.size.times do |i|
          break i if buf_str[i] != @line[i]
        end
        dif_col = buf_str.width(0, off) + @prompt_width
        buf_end_col = w + @prompt_width
        cursor_move(@col, dif_col)

        if off == buf_str.size  # deleted end of line
          erase_eol(dif_col)
          cursor_move(dif_col, point_col)
        else
          b_str = (off == 0 ? buf_str : buf_str[off .. -1])
          if off == @line.size  # inserted to end of line
            printq b_str
            cursor_move(buf_end_col, point_col)
          else
            d_str = (off == 0 ? @line : @line[off .. -1])
            d_str_w = d_str.width
            if b_str.end_with?(d_str) && # inserted
                calculate_move(dif_col, buf_end_col).rows == 0
              ins_str = b_str[0, b_str.size - d_str.size]
              ins_w = ins_str.width
              insert_char(ins_w)
              printq ins_str
              cursor_move(dif_col + ins_w, point_col)
            elsif d_str.end_with?(b_str) && # deleted
                calculate_move(dif_col, d_str_w).rows == 0
              delete_char(d_str_w - b_str.width)
              cursor_move(dif_col, point_col)
            else
              printq b_str
              erase_eol buf_end_col
              cursor_move(buf_end_col, point_col)
            end
          end
        end

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
      s = term_str('cub', n)
      s1 = term_str('cub1')
      @tty.print(s.bytesize < s1.bytesize * n ? s : s1 * n)
    end

    def cursor_right(n)
      @tty.print(n == 1 ? term_str('cuf1') : term_str('cuf', n))
    end

    def cursor_up(n)
      @tty.print(n == 1 ? term_str('cuu1') : term_str('cuu', n))
    end

    def cursor_down(n)
      @tty.print term_str('cud', n)
    end

    def delete_char(n)
      @tty.print(n == 1 ? term_str('dch1') : term_str('dch', n))
    end

    def insert_char(n)
      @tty.print term_str('ich', n)
    end

    def calculate_move(from, to)
      Movement.new(to / @screen_cols - from / @screen_cols,  # rows
                   to % @screen_cols - from % @screen_cols ) # cols
    end

    def erase_eol(col)
      lw = @line.width + @prompt_width
      if col < lw
        el = term_str('el')
        @tty.print el
        m = calculate_move(col, lw)
        if m.rows > 0
          el1 = term_str('el1')
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

    def redisplay_after_sigwinch
      cursor_move(@col, 0)
      erase_eol 0

      sync_screen_size

      printq @prompt unless @prompt.empty?
      printq @buffer.to_s
      cursor_move(@buffer.to_s.width + @prompt_width, @col)
    end

    def term_str(name, param = nil)
      t_str = (@term_str_cache[name] ||= @terminfo.tigetstr(name))
      @terminfo.tputs (param ? @terminfo.tparm(t_str, param) : t_str), 1
    end

    def printq(str)
      @tty.print str.gsub(/[\x00-\x1f]/) {|c| '^' + (c.ord + 0x40).chr }
    end

  end
end
