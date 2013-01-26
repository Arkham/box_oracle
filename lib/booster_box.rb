require 'code_sequence'

class BoosterBox
  attr_reader :boosters, :code_sequence

  def initialize(count = 36)
    @boosters = count.times.map { |n| Booster.new(n + 1) }
  end

  def boosters_per_row
    3
  end

  def box_by_row
    result = []
    boosters.each_slice(boosters_per_row) do |slice|
      result << slice
    end
    result
  end

  def row(index)
    box_by_row[index-1]
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

  def match!
    code_sequence.scan(codes)
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
