#TODO tratar subclass Quando mapeamento definido para Pesquisador é o mesmo para Pessoa
OntoMap.mapping 'Pessoa' do
  model Researcher
  maps from: 'nome', to: :name
  maps from: 'title', to:  :title
  maps from: 'title_en', to:  :title_en
  maps from: 'year', to:  :year
  maps from: 'country', to:  :country
  maps from: 'language', to:  :language
  maps from: 'medium', to:  :medium
  maps from: 'doi', to:  :doi
  maps relation: 'published', to: :publications
end
