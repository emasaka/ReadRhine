# -*- coding: utf-8 -*-

class ReadRhine
  class History
    DEFAULT_MAX_ENTRIES = 1000

    def initialize
      @history = []
      @max_entries = DEFAULT_MAX_ENTRIES
      reset_state
    end

    attr_accessor :max_entries

    def reset_state
      @modified_lines = {}
      @index = nil
      self
    end

    def add(line)
      @history << line
      n = @history.size - @max_entries
      @history.slice!(0, n) if n > 0
    end

    def previous(line, count)
      @index ||= @history.size
      maybe_save_line(line)
      if count != 0
        i = @index - count
        if 0 <= i && i <= @history.size
          @index = i
          ref_with_modified(@index)
        end
      end
    end

    private

    def maybe_save_line(line)
      if @modified_lines[@index] || @history[@index] != line
        @modified_lines[@index] = line.dup
      end
    end

    def ref_with_modified(n)
      @modified_lines[n] || @history[n]
    end

  end
end
