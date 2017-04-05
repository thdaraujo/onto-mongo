# https://robots.thoughtbot.com/writing-a-domain-specific-language-in-ruby

module OntoMap

  def self.registry
    @@registry ||= {}
  end

  def self.class_mapping
    @@class_mapping ||= {}
  end

  def self.model_mapping
    @@model_mapping ||= {}
  end

  def self.model_for(k)
    self.class_mapping[k]
  end

  def self.class_for(k)
    self.model_mapping[k]
  end

  def self.attributes_for(onto_class)
    self.registry[onto_class].attr_mapping
  end

  def self.relations_for(onto_class)
    self.registry[onto_class].relation_mapping
  end

  def self.mapping(onto_class, &block)
    factory = Factory.new(onto_class)
    factory.instance_eval(&block)
    register(factory)
  end

  def self.register(factory)
    self.registry[factory.onto_class]        = factory
    self.class_mapping[factory.onto_class]   = factory.model_class
    self.model_mapping[factory.model_class]  = factory.onto_class

    # TODO get factory
    #OntoMap.factories[factory]  = factory
  end

  def self.print
    puts "mappings:"
    self.class_mapping.each do |k, v|
      puts "  #{k} -> #{v}"

      puts "    attributes:"
      attributes_for(k).each do |attr, val|
        puts "      #{attr} -> #{val}"
      end

      puts "  relations:"
      relations_for(k).each do |k, rel|
        puts "      #{k} -> #{rel.to_s}"
      end
    end
  end

  class Factory < Object
    attr_accessor :attr_mapping, :relation_mapping, :onto_class, :model_class

    def initialize(o)
      @attr_mapping = {}
      @relation_mapping = {}
      @onto_class = o
    end

    def model(m)
      @model_class = m
    end

    def maps(attributes)
      class_attribute = attributes[:from]
      model_attribute = attributes[:to]
      relation = attributes[:relation]
      if relation.nil?
        @attr_mapping[class_attribute] = model_attribute
      else
        # TODO verificar se a model foi definida antes???
        from_model = model_class
        to_model = model_class.reflect_on_association(model_attribute).class_name.constantize

        if to_model.nil?
          raise ArgumentError, "association not found in model", attributes[:to]
        end

        @relation_mapping[relation] = Relation.new(class_attribute, relation, from_model, to_model)
      end
    end
  end

  class Relation
    attr_reader :class_attribute, :model_attribute, :from_model, :to_model

    def initialize(class_attribute, model_attribute, from_model, to_model)
      @class_attribute = class_attribute
      @model_attribute = model_attribute
      @from_model = from_model
      @to_model = to_model
    end

    def to_s
      "#{class_attribute} => #{from_model} #{model_attribute} a #{to_model}"
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_reader :onto_query

    # TODO refactor...
    def query(sparql)
      @onto_query = OntoQuery.new(sparql)
      model = Researcher # TODO
      parameters = []

      triples = onto_query.triples
      relations = extract_relations(triples, model)
      # variables are not relations (inverse of relations)
      variables = extract_variables(triples, model)

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

        parameters << first_projection
        parameters << unwinds
      end

      # TODO de onde vem esse name?
      second_projection = {
        "$project": {
          "name": true
        }
      }

      # include filters in projection
      filtered_variables = onto_query.filter.values.uniq.flatten(1)
      if filtered_variables.present?

        equality_filters = []
        inequality_filters = []

        filtered_variables.each do |f|
          var = { f => true }
          second_projection[:$project].merge!(var)
        end

        # TODO this might be wrong
        # repeated variables indicate equality of attributes
        equality_filters = variables.
                            group_by{|triple| triple.object.name }.
                            select{|object, group| group.size > 1 }.
                            map{|object, group|
                              group.map{|repeated_var|
                                "$#{repeated_var.subject.name}.#{object}"
                              }
                            }.flatten(1)

        # TODO Should we treat other cases, like >= ?
        if onto_query.filter[:ne].present? && equality_filters.present?
          inequality_filters = variables.
                               select{|triple|
                                 filtered_variables.include?(triple.subject.name)
                              }.
                              map{|triple|
                                property = prop(triple)
                                "$#{triple.subject.name}.#{property}"
                              }

          # we filter everything that should be different
          # except the things that should be equal.
          # ne_filter = not_equal_properties EXCEPT equal_properties
          inequality_filters = inequality_filters - equality_filters
        end


        filters = []
        filters << { "$eq": equality_filters   } if equality_filters.present?
        filters << { "$ne": inequality_filters } if inequality_filters.present?

        if filters.size > 1
          filters = {"$and" => filters}
        end

        if filters.present?
          filter_key = "filter_1"
          second_projection[:$project].merge!({ filter_key => filters })

          parameters << second_projection

          # match
          match = {
            "$match": {
              filter_key => true
            }
          }

          parameters << match
        end
      end

      # TODO output_projection
      # 1. pegar as variaveis de output de onto_query.project
      # 2. dar algum match com as vars?
      output_projection = {
        "$project": {
        }
      }

      onto_query.project.each do |output_var|
        attribute = '$'

        triple = variables.select{|triple| triple.object.name == output_var }.first
        property = prop(triple)

        # TODO: this might be wrong...
        complex = relations.select{|rel| triple.subject.name == rel.object.name }.first
        if complex.present?
          attribute << complex.object.name.to_s + '.'
        end

        attribute << property.to_s
        var = { triple.object.name.to_s => attribute }

        output_projection[:$project].merge!(var)
      end

      parameters << output_projection

      # TODO refactor parameters...
      # parameters2 = [first_projection, unwinds, second_projection, match, output_projection].flatten(1)
      final_parameters = parameters.flatten(1)
      Researcher.collection.aggregate(final_parameters)
    end

    def print
      puts "Ontoclass: #{@ontology_class}"
      puts "Mapping: #{@mapping.to_s}"
    end

    private

      def extract_relations(triples, klass)
        triples.select{|triple|
          property = prop(triple)
          is_relation(klass, property)
        }
      end

      # variables are not relations
      # (inverse of relations)
      def extract_variables(triples, klass)
        triples.reject{|triple|
          property = prop(triple)
          is_relation(klass, property)
        }
      end

      def is_relation(klass, property)
        klass.relations? && klass.relations[property.to_s].present?
      end

      def prop(triple)
        predicate = triple.predicate
        property = mapping[predicate.to_s]
        if property.present?
          return property
        else
          # try to find property on relations
          self.relations.values.
          select{|rel|
            rel.klass.mapping.present? && rel.klass.mapping[predicate.to_s].present?
          }.
          map{|rel|
            rel.klass.mapping[predicate.to_s].to_s
          }.first
        end
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
