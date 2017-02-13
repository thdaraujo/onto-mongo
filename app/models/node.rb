class Node
  attr_accessor :triple
  attr_accessor :onto_class
  attr_accessor :data_properties
  attr_accessor :parent_nodes
  attr_accessor :name
  attr_accessor :filters

  def initialize(triple)
    @triple = triple
    @name = triple.subject.var_name #nome para o nó(como se fosse id)
    @onto_class = triple.subject.raw_ontoclass #Classe que representa este nó
    @parent_nodes = Array.new # array com os nós adjacentes
    @data_properties = Array.new #atributos que estão sendo utilizados na consulta
    @filters = Array.new #filtros
  end

end
