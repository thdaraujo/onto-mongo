class Triple
  attr_accessor :subject, :predicate, :object
  def initialize(list)
      @subject = Subject.new(list[0])
      @predicate = list[1]
      @object = OntoObject.new(list[2])
      set_ontoclass
   end

   def json
     return { subject: @subject.subject, property: @predicate, object: @object.object }
   end

   def set_ontoclass
     sparql = "SELECT ?domain ?range
	    WHERE { #{@predicate.to_s} <http://www.w3.org/2000/01/rdf-schema#domain> ?domain .
              #{@predicate.to_s} <http://www.w3.org/2000/01/rdf-schema#range> ?range}"

     ontology = Ontology.new("/myapp/ontologia/basic-lattes.rdf")

     result = ontology.execute(sparql)

    @subject.ontoclass = result.first.domain.to_s.split('#')[1]
    @object.ontoclass = result.first.range.to_s.split('#')[1]

   end
end
