class Triple
  attr_accessor :subject, :predicate, :object
  def initialize(triple)
      @subject = Subject.new triple[1]
      @predicate = Predicate.new triple[2]
      @object = OntoObject.new triple[3]
      set_ontoclass
      puts "setou ontoclass"
   end

   def json
     return { subject: @subject.subject, property: @predicate.predicate, object: @object.object }
   end

   private
   def set_ontoclass
     sparql = "SELECT ?domain ?range ?type
	    WHERE { <#{@predicate.value}> <http://www.w3.org/2000/01/rdf-schema#domain> ?domain .
              <#{@predicate.value}> <http://www.w3.org/2000/01/rdf-schema#range> ?range .
              <#{@predicate.value}> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> ?type }"

     ontology = Ontology.new("/myapp/ontologia/basic-lattes.rdf")

     result = ontology.execute(sparql)

     @subject.ontoclass = result.first.domain
     @object.ontoclass = result.first.range

     if result.first.type.to_s.include? "DatatypeProperty"
       @predicate.type = PredicateType::DatatypeProperty
       @object.is_class = false
     elsif result.first.type.to_s.include? "ObjectProperty"
       @predicate.type = PredicateType::ObjectProperty
       @object.is_class = true
     end
   end
end
