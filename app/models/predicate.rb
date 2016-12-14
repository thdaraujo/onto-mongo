class Predicate
  attr_accessor :predicate
  attr_accessor :type

  def initialize(predicate)
    @predicate = predicate
  end

  def raw
    return @predicate.to_s.split('#')[1]
  end

end
