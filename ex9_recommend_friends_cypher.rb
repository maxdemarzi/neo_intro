require 'rubygems'
require 'neography'

@neo = Neography::Rest.new

def create_person(name)
  @neo.create_node("name" => name)
end

def make_mutual_friends(node1, node2)
  @neo.create_relationship("friends", node1, node2)
  @neo.create_relationship("friends", node2, node1)
end

def suggestions_for(node)
  node_id = node["self"].split('/').last.to_i
  @neo.execute_query("START me = node({node_id})
                      MATCH (me)-[:friends]->(friend)-[:friends]->(foaf)
                      RETURN foaf.name", {:node_id => node_id})["data"]
end

johnathan = create_person('Johnathan')
mark      = create_person('Mark')
phil      = create_person('Phil')
mary      = create_person('Mary')
luke      = create_person('Luke')

make_mutual_friends(johnathan, mark)
make_mutual_friends(mark, mary)
make_mutual_friends(mark, phil)
make_mutual_friends(phil, mary)
make_mutual_friends(phil, luke)

puts "Johnathan should become friends with #{suggestions_for(johnathan).join(', ')}"

# RESULT
# Johnathan should become friends with Mary, Phil