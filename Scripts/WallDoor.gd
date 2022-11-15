extends Area2D

var life = 40
var destroyed = false

func loose_life():
	life -= 1
	#print("Perdeu vida: ", life)
	if life <= 0:
		destroyed = true
		get_parent().get_parent().doorDestroyed()
		queue_free()
