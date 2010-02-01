require File.dirname(__FILE__) + '/../lib/readrhine'

describe ReadRhine::Keymap, "when created" do
  before do
    @keymap = ReadRhine::Keymap.new
  end

  it "should no function" do
    @keymap.lookup_keyseq("\C-h").should == nil
    @keymap["\C-h"].should == :insert
  end

  it "should binded to single key" do
    @keymap["\C-h"] = :backward_delete_char

    @keymap["\C-h"].should == :backward_delete_char
    @keymap.lookup_keyseq("\C-h").should == :backward_delete_char
  end

  it "should binded to combination key" do
    @keymap["\e[D"] = :backward_char
    @keymap["\e[C"] = :forward_char

    @keymap["\e[D"].should == :backward_char
    @keymap["\e[C"].should == :forward_char
  end

  it "should binded to multiple combination key" do
    @keymap["\e[D"] = :backward_char
    @keymap["\eOH"] = :beginning_of_line

    @keymap["\e[D"].should == :backward_char
    @keymap["\eOH"].should == :beginning_of_line
  end
end
