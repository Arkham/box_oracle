require 'booster_box'

describe BoosterBox do
  let(:count) { 9 }
  let(:box) { BoosterBox.new(count) }

  it "should contain some boosters" do
    box.boosters.should have(count).items
  end

  context ".row" do
    it "returns the booster row" do
      box.row(1).map(&:id).should  == [ 1, 2, 3 ]
      box.row(3).map(&:id).should  == [ 7, 8, 9 ]
    end
  end

  context ".match?" do
    let(:sequence) do %w( A B D A D A ) end

    before do
      box.codes = box_codes
      box.code_sequence = sequence
    end

    context "full mapped box" do
      let(:box_codes) do %w( A A B D A D A A B) end

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
    end
  end
end
