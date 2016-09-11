class CV
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include OntoMap

  def name
    self.CURRICULO_VITAE["DADOS_GERAIS"]["NOME_COMPLETO"]
  end

  #TODO mudar para uma classe de configuracao, estilo FactoryGirl.
  # acho que fica melhor e mais claro
  # pois uma mesma model/doc do mongo pode ter várias classes relacionadas na ontologia.
  def setup
    ontoclass 'foaf:Person'
    maps :name, to: 'foaf:name'
    print
  end

end
