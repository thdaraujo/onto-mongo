module Example
  def self.teste
    sparql = "SELECT ?nome WHERE { ?x <http://onto-mongo/basic-lattes#nome> ?nome }"
    OntoSplit.split(sparql)
  end

  def self.asas
    sparql = "SELECT ?domain ?range
     WHERE { <http://onto-mongo/basic-lattes#nome> <http://www.w3.org/2000/01/rdf-schema#domain> ?domain.
             <http://onto-mongo/basic-lattes#nome> <http://www.w3.org/2000/01/rdf-schema#range> ?range}"
    ontology = Ontology.new("/myapp/ontologia/basic-lattes.rdf")

    query = ontology.execute(sparql)

    puts "Domain: #{query.first.domain.to_s.split('#')[1]}"
    puts "Range: #{query.first.range.to_s.split('#')[1]}"


  end
end
