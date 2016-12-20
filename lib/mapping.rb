RESEARCHER_MAPPING = { 'nome' => 'name'}

class Mapping
  def self.get_mapping(model, attribute)
    case model
    when Researcher
      RESEARCHER_MAPPING[attribute]
    else
      puts "Not Found."
    end
  end
end
