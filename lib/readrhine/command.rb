# -*- coding: utf-8 -*-

module ReadRhine
  class Command
    def initialize(rl)
      @rl = rl
    end

    def insert_char(count, key)
      s = (count == 1 ? key : key * count)
      @rl.undo.add(Undo::INSERT, @rl.buffer.point, s.size, nil)
      @rl.buffer.insert(s)
    end

    def backward_delete_char(count, key)
      deleted = @rl.buffer.delete_char(- count)
      @rl.undo.add(Undo::DELETE, @rl.buffer.point, nil, deleted) if deleted
    end

    def delete_char(count, key)
      deleted = @rl.buffer.delete_char(count)
      @rl.undo.add(Undo::DELETE, @rl.buffer.point, nil, deleted) if deleted
    end

    def unix_line_discard(count, key)
      deleted = @rl.buffer.delete_char(- @rl.buffer.point)
      @rl.undo.add(Undo::DELETE, @rl.buffer.point, nil, deleted) if deleted
    end

    def kill_line(count, key)
      deleted = @rl.buffer.delete_char(@rl.buffer.size - @rl.buffer.point)
      @rl.undo.add(Undo::DELETE, @rl.buffer.point, nil, deleted) if deleted
    end

    def backward_char(count, key)
      @rl.buffer.point -= count
      @rl.buffer.point = 0 if @rl.buffer.point < 0
    end

    def forward_char(count, key)
      @rl.buffer.point += count
      @rl.buffer.point = @rl.buffer.size if @rl.buffer.point > @rl.buffer.size
    end

    def beginning_of_line(count, key)
      @rl.buffer.point = 0
    end

    def end_of_line(count, key)
      @rl.buffer.point = @rl.buffer.size
    end

    def undo(count, key)
      count.times do
        @rl.undo.undo(@rl.buffer)
      end
    end

    def done(count, key)
      throw ReadRhine::DONE
    end

  end
end
