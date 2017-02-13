require 'sparql'
require 'linkeddata'
require 'rubygems'

class Ontology
  attr_accessor :subject
  attr_accessor :repository
  attr_accessor :sparql

  def initialize(file_name)
    @repository = RDF::Repository.load(file_name)
    @sparql = SPARQL::Client.new(@repository)
  end

  def execute(sparql)
    SPARQL.execute(sparql, @repository)
  end

  def translate(sparql)
    # onto_query = OntoQuery.new(sparql)
    # return_var = Array.new
    # onto_query.project.each do |var_name|
    #   return_var << _name.delete(':')
    # end

    graph = Graph.new(OntoSplit.split(sparql))


    load_data(graph.root)
  end

  def load_data(node)
    #para cada nó do grafo chamo a funcao generate_data_to_insert
    if node.parent_nodes.length > 0
      node.parent_nodes.map { |n| load_data(n)  }
    end

    generate_data_to_insert(node)

  end

  private
  def generate_data_to_insert(node)
    # implementado para uma classe somente
    model = node.triple.subject.model
    data_to_insert = ""
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
    puts data_to_insert
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
