# -*- coding: utf-8 -*-

class ReadRhine
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
      @rl.buffer.end_of_buffer if @rl.buffer.point > @rl.buffer.size
    end

    def beginning_of_line(count, key)
      @rl.buffer.point = 0
    end

    def end_of_line(count, key)
      @rl.buffer.end_of_buffer
    end

    def undo(count, key)
      count.times do
        @rl.undo.undo(@rl.buffer)
      end
    end

    def done(count, key)
      throw ReadRhine::DONE
    end

    def previous_history(count, key)
      if @rl.history
        s = @rl.history.previous(@rl.buffer.to_s, count)
        @rl.buffer.replace(s) if s
      end
    end

    def next_history(count, key)
      previous_history(- count, key)
    end

    def complete(count, key)
      do_complete(->(text){@rl.completion.attempted_completion(text)})
    end

    def menu_complete(count, key)
      getnext = (@rl.last_command == :menu_complete)
      do_complete(->(text){@rl.completion.menu_completion(text, getnext)})
    end

    private

    def do_complete(select_proc, *arg)
      text = @rl.completion.completing_word
      newtext = select_proc.call(text, *arg)
      if text != newtext
        @rl.undo.add(Undo::REPLACE, @rl.buffer.point, newtext.size, text)
        @rl.buffer.replace(newtext, @rl.buffer.point - text.size,
                           @rl.buffer.point )
      end
    rescue ReadRhine::NoCompletion
      # TODO: some notification
    end

  end
end
