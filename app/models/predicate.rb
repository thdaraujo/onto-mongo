class Predicate
  attr_accessor :predicate
  attr_accessor :type

  def initialize(predicate)
    @predicate = predicate
  end

  def name
    return @predicate.fragment
  end

  def value
    return @predicate.value
  end

end
