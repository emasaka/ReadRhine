# -*- coding: utf-8 -*-

require 'singleton'

module ReadRhine
  def self.readline(prompt = '', history = false, options = {})
    options[:prompt] = prompt
    options[:history] = history
    ReadRhine.new(options).readline
  end

  class ReadRhine
    DONE = :done

    def initialize(options = {})
      @buffer = Buffer.new(options[:preput] || '')
      @tty = TTY.instance
      @display = Display.new(self, options[:prompt] || '')
      @undo = Undo.new
      @command = Command.new(self)
      @keymap = @@default_keymap
      @last_command = nil
    end

    def readline
      start
      begin
        charloop
      ensure
        finish
      end
      @buffer.to_s
    end

    attr_reader :buffer, :undo, :tty
    attr_accessor :keymap

    private

    def start
      @tty.start
      @eof_char = @tty.eof_char
    end

    def finish
      if @buffer.point != @buffer.size
        @buffer.point = @buffer.size
        @display.redisplay
      end
      print "\n"

      @tty.finish
    end

    def charloop
      catch(ReadRhine::DONE) do
        while true
          seq = read_key_seq(@keymap)
          dispatch(seq, @keymap)
          @display.redisplay
        end
      end
    end

    def dispatch(key, keymap)
      begin
        cmd = keymap[key]
        @command.__send__(cmd, 1, key)
        @last_command = cmd
      rescue CommandNotFound => e
        # TODO: some notification
      end
    end

    def read_key_seq(keymap)
      seq = ''
      while true
        k = @tty.read_key
        raise EOFError if k == @eof_char && @buffer.empty?
        seq << k
        Keymap === keymap.lookup_keyseq(seq) or return seq
      end
    end

  end
end
