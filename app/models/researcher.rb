class Researcher
  include Mongoid::Document
  include OntoMap

  has_many :publications

  field :name, type: String
  field :name_in_citations, type: String
  field :country, type: String
  field :resume, type: String

  ontoclass 'foaf:Person'
  maps from: 'foaf:name', to: :name
  maps from: 'pais', to: :country
  maps from: 'citationName', to: :name_in_citations

  def test_example
    sparql = %(
       PREFIX foaf:   <http://xmlns.com/foaf/0.1/>
       SELECT ?name
       WHERE
         { ?x foaf:name 'Eliana da Silva Pereira' }
     )
     puts Researcher.query(sparql).to_a
  end

  def test_paper
    sparql = %(
      SELECT
        ?firstName ?lastName ?awardName1 ?awardName2 ?year
      WHERE
      {
        ?scientist :firstName ?firstName .
        ?scientist :lastName ?lastName .
        ?scientist :gotAward ?aw1 .
        ?scientist :gotAward ?aw2 .
        ?aw1 :awardedInYear ?year .
        ?aw2 :awardedInYear ?year .
        ?aw1 :awardName ?awardName1 .
        ?aw2 :awardName ?awardName2 .
        FILTER
          (?aw1 != ?aw2) }
    )


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
