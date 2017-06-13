def create_researcher hash
  model = Researcher.from_hash(hash)
  begin
    _exists = false
    if model.identification_number.present?
      _exists = Researcher.where(identification_number: model.identification_number).exists?
    end
    if _exists
      puts "#{_researcher.name_in_citations} #{_researcher._id} already present."
      model._id = Researcher.find_by(identification_number: model.identification_number).id
    end
    model.save
    # TODO duplicates?
    publications = Publication.from_hash(hash)
    publications.each do |pub|
      model.publications.push(pub)
    end
    model.save

    model
  rescue => ex
    puts "error on: #{model.name_in_citations}"
    puts ex.message
    #byebug
    nil
  end
end

def create_coauthors researcher
  researcher.publications.compact.
    map(&:coauthors).flatten.compact.
    uniq{|coauthor| coauthor[:name] }.
    each do |coauthor|
      begin
        _exists = false
        if coauthor[:identification_number].present?
          _exists = Researcher.where(identification_number: coauthor[:identification_number]).exists?
        end
        if _exists
          puts "skipping #{coauthor[:name_in_citations]} #{coauthor[:identification_number]} ."
        else
          puts "coauthor #{coauthor[:name_in_citations]} #{coauthor[:identification_number]} added."
          Researcher.create!(name: coauthor[:name], name_in_citations: coauthor[:name_in_citations], identification_number: coauthor[:identification_number])
        end
      rescue => ex
        puts ex.message
        #byebug
      end
    end
end


cvs_ids = CV.only(:id)

cvs_ids.each_with_index do |id, index|
  begin
    cv = CV.find(id)
    puts "#{index + 1} -> #{id}"

    hash = JSON.parse(cv.to_json)
    researcher = create_researcher(hash)
    if researcher.nil?

    else
      "#{researcher.name} added with #{researcher.publications.size} publications."
      create_coauthors(researcher)
    end
  rescue => ex
    puts ex.message
    puts "#{index + 1} -> #{id}"
  end
end

puts "#{Researcher.all.size} researchers added to mongo!"
