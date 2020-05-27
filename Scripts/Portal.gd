extends Node2D

signal portal_changed

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

onready var trail : CPUParticles2D = $Trail

const TWEEN_TIME = 0.5

var radius : float = 25 setget set_radius

const COLLISION_RADIUS_BIAS = 5

func transition_radius(value : float):
	if $Tween.is_active: return
	$Tween.interpolate_property(self, "radius", radius, value, TWEEN_TIME, Tween.TRANS_EXPO)
	$Tween.start()

func set_radius(value : float):
	radius = value
	scale = Vector2(radius/25, radius/25)
	emit_signal("portal_changed")

var portal_position : Vector2 setget set_position

func _ready():
	dimension_resources.portal = self

func _enter_tree():
	print('lelele')
	
func _exit_tree():
	dimension_resources.portal = null

func set_position(new_pos : Vector2):
	emit_signal("portal_changed")
	portal_position = new_pos
	global_position = portal_position
	trail.scale_amount = radius/25
	trail.one_shot = true
	trail.emitting = true
