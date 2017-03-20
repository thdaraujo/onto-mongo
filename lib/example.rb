require 'rgl/adjacency'
module Example
  def self.teste
    sparql = "SELECT ?nome WHERE { ?researcher <http://onto-mongo/basic-lattes#nome> ?nome }"
    ontology = Ontology.new("/myapp/ontologia/basic-lattes.rdf")
    ontology.translate(sparql)


    return ontology.execute(sparql)

  end

  def self.teste2
    sparql = "SELECT ?nome ?sobrenome WHERE { ?x <http://onto-mongo/basic-lattes#nome> ?nome }"
    onto = OntoQuery.new sparql
  end

  def self.graph
    sparql = "SELECT ?nome WHERE { ?researcher <http://onto-mongo/basic-lattes#nome> ?nome }"
    ontology = Ontology.new("/myapp/ontologia/basic-lattes.rdf")
    graph = ontology.translate(sparql)

  end


=begin

SELECT *
WHERE {
        ?scientist :firstName ?firstName.
        ?scientist :lastName ?lastName.
        ?scientist :gotAward ?aw1.
        ?scientist :gotAward ?aw2.
        ?aw1 :awardedInYear ?year.
        ?aw2 :awardedInYear ?year.
        ?aw1 :awardName ?awName1.
        ?aw2 :awardName ?awName2.
        filter(?aw1 != ?aw2)
}

=end


end
