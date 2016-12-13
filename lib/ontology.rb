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

  def self.teste
    patterns = [[:subject, RDF::RDFS.subClassOf, :object]]
    query = sparql.select.where([:subject, RDF::RDFS.subClassOf, :object])

    query.each_solution do |solution|
      puts solution.inspect
    end

    return query
  end



end
