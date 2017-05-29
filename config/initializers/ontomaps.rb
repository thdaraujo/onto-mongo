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
  maps relation: 'publicou', to: :publications
end

OntoMap.mapping 'Artigo' do
  model Publication
  maps from: 'natureza', to: :nature
  maps from: 'titulo', to: :title
  maps from: 'titulo_em_ingles', to: :title_en
  maps from: 'ano', to: :year
  maps from: 'pais', to: :country
  maps from: 'idioma', to: :language
  maps from: 'veiculo', to: :medium
  maps from: 'doi', to: :doi
end
