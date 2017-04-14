class Generator
  def self.execute(node)
    data_to_insert = ""
    # implementado para uma classe somente
    model = OntoMap.model_for(node.ontoclass)
    wheres = Hash.new
    puts "O model -> #{model.to_s}"

    project = Hash.new
    match = Hash.new
    final_parameters = []

    if node.data_properties.any?
      puts "has data_properties"
      temp_project = Hash.new
      node.data_properties.each do |dp|
        temp_project[OntoMap.attributes_for(node.ontoclass)[dp.name]] = true
      end
      project["$project"] = temp_project
      final_parameters << project

      puts "Project: #{project}"
      puts "final parameters: #{final_parameters}"
    end

    #{$match: {"name.first": {$eq: "Kristen"}} },
    if node.filters.any?
      temp_match = Hash.new
      node.filters.each do |f|
        key = OntoMap.attributes_for(node.ontoclass)[f[:filter_name].name]
        value = f[:value].object.object
        temp_match[key] = value
      end
      match["$match"] = temp_match
      final_parameters << match
    end

    puts "Match: #{match}"
    puts "final parameters: #{final_parameters}"

    result = model.collection.aggregate(final_parameters)

#//////////////////////////////////////

    # node.filters.each do |f|
    #   #x = Mapping.get_mapping(model, f[:filter_name].name)
    #   #OntoMap.attributes_for("Pessoa")[":nature"]
    #   x = Mapping.get_mapping(model, f[:filter_name].name)
    #   puts "XXXXXXX -> #{x}"
    #   y = f[:value].var_name
    #   wheres = {x => y}
    # end
    #
    # if wheres.empty?
    #   result = model.all
    # else
    #   result = model.where(wheres)
    # end
    #
    # m_count = result.count
    # att_count = node.data_properties.size
    # puts m_count

    #attributes
    result.each_with_index do |r, result_index|
      r.each_key do |key|
        if !key.to_s.eql?("_id")

          sparql = "SELECT ?nome WHERE { ?researcher <http://onto-mongo/basic-lattes#nome> ?nome ." \
                                     " }"

          data_to_insert = data_to_insert + "<http://onto-mongo/basic-lattes/#{r["_id"]}>" \
                                            "<http://onto-mongo/basic-lattes##{OntoMap.inverted_attributes_for(node.ontoclass)[key.to_sym]}>"\
                                            " \"#{r[key]}\" "
          if result_index == result.count - 1
            data_to_insert.concat(" \n")
          else
            data_to_insert.concat("\. \n")
          end
        end
      end
    end

    return data_to_insert
  end
end
