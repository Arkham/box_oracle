require 'circular_array'

describe CircularArray do
  let (:array) { CircularArray.new }

  it "should behave like a normal array" do
    array.push 1337
    array.first.should == 1337
  end

  context "access elements circularly" do
    before do
      array.push 1, 2, 3
    end

    it "should access elements on the right" do
      array[3].should == 1
      array[7].should == 2
    end

    it "should access elements on the left" do
      array[-4].should == 3
      array[-9].should == 1
    end
  end
end
