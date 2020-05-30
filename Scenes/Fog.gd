extends Sprite

func _ready():
	scale.x = -1 if (randi()%2 == 0) else 1
	scale.y = -1 if (randi()%2 == 0) else 1
	rotation_degrees = -180 if (randi()%2 == 0) else 0
	$AnimationPlayer.play("New Anim", -1, rand_range(0.9,1.1), randi() % 2 == 0)
	$AnimationPlayer.advance(rand_range(0,10))
