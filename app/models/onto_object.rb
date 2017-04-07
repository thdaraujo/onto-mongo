class OntoObject
  attr_accessor :object
  attr_accessor :ontoclass
  attr_accessor :is_class
  attr_accessor :name

  def initialize(object)
    @object = object
    if @object.variable?
      @name = @object.name
    else
      @name = nil
    end
  end

  def is_variable?
    return @object.variable?
  end

  def value
    return @object.to_s
  end

  def raw_ontoclass
    return @ontoclass.to_s.split('#')[1]
  end

end
