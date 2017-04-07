class Subject
  attr_accessor :subject
  attr_accessor :ontoclass
  attr_accessor :name

 #TODO verificar quando não for variavel
  def initialize(subject)
    @subject = subject
    @relations = []
    if @subject.variable?
      @name = @subject.name
    else
      @name = nil
    end
  end

  def value
    return @subject.to_s
  end

  def is_variable?
    return @subject.variable?
  end

  def raw_ontoclass
    return @ontoclass.to_s.split('#')[1]
  end
end
