extends Node2D

var dimension_resources = preload("res://Resource/Dimension Resources.tres")

func _ready():
	dimension_resources.portal_tree = self

func _exit_tree():
	dimension_resources.portal_tree = null
