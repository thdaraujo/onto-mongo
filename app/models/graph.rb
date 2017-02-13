class Graph
  attr_accessor :root

  def initialize(triples)
    triples.each_with_index do |t, index|

      if index == 0
        @root = Node.new(t)
      end

      #se já existe um nó para este subject, então só precisa adicionar
      #o atributo ou o filtro
      if t.subject.subject.eql?(@root.triple.subject.subject)
        add_property(@root, t)
      else
        search_and_create(@root, t)
      end

    end
  end

  def add_property(node, triple)
    #se o object for uma classe então cria um nó
    if node.triple.object.is_class
      node.parent_nodes << Node.new(node.triple)
    elsif node.triple.object.raw_ontoclass[0].eql?("?")
      node.data_properties << triple.onto_object
      #se object for uma variavel ?variavel adicionar na lista de atributos
    else #senao deve ser um filtro
      node.filters << {filter_name: node.triple.predicate, value: node.triple.object }
    end
  end

  # pensar em outro nome
  def search_and_create(node, triple)
    node.parent_nodes.each do |n|
      if n.triple.subject.subject.eql?(triple.subject.subject)
        #nao sei se retorno ou faço algo mais aqui
        #adicionando
        add_property(n,triple)
        return true
      else
        #tento abrir mais nós, recursao?
        search(n, triple)
      end
    end
    #nao achou nada
    add_property(@root, triple)
    return false
  end

end
