# -*- coding: utf-8 -*-

require 'shellwords'

class ReadRhine
  class NoCompletion < StandardError; end

  class Completion
    def initialize(buffer)
      @buffer = buffer
      @completion_proc = ->(_){[]}
      @case_fold = false
      @enum = nil
    end

    attr_accessor :completion_proc, :case_fold

    def completing_word         # XXX: workaround
      @buffer.to_s[0 .. @buffer.point].shellsplit[-1]
    end

    def attempted_completion(text)
      list = @completion_proc.call(text)
      raise NoCompletion if list.empty?
      max_common_str list
    end

    def menu_completion(text, getnext = false)
      @enum = menu_completion_enum(text) unless getnext && @enum
      begin
        @enum.next
      rescue StopIteration
        @enum.rewind
        retry
      end
    end

    private

    def max_common_str(list)
      list.reduce do |r, e|
        sz = if @case_fold
               r.size.times {|i| break i if r[i].casecmp(e[i]) != 0 }
             else
               r.size.times {|i| break i if r[i] != e[i] }
             end
        r[0, sz]
      end
    end

    def menu_completion_enum(text)
      list = @completion_proc.call(text)
      raise NoCompletion if list.empty?
      list.to_enum
    end

  end
end
