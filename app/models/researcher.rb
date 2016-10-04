class Researcher
  include Mongoid::Document

  field :name, type: String
  field :name_in_citations, type: String
  field :country, type: String
  field :resume, type: String
end
