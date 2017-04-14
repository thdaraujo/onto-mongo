class Subject
  attr_accessor :subject
  attr_accessor :ontoclass
  attr_accessor :name
  attr_accessor :is_variable

 #TODO verificar quando não for variavel
  def initialize(subject)
    @subject = subject
    @relations = []
    if @subject.class == String
      @name = nil
      @is_variable = false
    else
      @name = @subject.name
      @is_variable = true
    end
  end

  def value
    return @subject.to_s
  end

  def is_variable?
    return @is_variable
  end

  def raw_ontoclass
    return @ontoclass.to_s.split('#')[1]
  end
end
