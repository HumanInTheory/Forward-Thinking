extends Control

signal finished;

func fade(time = 0.5):
	$AnimationPlayer.play("Fade", -1, 1/time)

func unfade(time = 0.5):
	$AnimationPlayer.play("Unfade", -1, 1/time)


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("finished")
