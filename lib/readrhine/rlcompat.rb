# -*- coding: utf-8 -*-

require 'readrhine'

class ReadRhine
  class << self
    @global_history = nil

    def readline(prompt = '', history = false, options = {})
      rl = self.new(options.merge({prompt: prompt, history: history}))
      rl.history = (@global_history ||= History.new) if history
      rl.readline
    end
  end
end
