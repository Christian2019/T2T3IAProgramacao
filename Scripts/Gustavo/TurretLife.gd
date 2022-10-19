extends KinematicBody2D


var life = 4

func loose_life():
	life -= 1
	print("Perdeu vida: ", life)
	if life <= 0:
		queue_free()
