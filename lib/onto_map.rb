# https://robots.thoughtbot.com/writing-a-domain-specific-language-in-ruby

module OntoMap

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_accessor :mapping, :ontology_class, :onto_query

    def ontoclass(ontology_class)
      @ontology_class = ontology_class
    end

    def maps(attributes)
      relation = attributes[:from]
      property = attributes[:to]

      @mapping ||= {}
      @mapping[relation] = property
    end

    # TODO refactor...
    def query(sparql)
      @onto_query = OntoQuery.new(sparql)
      model = Researcher # TODO

      triples = onto_query.triples

      relations = triples.select{|triple|
        property = prop(triple)
        is_relation(model, property)
      }

      if relations.present?
        first_projection = {
          "$project": {
            "name": true #TODO de onde vem esse name?
          }
        }
        relations.each do |triple|
          var = { triple.object.name.to_s => "$" + prop(triple).to_s }
          first_projection[:$project].merge!(var)
        end

        unwinds = relations.map do |triple|
          { "$unwind": "$" + triple.object.name.to_s }
        end
      end

      # TODO second_projection
      # pegar de onto_query.filter
      second_projection = {
        "$project": {
          "name": true,
          "publication1": true,
          "publication2": true,
          "twoInOneYear": {
            "$and": [{
              "$eq": ["$publication1.year", "$publication2.year"]
            }, {
              "$ne": ["$publication1.title", "$publication2.title"]
            }]
          }
        }
      }

      # TODO match
      # basta declarar uma variavel na second_projection e usar aqui?
      match = {
        "$match": {
          "twoInOneYear": true
        }
      }

      # TODO output_projection
      # 1. pegar as variaveis de output de onto_query.project
      # 2. dar algum match com as vars?
      output_projection = {
        "$project": {
          "researcherName": "$name",
          "publicationTitle1": "$publication1.title",
          "publicationTitle2": "$publication2.title",
          "year": "$publication1.year"
        }
      }

      @onto_query
    end


=begin
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
=end

    def print
      puts "Ontoclass: #{@ontology_class}"
      puts "Mapping: #{@mapping.to_s}"
    end

    private

      def is_relation(klass, property)
        klass.relations? && klass.relations[property.to_s].present?
      end

      def prop(triple)
        predicate = triple.predicate
        mapping[predicate.to_s]
      end

=begin
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
=end

  end
end
