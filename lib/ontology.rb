require 'sparql'
require 'linkeddata'
require 'rubygems'
require 'rgl/adjacency'

class Ontology
  attr_accessor :subject, :repository, :sparql, :graph, :vertex_hash

  def initialize(file_name)
    @repository = RDF::Repository.load(file_name)
    @sparql = SPARQL::Client.new(@repository)
    @vertex_hash = Hash.new #hash que guarda todos os vertices do grafo para facilitar a busca
  end

  def execute(sparql)
    SPARQL.execute(sparql, @repository)
  end

  def translate(sparql)

    #graph = Graph.new(OntoSplit.split(sparql))
    @graph = RGL::DirectedAdjacencyGraph.new
    triples = OntoSplit.split(sparql)

    triples.each_with_index do |t, index|
      #Verificar se já existe nó
      if @vertex_hash.has_key?(t.subject.name)
        #Quando o nó já existir entao é
        #necessário verificar se o object é um
        #atributo ou propriedade
        add_property(t)
      else #se não existe nó
        create_vertex(t)
        add_property(t)
      end
    end

    return @graph

  end

  def load_data(node)
    #para cada nó do grafo chamo a funcao generate_data_to_insert
    if node.parent_nodes.length > 0
      node.parent_nodes.map { |n| load_data(n)  }
    end

    generate_data_to_insert(node)

  end

  private

  def create_vertex(triple)
    vertex_name = triple.subject.name
    @graph.add_vertex vertex_name
    @vertex_hash[vertex_name] = Node.new(triple, vertex_name)
  end

  def add_property(triple)
    #se o object for uma classe então cria um nó
    if triple.object.is_class
      #adicionar nó
      add_vertex(triple.object.name) #se já existe nao faz nada
      add_edge(triple.subject.name, triple.object.name)

      #adicionando no hash
      if !@vertex_hash.has_key?(triple.object.name)#verifica se existe
        @vertex_hash[triple.object.name] = Node.new(triple, triple.object.name)
      end
    elsif triple.object.raw_ontoclass[0].eql?("?")
      #se object for uma variavel ?variavel adicionar na lista de atributos
      @vertex_hash[triple.subject.name].data_properties << triple.predicate
    else #senao deve ser um filtro
      @vertex_hash[triple.subject.name].filters << {filter_name: triple.predicate, value: triple.object }
    end
  end

  def generate_data_to_insert(node)
    # implementado para uma classe somente
    model = node.triple.subject.model
    data_to_insert = " "
    wheres = Hash.new


    node.filters.each do |f|
      x = Mapping.get_mapping(model, f[:filter_name].raw)
      y = f[:value].var_name
      wheres = {x => y}
    end

    result = model.where(wheres)

    m_count = result.count
    att_count = node.data_properties.size
    puts m_count

    #attributes
    result.each_with_index do |m, m_index|
      node.data_properties.each_with_index do |att, att_index|
        data_to_insert.concat("<http://onto-mongo/basic-lattes/#{m.id}> #{att.predicate} \"#{m.attributes[Mapping.get_mapping(m, att.raw)]}\" ")
        if m_index == m_count -1 && att_index == att_count -1
          data_to_insert.concat(" \n")
        else
          data_to_insert.concat("\. \n")
        end
      end
    end

    generate_rdf_graph(data_to_insert)
    puts "data_to_insert => #{data_to_insert}"
  end

  def generate_rdf_graph(data_to_insert)

    sse = SPARQL.parse(%(
      PREFIX onto: <http://onto-mongo/basic-lattes#>
      INSERT DATA {
                    #{data_to_insert}
                    }
    ), update: true)
    sse.execute(@repository)

  end

end
