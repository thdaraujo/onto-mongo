class Researcher
  include Mongoid::Document
  include OntoMap

  has_and_belongs_to_many :publications

  field :name, type: String
  field :name_in_citations, type: String
  field :country, type: String
  field :resume, type: String

  def setup
    ontoclass 'foaf:Person'
    maps from: 'foaf:name', to: :name
    maps from: 'pais', to: :country

    sparql = %(
      PREFIX foaf:   <http://xmlns.com/foaf/0.1/>
      SELECT ?name
      WHERE
        { ?x foaf:name ?name }
    )

    query(sparql)
  end

  def self.from_hash(hash)
    model = Researcher.new
    model.name              = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["NOME_COMPLETO"]
    model.name_in_citations = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["NOME_EM_CITACOES_BIBLIOGRAFICAS"]
    model.country           = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["PAIS_DE_NASCIMENTO"]
    model.resume            = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["RESUMO_CV"]["TEXTO_RESUMO_CV_RH"]

    model
  end
end
