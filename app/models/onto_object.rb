class OntoObject
  attr_accessor :object
  attr_accessor :ontoclass
  attr_accessor :is_class

  def initialize(object)
    @object = object
  end

  def raw_ontoclass
    return @ontoclass.to_s.split('#')[1]
  end

  def var_name
    return @object
  end

end
