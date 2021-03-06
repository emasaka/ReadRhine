# -*- coding: utf-8 -*-

class ReadRhine
  class Buffer
    def initialize(str = '')
      @buffer = WString.new(str)
      end_of_buffer
    end

    attr_accessor :point

    def to_s
      @buffer
    end

    def clear
      @buffer.clear
      end_of_buffer
    end

    def replace(str, from = 0, to = -1)
      @buffer[from..to] = str
      if to == -1
        end_of_buffer
      else
        @point = from + str.size
      end
    end

    def size
      @buffer.size
    end

    def empty?
      @buffer.empty?
    end

    def insert(str)
      @buffer[@point, 0] = str
      @point += str.size
    end

    def delete_char(n)
      deleted = nil
      if n > 0
        # delete forward
        n = size - point if size - point < n
        if n > 0
          deleted = @buffer[@point, n]
          @buffer[@point, n] = ''
        end
      else
        # delete backward
        if @point > 0
          st = @point + n
          st = 0 if st < 0
          if st < @point
            deleted = @buffer[st ... @point]
            @buffer[st ... @point] = ''
            @point = st
          end
        end
      end
      deleted
    end

    def end_of_buffer?
      @point == @buffer.size
    end

    def end_of_buffer
      @point = @buffer.size
    end

  end
end
