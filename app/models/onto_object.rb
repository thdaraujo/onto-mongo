class OntoObject
  attr_accessor :object
  attr_accessor :ontoclass
  attr_accessor :is_class
  attr_accessor :name

  def initialize(object)
    @object = object
    if self.is_variable?
      @name = @object.to_s.split('?')[1]
    else
      @name = @object
    end
  end

  def var_name
    return @object
  end

  def is_variable?
    return @object[0].eql?("?")
  end

  def raw_ontoclass
    return @ontoclass.to_s.split('#')[1]
  end

end
