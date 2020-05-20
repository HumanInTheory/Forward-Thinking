extends Resource

var portal : Node2D setget set_portal
var overworld_tree : Node2D setget set_overworld_tree
var subworld_tree : Node2D setget set_subworld_tree
var object_tree : Node2D setget set_object_tree

#set automatically when trees are inserted
var collision_map : TileMap
var overworld_map : TileMap
var subworld_map : TileMap

func set_portal(new_portal : Node2D):
	portal = new_portal

func set_overworld_tree(tree : Node2D):
	overworld_tree = tree
	overworld_map = find_tile_map(tree)
	
func set_subworld_tree(tree : Node2D):
	subworld_tree = tree
	subworld_map = find_tile_map(tree)
	
func set_object_tree(tree : Node2D):
	object_tree = tree
	collision_map = find_tile_map(tree)

func find_tile_map(tree : Node) -> TileMap:
	for i in tree.get_child_count():
		var node = tree.get_child(i)
		if node is TileMap:
			return node
	return null
