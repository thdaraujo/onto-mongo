class Generator
  attr_accessor :graph, :vertex_hash, :data_to_insert

  def initialize(graph, vertex_hash)
    @graph = graph
    @vertex_hash = vertex_hash
    @data_to_insert = ""

    @root = @vertex_hash[@graph.first]
    @model = OntoMap.model_for(@root.ontoclass)
    @project = Hash.new
    @match = Hash.new
    @unwind = []
    @final_parameters = []
    @unwind_control = []
  end

  def run
    @graph.each_vertex do |node|
      puts node
      generate_mongodb_query(node)
    end

    puts "MODEL << #{@model}"
    puts "PROJECT << #{@project}"
    puts "UNWIND << #{@unwind}"
    puts " MATCH << #{@match}"

    puts "FINAL_PARAMETERS << #{@final_parameters}"

    result = @model.collection.aggregate(@final_parameters)
    puts "RESULT << #{result.count}"

    generate_rdf_to_insert(result)

    return @data_to_insert
  end

  private

  def generate_mongodb_query(vertex)
    node = @vertex_hash[vertex]
    # implementado para uma classe somente
    #model = OntoMap.model_for(node.ontoclass)
    wheres = Hash.new
    puts "O model -> #{@model.to_s}"

    if node.data_properties.any?
      node.data_properties.each do |dp|
        field = OntoMap.attributes_for(node.ontoclass)[dp.name]

        if @unwind_control.include?(node.name.to_s)
          compound_field = node.name.to_s + '.' + field.to_s
          puts "compound_field  #{compound_field}"
          @project[compound_field] = true
        else
          @project[field] = true
        end

      end

      # unwind fields
      node.adjacent_nodes.each do |key, value|
        content = OntoMap.relations_for(node.ontoclass)[value[:relation].name].model_attribute
        field = value[:object].name.to_s
        @unwind_control << field
        @project[field] = "$#{content}"
        @unwind << {"$unwind" => "$#{value[:object].name}"}
      end
    end

    #{$match: {"name.first": {$eq: "Kristen"}} },
    if node.filters.any?
      node.filters.each do |f|
        key = OntoMap.attributes_for(node.ontoclass)[f[:filter_name].name]
        value = f[:value].object.object
        @match[key] = value
      end
    end

    join_hashes
  end

  def generate_rdf_to_insert(result)
    #attributes
    result.each_with_index do |r, result_index|
      r.each_key do |key|
        if !key.to_s.eql?("_id")

          pattern = /(\'|\"|\.|\*|\/|\-|\\)/
        #  string.gsub(pattern){|match|"\\"  + match}

          predicate = OntoMap.inverted_attributes_for(@root.ontoclass)[key.to_sym]

          instance = r[key]

          puts "aaa: #{@root.ontoclass}"

          puts "PREDICADO: #{predicate} - VALUE: #{instance} - CLASS: #{instance.class}"

          @data_to_insert = @data_to_insert + "<http://onto-mongo/basic-lattes/#{r["_id"]}>" \
                                            "<http://onto-mongo/basic-lattes##{predicate}>"\
                                            " \"#{instance}\" "
          if result_index == result.count - 1
            @data_to_insert.concat(" \n")
          else
            @data_to_insert.concat("\. \n")
          end
        end
      end
    end
  end

  def join_hashes
    if @project.any?
      @final_parameters << {"$project" => @project}
    end

    @unwind.each do |e|
      @final_parameters << e
    end

    if @match.any?
      @final_parameters << {"$match" => @match}
    end

    reset_hashes
  end

  def reset_hashes
    @project = Hash.new
    @unwind = []
    @match = Hash.new
  end

end
