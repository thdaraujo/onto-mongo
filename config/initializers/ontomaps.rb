OntoMap.mapping 'Pesquisador' do
  model Researcher
  maps from: 'nome', to: :name
  maps from: 'pais', to: :country
  maps from: 'citationName', to: :name_in_citations
  maps relation: ':published', to: :publications
end
