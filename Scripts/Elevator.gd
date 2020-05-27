extends Node2D

export var speed : float = 1

var moving : bool = false

var progress : float = 0

onready var start_position = position;
onready var end_position = get_node("Endpoint").position + start_position

func _physics_process(delta):
	if moving:
		progress += speed * delta / (start_position-end_position).length()
	else:
		progress -= speed * delta / (start_position-end_position).length()
		
	progress = clamp(progress, 0, 1)
	
	position = lerp(start_position, end_position, progress)

func _on_DetectionArea_body_entered(body):
	if body.name == "Player":
		moving = true

func _on_DetectionArea_body_exited(body):
	if body.name == "Player":
		moving = false
