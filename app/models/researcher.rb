# coding: utf-8
class Researcher
  include Mongoid::Document
  include OntoMap

  embeds_many :publications

  field :name, type: String
  field :name_in_citations, type: String
  field :country, type: String
  field :resume, type: String
  field :identification_number, type: String

  #validates :name, :uniqueness => true
  #validates :name_in_citations, :uniqueness => true
  #index({ 'name' => 1, 'name_in_citations' => 1}, { unique: true, drop_dups: true })

  #validates :identification_number, :uniqueness => true
  #index({ 'identification_number' => 1}, { unique: true, sparse:true })

  #ontoclass 'foaf:Person'
  #maps from: 'foaf:name', to: :name
  #maps from: ':name', to: :name
  #maps from: ':pais', to: :country
  #maps from: ':citationName', to: :name_in_citations
  #maps from: ':published', to: :publications

  def test_example
    sparql = %(
       PREFIX foaf:   <http://xmlns.com/foaf/0.1/>
       SELECT ?name
       WHERE
         { ?x foaf:name 'Eliana da Silva Pereira' }
     )
     puts Researcher.query(sparql).to_a
  end

  # exemplo extraido do paper
  # rodando a query abaixo, o resultado é obtido
  # agora, precisamos transformar o sparql em uma query equivalente.
  def test_paper
    sparql = %(
      SELECT
        ?researcherName ?publicationTitle1 ?publicationTitle2 ?year
      WHERE
      {
        ?scientist :name ?researcherName .
        ?scientist :published ?publication1 .
        ?scientist :published ?publication2 .
        ?publication1 :year ?year .
        ?publication2 :year ?year .
        ?publication1 :title ?publicationTitle1 .
        ?publication2 :title ?publicationTitle2 .
        FILTER
          (?publication1 != ?publication2) }
    )

    # esse sparql tem que virar a query abaixo

    Researcher.collection.aggregate([{
      "$project": {
        "name": true,
        "publication1": "$publications",
        "publication2": "$publications"
      }
    }, {
      "$unwind": "$publication1"
    }, {
      "$unwind": "$publication2"
    }, {
      "$project": {
        "name": true,
        "publication1": true,
        "publication2": true,
        "twoInOneYear": {
          "$and": [{
            "$eq": ["$publication1.year", "$publication2.year"]
          }, {
            "$ne": ["$publication1.title", "$publication2.title"]
          }]
        }
      }
    }, {
      "$match": {
        "twoInOneYear": true
      }
    }, {
      "$project": {
        "researcherName": "$name",
        "publicationTitle1": "$publication1.title",
        "publicationTitle2": "$publication2.title",
        "year": "$publication1.year"
      }
    }])

    # que retorna:

    [{"_id"=>BSON::ObjectId('5804eced2f3ece00495e0a0e'),
      "researcherName"=>"Kristen Nygaard",
      "publicationTitle1"=>"Turing Award Paper Test",
      "publicationTitle2"=>"IEEE John von Neumann Medal Paper Test",
      "year"=>2001
    },
    {"_id"=>BSON::ObjectId('5804eced2f3ece00495e0a0e'),
      "researcherName"=>"Kristen Nygaard",
      "publicationTitle1"=>"IEEE John von Neumann Medal Paper Test",
      "publicationTitle2"=>"Turing Award Paper Test",
      "year"=>2001}]

  end

  def self.from_hash(hash)
    model = Researcher.new
    model.identification_number = hash["CURRICULO_VITAE"]["NUMERO_IDENTIFICADOR"]
    model.name                  = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["NOME_COMPLETO"]
    model.name_in_citations     = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["NOME_EM_CITACOES_BIBLIOGRAFICAS"]
    model.country               = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["PAIS_DE_NASCIMENTO"]
    if hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["RESUMO_CV"].present?
      model.resume            = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["RESUMO_CV"]["TEXTO_RESUMO_CV_RH"]
    end

    model
  end

  def self.publications_by_year
    aggr = Researcher.pluck('publications.year').
                      compact.
                      flatten.
                      map{|i| {year: i["year"].to_i } }.
                      sort_by{|i| i[:year] }.
                      group_by{|i| i[:year]}.
                      map{|year, v| [year.to_s, v.size] }
    aggr
  end
end
