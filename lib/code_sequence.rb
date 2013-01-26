require 'circular_array'

class CodeSequence
  attr_reader :sequence

  def initialize(sequence)
    @sequence = CircularArray.new(sequence)
  end

  def scan(haystack)
    result = []

    sequence.each_index do |index|
      if haystack_found?(haystack, index)
        result << index
      end
    end

    result unless result.empty?
  end

  def haystack_found?(haystack, index)
    first = sequence[index]

    if haystack.is_a? Array
      if first == haystack.first
        sequence[index ... index + haystack.length] == haystack
      end
    else
      first == haystack
    end
  end

end
