class Node
  attr_accessor :triple
  attr_accessor :data_properties
  attr_accessor :name
  attr_accessor :filters
  attr_accessor :ontoclass
  attr_accessor :adjacent_nodes

  def initialize(triple, name, ontoclass)
    @name = name #nome para o nó(como se fosse id)
    @data_properties = Array.new #atributos que estão sendo utilizados na consulta
    @filters = Array.new #filtros
    @triple = triple
    @ontoclass = ontoclass
    @adjacent_nodes = Hash.new
  end

end
