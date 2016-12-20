class Node
  attr_accessor :triple
  attr_accessor :onto_class
  attr_accessor :data_properties
  attr_accessor :parent_nodes
  attr_accessor :name

  def initialize(triple)
    @triple = triple
    @name = triple.subject.var_name
    @onto_class = triple.subject.raw_ontoclass
    @parent_nodes = Array.new
    @data_properties = Array.new

    if triple.object.is_class
      add_parent(triple)
    else
      #pensar melhor....
      add_data_properties(triple)
    end

  end

  def add_data_properties(triple)
    @data_properties << triple.predicate
  end

  def add_parent(triple)
    node = Node.new(triple)
    @parent_nodes << node
  end

end
