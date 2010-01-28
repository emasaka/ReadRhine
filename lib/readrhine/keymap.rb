# -*- coding: utf-8 -*-

module ReadRhine
  class CommandNotFound < StandardError; end

  class Keymap
    LookupData = Struct.new('LookupData', :table, :key)

    def initialize
      @keymap = {}
    end

    def [](key)
      r = lookup_key_hash(key)
      if r.key.size == 1
        f = r.table[r.key]
        if f
          f
        elsif key.size == 1
          :insert_char
        else
          raise CommandNotFound, key
        end
      else                      # just to be sure
        raise CommandNotFound, key
      end
    end

    def []=(key, fun)
      r = lookup_key_hash(key)
      if r.key.size == 1
        r.table[r.key] = fun
      else
        e = r.table[r.key[0]]
        unless Keymap === e
          e = Keymap.new
          r.table[r.key[0]] = e
        end
        e[key[1..-1]] = fun
      end
    end

    def lookup_keyseq(key)
      r = lookup_key_hash(key)
      r.table[r.key[0]]
    end

    def dup
      duped = super
      map = @keymap.dup
      duped.keymap = map
      map.each_key do |key|
        e = map[key]
        map[key] = e.dup if Keymap === e
      end
      duped
    end

    protected

    attr_writer :keymap         # to dup

    def lookup_key_hash(key)
      if key.size == 1
        LookupData.new(@keymap, key)
      else
        v = @keymap[key[0]]
        if Keymap === v
          v.lookup_key_hash(key[1..-1])
        else
          LookupData.new(@keymap, key)
        end
      end
    end

  end
end
