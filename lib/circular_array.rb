class CircularArray < Array

  def [](index)
    if index.is_a? Fixnum
      super(index % length)
    elsif index.is_a? Range
      index.map do |i|
        self[i]
      end
    end
  end

end
