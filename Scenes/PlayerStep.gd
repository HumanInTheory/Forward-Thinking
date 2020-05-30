extends AudioStreamPlayer

func step():
	pitch_scale = rand_range(0.9,1.1)
	volume_db = rand_range(-3,0)
	play()
