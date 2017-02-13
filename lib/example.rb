module Example
  def self.teste
    sparql = "SELECT ?nome WHERE { ?x <http://onto-mongo/basic-lattes#nome> 'Kristen Nygaard' }"
    ontology = Ontology.new("/myapp/ontologia/basic-lattes.rdf")
    ontology.translate(sparql)


    return ontology.execute(sparql)

  end

  def self.teste2
    sparql = "SELECT ?nome ?sobrenome WHERE { ?x <http://onto-mongo/basic-lattes#nome> ?nome }"
    onto = OntoQuery.new sparql
  end


end
