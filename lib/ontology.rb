require 'sparql'
require 'linkeddata'
module Ontology
  def self.load
    sparql = SPARQL::Client.new("../ontologia/basic-lattes.owl")
    queryable = RDF::Repository.load("/myapp/ontologia/basic-lattes.owl")

    patterns = [[:subject, RDF::RDFS.subClassOf, :object]]
    query = sparql.select.where([:subject, RDF::RDFS.subClassOf, :object])
    return query
    # query.each_solution do |solution|
    #   puts solution.inspect
    # end

  end

end
