# -*- coding: utf-8 -*-

module ReadRhine
  def self.readline(prompt = '', options = {})
    setup(prompt, options)
    begin
      charloop
    ensure
      finalize
    end
    @@buffer.to_s
  end

  def self.keymap
    @@keymap
  end

  # private methods

  def self.setup(prompt, options)
    @@buffer = ReadRhine::Buffer.new(options[:preput] || '')
    @@tty = ReadRhine::TTY.new
    @@display = ReadRhine::Display.new(@@buffer, @@tty, prompt)
    @@last_command_char = nil
    @@last_command = nil
  end

  def self.finalize
    if @@buffer.point != @@buffer.size
      @@buffer.point = @@buffer.size
      @@display.redisplay
    end
    print "\n"

    @@tty.finalize
  end

  def self.charloop
    while true
      seq = read_key_seq(@@keymap)
      if seq == "\n"
        break
      end
      @@last_command_char = seq
      dispatch(seq, @@keymap)
      @@display.redisplay
    end
  end

  def self.dispatch(key, keymap)
    begin
      cmd = keymap[key]
      __send__(cmd, 1, key)
      @@last_command = cmd
    rescue CommandNotFound => e
      # TODO: some notification
    end
  end

  def self.read_key_seq(keymap)
    seq = ''
    while true
      k = @@tty.read_key
      seq << k
      Keymap === keymap.lookup_keyseq(seq) or return seq
    end
  end

  private_class_method :setup, :finalize, :charloop, :dispatch, :read_key_seq

end
