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

def degrees_of_separation(start_node, destination_node)
  start_node_id = start_node["self"].split('/').last.to_i
  destination_node_id = destination_node["self"].split('/').last.to_i
  @neo.execute_query("START me=node({start_node_id}), 
                            them=node({destination_node_id}) 
                      MATCH path = allShortestPaths( me-[?*]->them ) 
                      RETURN length(path), extract(person in nodes(path) : person.name)",
                      {:start_node_id => start_node_id,
                       :destination_node_id => destination_node_id })["data"]
end
   
johnathan = create_person('Johnathan')
mark      = create_person('Mark')
phil      = create_person('Phil')
mary      = create_person('Mary')

make_mutual_friends(johnathan, mark)
make_mutual_friends(mark, phil)
make_mutual_friends(phil, mary)
make_mutual_friends(mark, mary)

degrees_of_separation(johnathan, mary).each do |path|
  nodes = path.last
  puts "#{path.first} degrees: " + nodes.join(' => friends => ') 
end

# RESULT
# 3 degrees: Johnathan => friends => Mark => friends => Phil => friends => Mary
# 2 degrees: Johnathan => friends => Mark => friends => Mary