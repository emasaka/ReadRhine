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

    def replace(str)
      @buffer[0..-1] = str
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

  end
end
