class OntoObject
  attr_accessor :object
  attr_accessor :ontoclass
  attr_accessor :is_class
  attr_accessor :name
  attr_accessor :is_variable

  def initialize(object)
    @object = object
    if @object.class == String
      @name = nil
      @is_variable = false
    else
      @name = @object.name
      @is_variable = true
    end
  end

  def is_variable?
    return @is_variable
  end

  def value
    return @object.to_s
  end

  def raw_ontoclass
    return @ontoclass.to_s.split('#')[1]
  end

end
