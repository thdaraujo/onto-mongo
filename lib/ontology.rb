require 'sparql'
require 'linkeddata'
require 'rubygems'
require 'rgl/adjacency'
require 'rgl/dot'

class Ontology
  attr_accessor :subject, :repository, :sparql, :graph, :vertex_hash, :data_to_insert

  def initialize(file_name)
    @repository = RDF::Repository.load(file_name)
    @sparql = SPARQL::Client.new(@repository)
    @vertex_hash = Hash.new #hash que guarda todos os vertices do grafo para facilitar a busca
    @data_to_insert = " "
  end

  def execute(sparql)
    SPARQL.execute(sparql, @repository)
  end

  def translate(sparql)

    #graph = Graph.new(OntoSplit.split(sparql))
    @graph = RGL::DirectedAdjacencyGraph.new

    onto_query = OntoQuery.new(sparql)
    triples = onto_query.triples
    #triples = OntoSplit.split(sparql)

    puts "Lista de triplas encontradas ------> "
    triples.each_with_index do |t, index|
      puts "Tripla #{index} ///////////////////////////////////////// "
      puts "Tripla #{index} subject: #{t.subject.name}, predicate: #{t.predicate.name}, object: #{t.object.name} "
      #Verificar se já existe nó

      #TODO repensar a criacao dos nós
      #E se o subject for filtro e object for variavel??
      if @vertex_hash.has_key?(t.subject.name)
        puts "Vertice para Tripla #{index} já existe"
        #Quando o nó já existir entao é
        #necessário verificar se o object é um
        #atributo ou propriedade
        add_property(t)
      else #se não existe nó
        puts "Vertice para Tripla #{index} NÃO existe"
        create_vertex(t)
        add_property(t)
      end

      puts "///////////////////////////////////////////////////////// "
    end

    #Cria arquivo com o desenho do grafo
    @graph.write_to_graphic_file('jpg')

    puts "Gerando dados para inserir"
    puts "Grafo de tamanho #{@graph.size}"
    @graph.each_vertex do |vertex|
      generate_data_to_insert(@vertex_hash[vertex])
    end

    generate_rdf_graph(@data_to_insert)
    puts "data_to_insert => #{@data_to_insert}"

  end

  private

  def create_vertex(triple)
    puts "Criando vertice para tripla subject: #{triple.subject.name} predicate: #{triple.predicate.name}"
    vertex_name = triple.subject.name
    @graph.add_vertex vertex_name
    @vertex_hash[vertex_name] = Node.new(triple, vertex_name, triple.subject.raw_ontoclass)
  end

  def add_property(triple)
    #se o object for uma classe então cria um nó
    if triple.object.is_class || triple.predicate.type == PredicateType::ObjectProperty
      #adicionar nó
      add_vertex(triple.object.name) #se já existe nao faz nada
      add_edge(triple.subject.name, triple.object.name)
      puts "Adicionando aresta entre vertices #{triple.subject.name} e #{triple.object.name}"

      #adicionando no hash
      if !@vertex_hash.has_key?(triple.object.name)#verifica se existe
        puts "Criando nó para #{triple.object.name}"
        @vertex_hash[triple.object.name] = Node.new(triple, triple.object.name, triple.object.raw_ontoclass)
      end
    elsif triple.object.is_variable?
      puts "Object é variavel"
      #se object for uma variavel ?variavel adicionar na lista de atributos
      @vertex_hash[triple.subject.name].data_properties << triple.predicate
    else #senao deve ser um filtro
      puts "Object é filtro"
      @vertex_hash[triple.subject.name].filters << {filter_name: triple.predicate, value: triple.object }
    end
  end

  def generate_data_to_insert(node)
    # implementado para uma classe somente
    model = node.model
    wheres = Hash.new
    puts "O model -> #{model.to_s}"

    node.filters.each do |f|
      x = Mapping.get_mapping(model, f[:filter_name].name)
      y = f[:value].var_name
      wheres = {x => y}
    end

    if wheres.empty?
      result = model.all
    else
      result = model.where(wheres)
    end

    m_count = result.count
    att_count = node.data_properties.size
    puts m_count

    #attributes
    result.each_with_index do |m, m_index|
      node.data_properties.each_with_index do |att, att_index|
        @data_to_insert.concat("<http://onto-mongo/basic-lattes/#{m.id}> <#{att.predicate}> \"#{m.attributes[Mapping.get_mapping(m, att.name)]}\" ")
        if m_index == m_count -1 && att_index == att_count -1
          @data_to_insert.concat(" \n")
        else
          @data_to_insert.concat("\. \n")
        end
      end
    end
  end

  def generate_rdf_graph(data_to_insert)
    puts "Data to Insert => #{data_to_insert}"

    sse = SPARQL.parse(%(
      PREFIX onto: <http://onto-mongo/basic-lattes#>
      INSERT DATA {
                    #{data_to_insert}
                    }
    ), update: true)
    sse.execute(@repository)

  end

end
