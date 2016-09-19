class CV
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include OntoMap

  def name
    self.CURRICULO_VITAE["DADOS_GERAIS"]["NOME_COMPLETO"]
  end

  def email
    self.CURRICULO_VITAE["DADOS_GERAIS"]["NOME_COMPLETO"]
  end

  #TODO mudar para uma classe de configuracao, estilo FactoryGirl.
  # acho que fica melhor e mais claro
  # pois uma mesma model/doc do mongo pode ter várias classes relacionadas na ontologia.
  def setup
    ontoclass 'foaf:Person'
    maps('foaf:name', :name)
    maps('foaf:mbox', :email)
    print

    cvs = query("teste")
    puts ">>>>>>>>>>>>>>>>>>>>> query('teste')"
    puts ''
    puts "query('teste')"
    p cvs
  end

end
