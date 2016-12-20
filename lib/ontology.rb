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

    triples = OntoSplit.split(sparql)
    graph = Graph.new
    triples.each do |t|
      graph.add_parent(Node.new(t))
      puts t.json
    end

    generate_query(graph)
  end

  def generate_query(graph)
    # implementado para uma classe somente
    model = graph.root.triple.subject.model
    data_to_insert = ""
    m_count = model.all.count
    att_count = graph.root.data_properties.size

    model.all.each_with_index do |m, m_index|
      graph.root.data_properties.each_with_index do |att, att_index|
        data_to_insert.concat("<http://onto-mongo/basic-lattes/#{m.id}> #{att.predicate} \"#{m.attributes[Mapping.get_mapping(m, att.raw)]}\" ")
        if m_index == m_count -1 && att_index == att_count -1
          data_to_insert.concat(" \n")
        else
          data_to_insert.concat("\. \n")
        end
      end
    end

    generate_rdf_graph(data_to_insert)

  end

  private
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
