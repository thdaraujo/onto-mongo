# https://robots.thoughtbot.com/writing-a-domain-specific-language-in-ruby

module OntoMap
  @registry = {}
  @ontology_class = nil

  def ontoclass(ontology_class)
    @ontology_class = ontology_class
  end

  def maps(property, relation)
    subject = @ontology_class
    @registry[relation] = property

    puts @registry
  end

  def query(sparql)
    #TODO
    map = @registry.map{|rel, filter| filter.call }
    # ? reduce = map.inject{|| }
    puts sparql
    puts map
  end

  def print
    puts "Ontoclass: #{@ontology_class}"
    puts "Registry:"
    puts @registry
  end
end
