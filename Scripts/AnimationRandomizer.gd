extends Sprite

export var random_flip_x : bool = false
export var random_flip_y : bool = false
export var random_rotate : bool = false
export var anim : String

func _ready():
	if random_flip_x:
		scale.x = -1 if (randi()%2 == 0) else 1
	if random_flip_y:
		scale.y = -1 if (randi()%2 == 0) else 1
	if random_rotate:
		rotation_degrees = -180 if (randi()%2 == 0) else 0
	$AnimationPlayer.play("New Anim", -1, rand_range(0.9,1.1), randi() % 2 == 0)
	$AnimationPlayer.advance(rand_range(0,10))
