extends Node2D

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

onready var trail : CPUParticles2D = $Trail

const RADIUS = 25
const COLLISION_RADIUS_BIAS = 5

const COLLISION_RADIUS = RADIUS + COLLISION_RADIUS_BIAS

var portal_position : Vector2 setget set_position

func _ready():
	dimension_resources.portal = self

func _exit_tree():
	dimension_resources.portal = null

func set_position(new_pos : Vector2):
	portal_position = new_pos
	position = portal_position
	trail.one_shot = true
	trail.emitting = true
