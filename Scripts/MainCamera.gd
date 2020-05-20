extends Camera2D


signal moved(new_pos)

func _ready():
	pass # Replace with function body.

func get_camera_pos() -> Vector2:
	return self.global_position

func set_camera_pos(new_pos : Vector2):
	for camera in get_tree().get_nodes_in_group("linked_cameras"):
		camera.global_position = new_pos
	emit_signal("moved", new_pos)

func relative_move_camera(delta : Vector2):
	set_camera_pos(get_camera_pos() + delta)

func body_is_player(body : Node2D) -> bool:
	return body.name == "Player"

func _on_MoveMinusX_body_entered(body):
	if body_is_player(body):
		relative_move_camera(Vector2(-192, 0))


func _on_MovePlusX_body_entered(body):
	if body_is_player(body):
		relative_move_camera(Vector2(192, 0))


func _on_MoveMinusY_body_entered(body):
	if body_is_player(body):
		relative_move_camera(Vector2(0, -108))


func _on_MovePlusY_body_entered(body):
	if body_is_player(body):
		relative_move_camera(Vector2(0, 108))
