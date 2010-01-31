# -*- coding: utf-8 -*-

require 'readrhine'

class ReadRhine
  class << self
    @completion_proc = ->(_){[]}
    @completion_case_fold = false

    @global_history = nil

    def readline(prompt = '', history = false, options = {})
      rl = self.new(options.merge({prompt: prompt, history: history}))
      rl.history = (@global_history ||= History.new) if history
      rl.completion.case_fold = @completion_case_fold
      rl.completion.completion_proc = @completion_proc
      rl.readline
    end

    attr_accessor :completion_proc, :completion_case_fold

  end
end
