module Example
  def self.teste
    sparql = "SELECT ?nome WHERE { ?x <http://onto-mongo/basic-lattes#nome> ?nome }"
    ontology = Ontology.new("/myapp/ontologia/basic-lattes.rdf")
    ontology.translate(sparql)

    Researcher.all.each do |r|
      puts "Nome >>>>>>>>>>>>>>> #{r.name}"
    end

  end


end
