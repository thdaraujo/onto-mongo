# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


files = Dir.glob('cvs/amostra/*.xml')
hashes = files.map{|file|
                    xml = File.read(file)
                    Hash.from_xml(xml)
                  }

# save files adding dynamic fields
hashes.each do |hash|
  cv = CV.new(hash)
  cv.save!
end

puts "#{CV.all.size} files added to mongo!"
