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
puts '------------------------------------------'

hashes.each do |hash|
  cv = CV.new(hash)
  cv.save!
end

puts '------------------------------------------'
puts "#{CV.all.size} files added to mongo!"
puts '------------------------------------------'

# save researchers (semi-structured)
puts '------------------------------------------'
puts 'RESEARCHERS AND PUBLICATIONS'
puts '------------------------------------------'

hashes.each_with_index do |hash, index|
  model = Researcher.from_hash(hash)
  model.save!
  # TODO multiple publications...
  publications = Publication.from_hash(hash)
  model.publications.push(publications.first)
  model.save!
end

# create researchers for coauthors
#TODO refactor
#TODO remove duplicates researchers from database
Researcher.all.map(&:publications).flatten.compact.
               map(&:coauthors).flatten.compact.
               map{|coauthor|
                Researcher.create(name: coauthor[:name], name_in_citations: coauthor[:name_in_citations])
              }


puts '------------------------------------------'
puts "#{Researcher.all.size} researchers added to mongo!"
puts "#{Researcher.all.map{|r| r.publications.size }.sum} publications added to mongo!"
puts '------------------------------------------'

# save test researchers example from paper
puts '------------------------------------------'
puts 'ADD TEST RESEARCHER Kristen Nygaard WITH TWO PUBLICATIONS IN THE SAME YEAR'
puts '------------------------------------------'

model = Researcher.create(name: "Kristen Nygaard",
                       name_in_citations: "Nygaard, K.",
                       country: "Noruega",
                       resume: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
model.publications.create([
  { nature: "COMPLETO", title: "Rosing Prize Paper Test", year: 1999, country: "Noruega", language: "Inglês", medium: "IMPRESSO"},
  { nature: "COMPLETO", title: "Turing Award Paper Test", year: 2001, country: "Noruega", language: "Inglês", medium: "IMPRESSO"},
  { nature: "COMPLETO", title: "IEEE John von Neumann Medal Paper Test", year: 2001, country: "Noruega", language: "Inglês", medium: "IMPRESSO"}
])

model.save!

puts '------------------------------------------'
puts "#{Researcher.all.size} researchers added to mongo!"
puts "#{Researcher.all.map{|r| r.publications.size }.sum} publications added to mongo!"
puts '------------------------------------------'
