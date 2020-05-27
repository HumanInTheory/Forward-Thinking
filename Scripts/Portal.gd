extends Node2D

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

onready var trail : CPUParticles2D = $Trail

const TWEEN_TIME = 0.5

var radius : float = 25 setget set_radius

const COLLISION_RADIUS_BIAS = 5

func transition_radius(value : float):
	print("Transitioning to radius %f" % value)
	$Tween.interpolate_method(self, "set_radius", radius, value, TWEEN_TIME, Tween.TRANS_EXPO)
	$Tween.start()

func set_radius(value : float):
	radius = value
	scale = Vector2(radius/25, radius/25)

var portal_position : Vector2 setget set_position

func _ready():
	dimension_resources.portal = self

func _exit_tree():
	dimension_resources.portal = null

func set_position(new_pos : Vector2):
	portal_position = new_pos
	scale = Vector2(radius/25, radius/25)
	global_position = portal_position
	trail.one_shot = true
	trail.emitting = true
