# https://robots.thoughtbot.com/writing-a-domain-specific-language-in-ruby

module OntoMap
  attr_accessor :mapping, :ontology_class

  @mapping = {}
  @ontology_class = nil

=begin

  @attributes = {}

  def method_missing(name, *args)
    attribute = name.to_s
    if attribute =~ /=$/
      @attributes[attribute.chop] = args[0]
    elsif @attributes[attribute].present?
      @attributes[attribute]
    else
      self.send @mapping[attribute]
    else

    end
    puts attribute
  end
=end

  def ontoclass(ontology_class)
    @ontology_class = ontology_class
  end

  def maps(attributes)
    relation = attributes[:from]
    property = attributes[:to]

    @mapping ||= {}
    @mapping[relation] = property
  end

  def query(sparql)
    triples = expand_query(sparql)
    model = nil

    # TODO
    # descobrir qual é a model: quem for da ontoclass foaf:Person
    # vamos supor que seja sempre Researcher no momento (TODO)
    #if triples :ontoclass ... == 'foaf:Person'
      model = Researcher
    #end

    filters = triples.map{|triple|
      property = @mapping[triple.predicate]
      value = triple.object
      { property => value }
    }.inject({}){|hash, injected| hash.merge!(injected)}

    puts filters.to_yaml
    model.where(filters)
  end

  def expand_query(sparql)
    OntoSplit.split(sparql).keep_if{|t| t.object.present? }
  end

  def build_query(arr)
    # TODO
    # query.inject  ... montar um hash de subjects com suas listas de relações/properties
    # por exemplo:
    # ?person -> [a: "foaf:Person", "foaf:name" = "fulano", "foaf:mbox" = "123@4"]
    # pode ser um objeto tbm... fica mais facil.

    {
      subject: '?person',
      ontoclass: 'foaf:Person',
      relations: [{ property: "foaf:name", object: 'Marcelo Barreiros Maia Alves' }]
    }
  end

  def print
    puts "Ontoclass: #{@ontology_class}"
    puts "Mapping: #{@mapping.to_s}"
  end
end
