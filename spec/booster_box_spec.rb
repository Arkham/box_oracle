require 'booster_box'

describe BoosterBox do
  let(:count) { 9 }
  let(:box) { BoosterBox.new(count) }

  it "should contain some boosters" do
    box.boosters.should have(count).items
  end

  context ".row" do
    it "returns the booster row" do
      box.row(0).map(&:id).should  == [ 1, 2, 3 ]
      box.row(2).map(&:id).should  == [ 7, 8, 9 ]
    end
  end

  context ".match?" do
    before do
      box.codes = box_codes
      box.code_sequence = sequence
    end

    context "full mapped box" do
      let(:sequence) do %w( A B D A D A ) end
      let(:box_codes) do %w( A A B D A D A A B ) end

      it "tells if booster matches sequence" do
        box.match!.should == [5]
      end
    end

    context "partial mapped box" do
      let(:sequence) do %w( A B D A D A C ) end
      let(:box_codes) do [ "D", "A", nil, "A" ] end

      it "tells if booster matches sequence" do
        box.match!.should == [ 2, 4 ]
      end

      context ".mappings" do
        it "should list the possible mappings" do
          box.mappings.should == [
            %w( D A D A C A B D A ),
            %w( D A C A B D A D A )
          ]
        end
      end
    end
  end

  context ".shift!" do
    it "removes a row and inserts it in another location" do
      shifted = box.shift(0, 1)
      shifted.row(0).map(&:id).should == [ 4, 5, 6 ]
      shifted.row(1).map(&:id).should == [ 1, 2, 3 ]
      shifted.row(2).map(&:id).should == [ 7, 8, 9 ]
    end
  end

  context ".shift_all" do
    it "finds all permutation by shifting a single row" do
      result = []
      box.shift_all do |shifted|
        result << shifted.boosters
      end

      result.should have(4).items
    end
  end

end
