require 'booster_box'

describe BoosterBox do
  let(:count) { 9 }
  let(:box) { BoosterBox.new(count) }

  it "should contain some boosters" do
    box.boosters.should have(count).items
  end

  context ".row" do
    it "returns the booster row" do
      box.row(0).ids.should  == [ 1, 2, 3 ]
      box.row(2).ids.should  == [ 7, 8, 9 ]
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
        box.matches?.should == [5]
      end
    end

    context "partial mapped box" do
      let(:sequence) do %w( A B D A D A C ) end
      let(:box_codes) do [ "D", "A", nil, "A" ] end

      it "tells if booster matches sequence" do
        box.matches?.should == [ 2, 4 ]
      end

      context ".mappings" do
        let(:mappings) { box.mappings }

        it "should return box mappings" do
          mappings.should have(2).items
          mappings.first.should be_a BoxMapping
        end

        it "should list the possible mappings" do
          mappings[0].codes.map(&:key).should == %w( D A D A C A B D A )
          mappings[1].codes.map(&:key).should == %w( D A C A B D A D A )
        end

        it "should return the associated boosters" do
          mappings.first.boosters.map(&:id).should == (1..9).to_a
        end
      end
    end
  end

  context ".shift!" do
    it "removes a row and inserts it in another location" do
      shifted = box.shift(0, 1)
      shifted.row(0).ids.should == [ 4, 5, 6 ]
      shifted.row(1).ids.should == [ 1, 2, 3 ]
      shifted.row(2).ids.should == [ 7, 8, 9 ]
    end
  end

  context ".shift_all" do
    it "finds all permutation by shifting a single row" do
      result = []
      box.shift_all do |shifted|
        # for sake of testing, extract only the first column ids
        result << shifted.by_row.map(&:first).map(&:id)
      end

      result.should have(4).items

      result.should include([4,1,7])
      result.should include([4,7,1])
      result.should include([7,1,4])
      result.should include([1,7,4])
    end
  end

  context ".solutions" do

    let(:sequence) do %w( A B D A C ) end
    let(:box_codes) do %w( A C A A B D B D A ) end
    let(:solutions) { box.solutions }

    before do
      box.codes = box_codes
      box.code_sequence = sequence
    end

    it "should return box mappings" do
      solutions.first.should be_a BoxMapping
    end

    it "finds possible solutions including shifts" do
      solutions.first.keys.should == %w( A B D A C A B D A )
      solutions.first.ids.should == [ 4, 5, 6, 1, 2, 3, 7, 8, 9 ]
    end

    context "partial mapped box" do
      let(:sequence) do %w( A B D A D ) end
      let(:box_codes) do ["A", nil, nil, "D", "A", "D", nil, nil, nil] end

      it "finds possible solutions including shifts" do
        solutions.first.keys.should == %w( D A D A B D A D A )
        solutions.first.ids.should == [ 4, 5, 6, 1, 2, 3, 7, 8, 9 ]
      end
    end

    context "unsolvable box" do
      let(:sequence) do %w( A B D A C ) end
      let(:box_codes) do ["A", nil, nil, "C", "A", "A", nil, nil, nil] end

      it "finds no solutions" do
        solutions.should be_nil
      end

    end
  end

end
