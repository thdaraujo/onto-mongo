class Publication
  include Mongoid::Document
  include OntoMap

  belongs_to :researchers

  field :nature, type: String
  field :title, type: String
  field :title_en, type: String
  field :year, type: Integer
  field :country, type: String
  field :language, type: String
  field :medium, type: String
  field :doi, type: String

  def self.from_hash(hash)
    #neat little trick: Maybe monad.
    # or reduce by keys..
    # http://stackoverflow.com/questions/10130726/ruby-access-multidimensional-hash-and-avoid-access-nil-object
    article = ["CURRICULO_VITAE", "PRODUCAO_BIBLIOGRAFICA", "ARTIGOS_PUBLICADOS", "ARTIGO_PUBLICADO"].reduce(hash) {|m,k| m && m[k] }

    # TODO multiple articles...
    if article.present?
      model = Publication.new
      model.nature           = article["DADOS_BASICOS_DO_ARTIGO"]["NATUREZA"]
      model.title            = article["DADOS_BASICOS_DO_ARTIGO"]["TITULO_DO_ARTIGO"]
      model.title_en         = article["DADOS_BASICOS_DO_ARTIGO"]["TITULO_DO_ARTIGO_INGLES"]
      model.year             = article["DADOS_BASICOS_DO_ARTIGO"]["ANO_DO_ARTIGO"].to_i
      model.country          = article["DADOS_BASICOS_DO_ARTIGO"]["PAIS_DE_PUBLICACAO"]
      model.language         = article["DADOS_BASICOS_DO_ARTIGO"]["IDIOMA"]
      model.medium           = article["DADOS_BASICOS_DO_ARTIGO"]["MEIO_DE_DIVULGACAO"]
      model.doi              = article["DADOS_BASICOS_DO_ARTIGO"]["DOI"]

      # TODO get other authors...
      # <AUTORES NOME-COMPLETO-DO-AUTOR="Patrick B. Luc as da Silva" NOME-PARA-CITACAO="SILVA, P. B. L. A."
      # TODO get other types of publications...
      # like workshops etc.

      model
    else
      nil
    end
  end

end
