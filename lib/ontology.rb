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
    triples = OntoSplit.split(sparql)
    graph = Graph.new
    triples.each do |t|
      graph.add_parent(Node.new(t))
      puts t.json
    end

    generate(graph)
  end

  def generate(graph)
    graph.root.triple.subject.model
  end

end
