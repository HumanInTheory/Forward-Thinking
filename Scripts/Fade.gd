extends Control

signal finished;

func fade():
	$AnimationPlayer.play("Fade")

func unfade():
	$AnimationPlayer.play("Unfade")


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("finished")
