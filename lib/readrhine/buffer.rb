# -*- coding: utf-8 -*-

module ReadRhine
  class Buffer
    def initialize(str = '')
      @buffer = WString.new(str)
      @point = @buffer.size
    end

    attr_accessor :point

    def to_s
      @buffer
    end

    def size
      @buffer.size
    end

    def insert(str)
      @buffer[@point, 0] = str
      @point += str.size
    end

    def delete_char(n)
      if n > 0
        # delete forward
        n = size - point if size - point < n
        @buffer[@point, n] = '' if n > 0
      else
        # delete backward
        if @point > 0
          st = @point + n
          st = 0 if st < 0
          @buffer[st .. @point - 1] = ''
          @point = st
        end
      end
    end

  end
end
