require 'rubygems'
require 'neography'

def create_person(name)
  Neography::Node.create("name" => name)
end

johnathan = create_person('Johnathan')
mark      = create_person('Mark')
phil      = create_person('Phil')
mary      = create_person('Mary')

johnathan.both(:friends) << mark
mark.both(:friends) << phil
phil.both(:friends) << mary
mark.both(:friends) << mary

johnathan.shortest_path_to(mary).incoming(:friends).depth(4).nodes.each do |path|
  puts "#{(path.size - 1 )} degrees: " + path.map{|n| n.name }.join(' => friends => ')
end
# RESULT
# 2 degrees: Johnathan => friends => Mark => friends => Mary