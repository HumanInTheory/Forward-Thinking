extends Sprite

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

func _enter_tree():
	dimension_resources.fragment_counter = $Label

func _exit_tree():
	if dimension_resources.fragment_counter == $Label:
		dimension_resources.fragment_counter = null
