class Node
  attr_accessor :triple
  attr_accessor :data_properties
  attr_accessor :name
  attr_accessor :filters
  attr_accessor :model

  def initialize(triple, name, ontoclass)
    @name = name #nome para o nó(como se fosse id)
    @data_properties = Array.new #atributos que estão sendo utilizados na consulta
    @filters = Array.new #filtros
    @triple = triple
    @model = set_model(ontoclass)
  end

  def set_model(ontoclass)
    puts "Ontoclass = #{ontoclass}"
    case ontoclass
    when "Pessoa"
      @model = Researcher
    when "Artigo"
      @model = Publication
    else
      puts "Error: Model not Found!"
      #return false
    end

  end

end
