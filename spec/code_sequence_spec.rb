require 'code_sequence'

describe CodeSequence do
  let(:sequence) { CodeSequence.new(%w[A B D A D]) }

  context ".scan" do
    it "should find element indexes" do
      sequence.scan("A").should == [0, 3]
      sequence.scan("B").should == [1]
      sequence.scan("C").should == nil
    end

    context "arrays" do
      it "should find subsequence indexes" do
        sequence.scan(%w[A B D]).should == [0]
        sequence.scan(%w[B D A]).should == [1]
        sequence.scan(%w[B D C]).should == nil
        sequence.scan(%w[C F U]).should == nil
      end

      context "sequences wrapping around" do
        it "should still find indexes" do
          sequence.scan(%w[A D A]).should == [3]
          sequence.scan(%w[D A]).should == [2, 4]
        end
      end
    end
  end

end
