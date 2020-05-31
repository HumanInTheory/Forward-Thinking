extends Resource

var overworld_tree : Node2D
var subworld_tree : Node2D
var object_tree : Node2D

var collision_map : TileMap
var overworld_map : TileMap
var subworld_map : TileMap

var barrel_path : String

var portal : Node2D
var player : Node2D
var portal_tree : Node2D

var fragment_counter : Label

func set_barrel(value : Node2D):
	barrel_path = value.get_path()
	print("Barrel get! %s" % barrel_path)

func get_barrel() -> String:
	return barrel_path
	
func reset_barrel():
	barrel_path = ""
