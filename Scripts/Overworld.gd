extends Node2D

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	dimension_resources.overworld_tree = self
	dimension_resources.overworld_map = $TileMap
	
func _exit_tree():
	dimension_resources.overworld_tree = null
	dimension_resources.overworld_map = null
