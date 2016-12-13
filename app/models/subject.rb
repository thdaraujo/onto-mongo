class Subject
  attr_accessor :subject
  attr_accessor :ontoclass

  def initialize(subject)
    @subject = subject
    @relations = []
  end

  def add_relation(property, object)
    @relations << {property: property, object: object}
  end
end
