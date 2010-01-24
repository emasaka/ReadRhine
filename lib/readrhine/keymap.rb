# -*- coding: utf-8 -*-

module ReadRhine
  class Keymap
    def initialize
      @keymap = {}
    end

    def [](key)
      r = lookup_key_hash(key)
      if r[:key].size == 1
        r[:hash][r[:key]] or :insert_char
      else                      # just to be sure
        raise "#{key.inspect} not found"
      end
    end

    def []=(key, fun)
      r = lookup_key_hash(key)
      if r[:key].size == 1
        r[:hash][r[:key]] = fun
      else
        e = r[:hash][r[:key][0]]
        unless Keymap === e
          e = Keymap.new
          r[:hash][r[:key][0]] = e
        end
        e[key[1..-1]] = fun
      end
    end

    def lookup_keyseq(key)
      r = lookup_key_hash(key)
      r[:hash][r[:key][0]]
    end

    protected

    def lookup_key_hash(key)
      if key.size == 1
        { hash: @keymap, key: key }
      else
        v = @keymap[key[0]]
        if Keymap === v
          v.lookup_key_hash(key[1..-1])
        else
          { hash: @keymap, key: key }
        end
      end
    end
  end

end
