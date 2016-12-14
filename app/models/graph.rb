class Graph
  attr_accessor :root

  def initialize
  end

  def add_parent(node)
    if @root.blank?
      @root = node
    else
      if node.name.eql?(@root.name)
        @root.add_data_property(node.triple)
      else
        #TODO verificar para os filhos
      end
    end
  end
end
