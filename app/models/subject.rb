class Subject
  attr_accessor :subject
  attr_accessor :ontoclass
  attr_accessor :model
  attr_accessor :name

  def initialize(subject)
    @subject = subject
    @relations = []
    @name = raw_ontoclass
  end

  def add_relation(property, object)
    @relations << {property: property, object: object}
  end

  def raw_ontoclass
    return @ontoclass.to_s.split('#')[1]
  end

  def var_name
    return @subject
  end

  def set_model
    onto = @ontoclass.to_s.split('#')[1]

    case onto
    when "Pessoa"
      @model = Researcher
    when "Artigo"
      @model = Publication
    else
      puts "default"
    end

  end
end
