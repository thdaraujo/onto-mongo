class Node
  attr_accessor :triple
  attr_accessor :data_properties
  attr_accessor :name
  attr_accessor :filters

  def initialize(triple, name)
    @name = name #nome para o nó(como se fosse id)
    @data_properties = Array.new #atributos que estão sendo utilizados na consulta
    @filters = Array.new #filtros
    @triple = triple
  end

end
