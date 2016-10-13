# https://robots.thoughtbot.com/writing-a-domain-specific-language-in-ruby

module OntoMap

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_accessor :mapping, :ontology_class
    
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

    def print
      puts "Ontoclass: #{@ontology_class}"
      puts "Mapping: #{@mapping.to_s}"
    end

    private

      def expand_query(sparql)
        OntoSplit.split(sparql)
      end

      def build_query(triples)
        subjects = Hash.new
        triples.each do |t|
          if !subjects.key? t.subject
            subjects[t.subject] = Subject.new(t.subject)
          end
          subjects[t.subject].add_relation(t.predicate, t.object)
        end

        return subjects
      end

      def build_query(arr)
        # TODO
        # query.inject  ... montar um hash de subjects com suas listas de relações/properties
        # por exemplo:
        # ?person -> [a: "foaf:Person", "foaf:name" = "fulano", "foaf:mbox" = "123@4"]
        # pode ser um objeto tbm... fica mais facil.
      end

  end
end
