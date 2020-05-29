extends CPUParticles2D

var follow_node : WeakRef = null
var follow_position : Vector2

func _ready():
	emitting = true

func _process(_delta):
	if not emitting:
		queue_free()
		return
	
	if follow_node != null:
		var node = follow_node.get_ref()
		if node != null:
			global_position = node.global_position
		else:
			pass #leave it be
	else:
		global_position = follow_position
