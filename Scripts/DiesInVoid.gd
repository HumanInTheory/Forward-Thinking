extends Node2D

var DEATH_TIME = 5

func death_area_entered(_area):
	var timer = get_tree().create_timer(DEATH_TIME, false)
	yield(timer, "timeout")
	queue_free()
