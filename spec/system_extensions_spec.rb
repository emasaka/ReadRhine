# -*- coding: utf-8 -*-

require File.dirname(__FILE__) + '/../lib/readrhine'

describe ReadRhine::WString, "when created" do
  it "should width of 'abc'" do
    ReadRhine::WString.new('abc').width.should == 3
  end

  it "should width of 'abcあいう'" do
    ReadRhine::WString.new('abcあいう').width.should == 9
  end
end
