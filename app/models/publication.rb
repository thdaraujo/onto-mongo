class Publication
  include Mongoid::Document
  include OntoMap

  embedded_in :researchers

  field :nature, type: String
  field :title, type: String
  field :title_en, type: String
  field :year, type: Integer
  field :country, type: String
  field :language, type: String
  field :medium, type: String
  field :doi, type: String
  field :coauthors, type: Array

  #ontoclass 'foaf:Publication'
  #maps from: ':nature', to:  :nature
  #maps from: ':title', to:  :title
  #maps from: ':title_en', to:  :title_en
  #maps from: ':year', to:  :year
  #maps from: ':country', to:  :country
  #maps from: ':language', to:  :language
  #maps from: ':medium', to:  :medium
  #maps from: ':doi', to:  :doi

  def self.from_hash(hash)
    publications = []

    #neat little trick: Maybe monad.
    # or reduce by keys..
    # http://stackoverflow.com/questions/10130726/ruby-access-multidimensional-hash-and-avoid-access-nil-object
    article = ["CURRICULO_VITAE", "PRODUCAO_BIBLIOGRAFICA", "ARTIGOS_PUBLICADOS", "ARTIGO_PUBLICADO"].reduce(hash) {|m, k| m && m[k] }

    #TODO e se vierem vários????
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

      # TODO index em researchers
      # Se já existir, dar update apenas.
      if article["AUTORES"].present?
        model.coauthors = article["AUTORES"].select{|author| author.is_a? Hash }.map{|author|
          {
            name: author["NOME_COMPLETO_DO_AUTOR"],
            name_in_citations: author["NOME_PARA_CITACAO"]
          }
        }
      end
      publications << model
    end

    # other types of publications...
    # like workshops etc.
    works = ["CURRICULO_VITAE", "PRODUCAO_BIBLIOGRAFICA", "TRABALHOS_EM_EVENTOS", "TRABALHO_EM_EVENTOS"].reduce(hash) {|m,k| m && m[k] }

    if works.present?
      publications << works.map{ |work|
        model = Publication.new
        if work.is_a? Hash
          model.nature           = work["DADOS_BASICOS_DO_TRABALHO"]["NATUREZA"]
          model.title            = work["DADOS_BASICOS_DO_TRABALHO"]["TITULO_DO_TRABALHO"]
          model.title_en         = work["DADOS_BASICOS_DO_TRABALHO"]["TITULO_DO_TRABALHO_INGLES"]
          model.year             = work["DADOS_BASICOS_DO_TRABALHO"]["ANO_DO_TRABALHO"].to_i
          model.country          = work["DADOS_BASICOS_DO_TRABALHO"]["PAIS_DO_EVENTO"]
          model.language         = work["DADOS_BASICOS_DO_TRABALHO"]["IDIOMA"]
          model.medium           = work["DADOS_BASICOS_DO_TRABALHO"]["MEIO_DE_DIVULGACAO"]
          model.doi              = work["DADOS_BASICOS_DO_TRABALHO"]["DOI"]

          # TODO index em researchers
          # Se já existir, dar update apenas.
          model.coauthors = work["AUTORES"].map{|author|
            {
              name: author["NOME_COMPLETO_DO_AUTOR"],
              name_in_citations: author["NOME_PARA_CITACAO"]
            }
          }
          model
        end
      }.select{|publication| publication.present?}
    end
    publications
  end

end
