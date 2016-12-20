class Predicate
  attr_accessor :predicate
  attr_accessor :type

  def initialize(predicate)
    @predicate = predicate
  end

  def raw
    raw = @predicate.to_s.split('#')[1]
    return raw[0..raw.size-2]
  end

end
