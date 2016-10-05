class Publication
  include Mongoid::Document
  
  field :nature, type: String
  field :title, type: String
  field :year, type: Integer
  field :country, type: String
  field :language, type: String
  field :medium, type: String
  field :doi, type: String
  field :title_en, type: String
end
