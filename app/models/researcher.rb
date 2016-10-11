class Researcher
  include Mongoid::Document

  has_and_belongs_to_many :publications

  field :name, type: String
  field :name_in_citations, type: String
  field :country, type: String
  field :resume, type: String

  def self.from_hash(hash)
    model = Researcher.new
    model.name              = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["NOME_COMPLETO"]
    model.name_in_citations = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["NOME_EM_CITACOES_BIBLIOGRAFICAS"]
    model.country           = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["PAIS_DE_NASCIMENTO"]
    model.resume            = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["RESUMO_CV"]["TEXTO_RESUMO_CV_RH"]

    model
  end
end
