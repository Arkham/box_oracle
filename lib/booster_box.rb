require 'code_sequence'

class BoosterBox
  attr_reader :code_sequence
  attr_accessor :boosters

  def initialize(count = 36)
    @boosters = count.times.map { |n| Booster.new(n + 1) }
  end

  def boosters_per_row
    3
  end

  def by_row
    result = []
    boosters.each_slice(boosters_per_row) do |slice|
      result << slice
    end
    result
  end

  def row(index)
    by_row[index]
  end

  def codes
    boosters.map(&:code)
  end

  def codes=(codes)
    codes.each_with_index do |code, index|
      boosters[index].code = code if code
    end
  end

  def code_sequence=(codes)
    @code_sequence = CodeSequence.new(
      codes.map { |c| BoosterCode.new(c) }
    )
  end

  def matches?(box_codes = codes)
    code_sequence.scan(box_codes)
  end

  def mappings
    matches = self.matches?
    return unless matches

    matches.map do |match|
      code_sequence.slice(match, boosters.length)
    end
  end

  def shift(index, insert_at)
    clone.tap do |copy|
      clone_by_row = copy.by_row
      original_row = clone_by_row.delete_at(index)
      clone_by_row.insert(insert_at, original_row)
      copy.boosters = clone_by_row.flatten
    end
  end

  def shift_all(&block)
    rows = by_row.length

    shifts = ( 0 ... rows ).to_a.  # find possible rows indexes ..
      permutation(2).to_a.         # extract all permutations of two elems ..
      reject do |index, insert_at| # remove couples (x+1, x) since the
        index == insert_at + 1     # same permutation is given by (x, x+1)
      end

    shifts.each do |index, insert_at|
      yield shift(index, insert_at)
    end
  end

  def solutions
    result = []

    if matches?
      result << mappings
    end

    shift_all do |shifted|
      result << shifted.mappings if shifted.matches?
    end

    result.flatten(1) unless result.empty?
  end

end

class Booster
  attr_reader :id, :code

  def initialize(id)
    @id = id
    @code = BoosterCode.new
  end

  def code=(key)
    @code.key = key
  end
end

class BoosterCode
  attr_accessor :key

  def initialize(key = :empty)
    @key = key
  end

  def ==(other_code)
    key == :empty || other_code.key == :empty || key == other_code.key
  end
end
