extends Node2D

const MIN_SIZE = 0.25
const MAX_SIZE = 0.3

func _on_Fragment_tree_exiting():
	queue_free()

func _process(delta):
	pass
