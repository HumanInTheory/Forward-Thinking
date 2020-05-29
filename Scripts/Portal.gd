extends Node2D

signal portal_changed(previous_pos)

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

onready var trail : CPUParticles2D = $PortalGraphics/Trail

const TWEEN_TIME = 0.5

var radius : float = 25 setget set_radius

const COLLISION_RADIUS_BIAS = 5

func transition_radius(value : float):
	$Tween.interpolate_property(self, "radius", radius, value, TWEEN_TIME, Tween.TRANS_EXPO)
	$Tween.start()

func set_radius(value : float):
	radius = value
	$PortalGraphics.scale = Vector2(radius/25, radius/25)
	emit_signal("portal_changed", portal_position)

var portal_position : Vector2 setget set_position

func _ready():
	dimension_resources.portal = self
	
func _exit_tree():
	dimension_resources.portal = null

func set_position(new_pos : Vector2):
	var prev_pos = portal_position
	portal_position = new_pos
	global_position = portal_position
	$PortalGraphics/Trail.scale_amount = radius/25
	
	emit_signal("portal_changed", prev_pos)
	
	trail.one_shot = true
	trail.emitting = true
