# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


files = Dir.glob('cvs/amostra/*.xml')
hashes = files.map{|file|
                    xml = File.read(file).encode('utf-8')
                    Hash.from_xml(xml)
                  }

# save files adding dynamic fields
puts '------------------------------------------'
puts 'XMLS'

hashes.each do |hash|
  cv = CV.new(hash)
  cv.save!
  puts cv.CURRICULO_VITAE["DADOS_GERAIS"]["NOME_COMPLETO"]
end

puts '------------------------------------------'
puts "#{CV.all.size} files added to mongo!"

# save researchers (semi-structured)
puts '------------------------------------------'
puts 'RESEARCHERS'

hashes.each do |hash|
  model = Researcher.new
  model.name              = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["NOME_COMPLETO"]
  model.name_in_citations = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["NOME_EM_CITACOES_BIBLIOGRAFICAS"]
  model.country           = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["PAIS_DE_NASCIMENTO"]
  model.resume            = hash["CURRICULO_VITAE"]["DADOS_GERAIS"]["RESUMO_CV"]["TEXTO_RESUMO_CV_RH"]

  model.save!

end

puts '------------------------------------------'
puts "#{Researcher.all.size} researchers added to mongo!"
