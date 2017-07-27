require 'rgl/adjacency'
module Example

  def self.ex1
    sparql = "SELECT ?nome WHERE { ?researcher <http://onto-mongo/basic-lattes#nome> ?nome ." \
                               " }"
    ontology = Ontology.new("/myapp/ontologia/basic-lattes.rdf")
    graph = ontology.translate(sparql)

=begin
  EXEMPLO DE SAÍDA - CONSULTA FINAL
    "$project": {
      "name": true
    }

=end
  end


  def self.teste
    final = [{"$project"=>{:name=>true}}, {"$match"=> {:name=>'Marcelo Barreiros Maia Alves'}}]
    # final = [{"$project"=>{:name=>true}}]
    result = Researcher.collection.aggregate(final)
  end

  def self.ex2
    sparql = "SELECT ?nome WHERE { ?researcher <http://onto-mongo/basic-lattes#nome> ?nome . " \
                                  "?researcher <http://onto-mongo/basic-lattes#nome> 'Marcelo Barreiros Maia Alves' " \
                               " }"
    ontology = Ontology.new("/myapp/ontologia/basic-lattes.rdf")
    graph = ontology.translate(sparql)

=begin
      EXEMPLO DE SAÍDA - CONSULTA FINAL
        "$project": {
          "name": true
        }
        "$match": {
          "name": 'Marcelo Barreiros Maia Alves'
        }

=end
  end

  def self.ex3
    sparql = "SELECT ?nome WHERE { ?researcher <http://onto-mongo/basic-lattes#nome> ?nome . " \
                                  "?researcher  <http://onto-mongo/basic-lattes#publicou> ?article." \
                                  "?article <http://onto-mongo/basic-lattes#titulo> ?title " \
                               " }"
    ontology = Ontology.new("/myapp/ontologia/basic-lattes.rdf")
    graph = ontology.translate(sparql)

=begin
      EXEMPLO DE SAÍDA - CONSULTA FINAL
        "$project": {
          "name": true,
          "artigos1": '$publications'
        }
        "$unwind": {
          "artigos1"
        }
        "$project": {
          "name": true,
          "article.title"=>true
        }


=end
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
