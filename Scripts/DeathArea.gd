extends Area2D

func _on_DeathArea_body_entered(body : Object):
	if body.has_method("death_area_entered"):
		body.death_area_entered(self)
