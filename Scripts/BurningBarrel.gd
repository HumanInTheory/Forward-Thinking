extends "res://Scripts/DiesInVoid.gd"

export var current_barrel : bool = false

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

func _ready():
	if current_barrel and dimension_resources.get_barrel().empty():
		dimension_resources.set_barrel(self)

func _on_Barrel_body_entered(body):
	if body.name == "Player":
		dimension_resources.set_barrel(self)

func _process(_delta):
	if dimension_resources.get_barrel() == get_path():
		$CPUParticles2D.emitting = true
	else:
		$CPUParticles2D.emitting = false

func get_spawn_position() -> Vector2:
	return $SpawnPosition.global_position
