require File.dirname(__FILE__) + '/../lib/readrhine'

describe ReadRhine::Undo, "when empty" do
  before do
    @buffer = ReadRhine::Buffer.new
    @undo = ReadRhine::Undo.new(@buffer)
  end

  it "should raiase exception when undone" do
    ->{@undo.undo}.should raise_error(ReadRhine::NoMoreUndo)
  end
end

describe ReadRhine::Undo, "when edited" do
  before do
    @buffer = ReadRhine::Buffer.new
    @undo = ReadRhine::Undo.new(@buffer)

    # insert text
    @text1 = 'abcdefg'
    @undo.add(ReadRhine::Undo::INSERT, @buffer.point, @text1.size, nil)
    @buffer.insert(@text1)

    # delete end of text
    @delete1 = -2
    deleted = @buffer.delete_char(@delete1)
    @undo.add(ReadRhine::Undo::DELETE, @buffer.point, nil, deleted)

    # delete top of text
    @delete2 = 2
    @buffer.point = 0
    deleted = @buffer.delete_char(@delete2)
    @undo.add(ReadRhine::Undo::DELETE, @buffer.point, nil, deleted)
  end

  it "should undone" do
    @buffer.to_s.should == (@text1[0...@delete1])[@delete2..-1]

    @undo.undo
    @buffer.to_s.should == @text1[0...@delete1]

    @undo.undo
    @buffer.to_s.should == @text1

    @undo.undo
    @buffer.to_s.should == ''
  end
end
