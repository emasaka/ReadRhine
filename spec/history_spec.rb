require File.dirname(__FILE__) + '/../lib/readrhine'

describe ReadRhine::History, "when empty" do
  before do
    @history = ReadRhine::History.new
  end

  it "should not go to previous line" do
    @history.previous('', 1).should == nil
  end

  it "should not go to next line" do
    @history.previous('', -1).should == nil
  end
end

describe ReadRhine::History, "when line is added" do
  before do
    @history = ReadRhine::History.new
    @line = 'abc'
    @history.add(@line)
  end

  it "should get history line" do
    bufstr = 'xyz'
    modified_line = 'ABC'

    # go back history
    @history.previous(bufstr, 1).should == @line
    # fast forward history with modifying line
    @history.previous(modified_line, -1).should == bufstr
    # go back again
    @history.previous(bufstr, 1).should == modified_line
  end
end
