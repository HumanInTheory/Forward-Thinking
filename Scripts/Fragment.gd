extends Area2D

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

signal collected(fragment)

func _enter_tree():
	call_deferred("prepare")

func prepare():
	var visibleNode = $Visible
	self.remove_child(visibleNode)
	
	var portal_tree = dimension_resources.portal_tree
	if portal_tree != null:
		portal_tree.add_child(visibleNode)
		visibleNode.global_position = global_position
	else:
		print("no portal tree!")
	
	
func _on_Fragment_body_entered(body):
	if body.name == "Player":
		emit_signal("collected", self)
		queue_free()
