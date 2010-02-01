require File.dirname(__FILE__) + '/../lib/readrhine'

describe ReadRhine::Completion, "when no completion" do
  before do
    @buffer = ReadRhine::Buffer.new
    @completion = ReadRhine::Completion.new(@buffer)
  end

  it "should raiase exception" do
    ->{@completion.completion_list('')}.
      should raise_error(ReadRhine::NoCompletion)
  end
end

describe ReadRhine::Completion, "when given completion_proc" do
  before do
    @list1 = %w[foobar foobaz foohoge]
    @buffer = ReadRhine::Buffer.new
    @completion = ReadRhine::Completion.new(@buffer)
    @completion.completion_proc = ->(_){@list1}
  end

  it "should get list" do
    @completion.completion_list('').should == @list1
  end

  it "should get common string" do
    @completion.attempted_completion('').should == 'foo'
  end

  it "should iterate" do
    @completion.menu_completion('').should == @list1[0]
    @list1[1..-1].each do |e|
      @completion.menu_completion('', true).should == e
    end
    @completion.menu_completion('', true).should == @list1[0]
  end
end

describe ReadRhine::Completion, "when given text in buffer" do
  before do
    @buffer = ReadRhine::Buffer.new('foo bar baz')
    @buffer.point = 'foo bar'.size
    @completion = ReadRhine::Completion.new(@buffer)
  end

  it "should get completing word" do
    @completion.completing_word.should == 'bar'
  end
end
