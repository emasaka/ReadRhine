# -*- coding: utf-8 -*-

class ReadRhine
  DONE = :done

  def initialize(options = {})
    @buffer = Buffer.new(options[:preput] || '')
    @tty = TTY.instance
    @display = Display.new(self, options[:prompt] || '')
    @undo = Undo.new(buffer)
    @command = Command.new(self)
    @keymap = @@default_keymap.dup
    @history = History.new if options[:history]
    @completion = Completion.new(@buffer)
    @last_command = nil
  end

  def readline
    start
    begin
      charloop
    ensure
      finish
    end
    str = @buffer.to_s.dup
    @history.reset_state.add(str) if @history
    str
  end

  attr_reader :buffer, :undo, :tty, :completion, :last_command
  attr_accessor :keymap, :history

  attr_reader :last_command

  private

  def start
    @buffer.clear
    @display.start
    @tty.start
    @eof_char = @tty.eof_char
  end

  def finish
    if @buffer.end_of_buffer?
      @buffer.end_of_buffer
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
      seq << k
      raise EOFError if seq == @eof_char && @buffer.empty?
      Keymap === keymap.lookup_keyseq(seq) or return seq
    end
  end

end
