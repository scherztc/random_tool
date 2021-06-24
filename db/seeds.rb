# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

File.open('public/bookmark_url.lst', 'r') do |file|  
  contentsArray = [] 
  while line = file.gets
     Resource.create(title: '', description: '', url: line)
#     contentsArray.push line     
  end  
end

#contentsArray.each do |url|
#  Resource.create(title: '', description: '', url: url)
#end


#Resource.create(title: 'Home', description: 'This is my home.', url: 'www.uc.edu')
