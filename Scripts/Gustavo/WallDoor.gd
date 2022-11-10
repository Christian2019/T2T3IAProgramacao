extends Area2D

var life = 10
var destroyed = false

func loose_life():
	life -= 1
	#print("Perdeu vida: ", life)
	if life <= 0:
		destroyed = true
		queue_free()
