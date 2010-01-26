require File.dirname(__FILE__) + '/../lib/readrhine'

describe ReadRhine::Buffer, "when created" do
  before do
    @buffer = ReadRhine::Buffer.new
  end

  it "should size 0" do
    @buffer.size.should == 0
  end
end

describe ReadRhine::Buffer, "when created with initial string" do
  before do
    @initial_string = 'abc'
    @buffer = ReadRhine::Buffer.new(@initial_string)
  end

  it "should size of initial string" do
    @buffer.size.should == @initial_string.size
  end

  it "should contains initial string" do
    @buffer.to_s.should == @initial_string
  end
end

describe ReadRhine::Buffer, "editing" do
  before do
    @buffer = ReadRhine::Buffer.new
  end

  it "should contains inserted string" do
    ins_str = 'xyz'
    @buffer.insert(ins_str)
    @buffer.to_s.should == ins_str
  end

  it "should contains inserted string at end" do
    ins_str1 = 'xyz'
    ins_str2 = '123'
    @buffer.insert(ins_str1)
    @buffer.insert(ins_str2)

    @buffer.to_s.should == ins_str1 + ins_str2
  end

  it "should contains inserted string at top" do
    ins_str1 = 'xyz'
    ins_str2 = '123'
    @buffer.insert(ins_str1)
    @buffer.point = 0
    @buffer.insert(ins_str2)

    @buffer.to_s.should == ins_str2 + ins_str1
  end

  it "should delete characters at top" do
    ins_str = 'xyz'
    del_size = 2
    @buffer.insert(ins_str)
    @buffer.point = 0
    @buffer.delete_char(del_size)

    @buffer.to_s.should == ins_str[del_size..-1]
  end

  it "should delete characters at end" do
    ins_str = 'xyz'
    del_size = 2
    @buffer.insert(ins_str)
    @buffer.delete_char(- del_size)

    @buffer.to_s.should == ins_str[0 ... - del_size]
  end
end
