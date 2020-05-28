extends Area2D

func _on_InWallDetector_body_entered(body):
	if body.name != "Player":
		print("in wall!")
