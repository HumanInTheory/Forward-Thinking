extends Node2D

const SPEED = 15

export var height : float = 0;

onready var start_position = position;

var moving : bool = false

func _physics_process(delta):
	if moving:
		if position.y > start_position.y - height:
			position = position + Vector2.UP * SPEED * delta
	else:
		if position.y < start_position.y:
			position = position + Vector2.DOWN * SPEED * delta

func _on_DetectionArea_body_entered(body):
	if body.name == "Player":
		moving = true

func _on_DetectionArea_body_exited(body):
	if body.name == "Player":
		moving = false
