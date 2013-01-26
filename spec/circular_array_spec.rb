require 'circular_array'

describe CircularArray do
  let (:array) { CircularArray.new([1, 2, 3]) }

  it "should behave like a normal array" do
    array.first.should == 1
  end

  context "access elements circularly" do
    it "should access elements on the right" do
      array[3].should == 1
      array[7].should == 2
    end

    it "should access elements on the left" do
      array[-4].should == 3
      array[-9].should == 1
    end
  end

  context "ranges" do
    it "should slice array" do
      array[1..4].should == [2, 3, 1, 2]
      array[-4..-1].should == [3, 1, 2, 3]
    end
  end
end
