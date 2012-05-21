require 'rubygems'
require 'neography'

def create_person(name)
  Neography::Node.create("name" => name)
end

johnathan = create_person('Johnathan')
mark      = create_person('Mark')
phil      = create_person('Phil')
mary      = create_person('Mary')
luke      = create_person('Luke')

johnathan.both(:friends) << mark
mark.both(:friends) << mary
mark.both(:friends) << phil
phil.both(:friends) << mary
phil.both(:friends) << luke

def suggestions_for(node)
  node.incoming(:friends).
       order("breadth first").
       uniqueness("node global").
       filter("position.length() == 2;").
       depth(2).
       map{|n| n.name }.join(', ')
end
puts "Johnathan should become friends with #{suggestions_for(johnathan)}"

# RESULT
# Johnathan should become friends with Mary, Phil