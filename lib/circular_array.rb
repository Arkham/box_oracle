class CircularArray < Array
  def [](index)
    super(index % length)
  end
end
