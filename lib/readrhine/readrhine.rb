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
    @@tty.finalize
  end

  def self.charloop
    while true
      seq = read_key_seq(@@keymap)
      if seq == "\n"
        print "\n"
        break
      end
      @@last_command_char = seq
      dispatch(seq, @@keymap)
      @@display.redisplay
    end
  end

  def self.dispatch(key, keymap)
    cmd = keymap[key]
    __send__(cmd, 1)
    @@last_command = cmd
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
