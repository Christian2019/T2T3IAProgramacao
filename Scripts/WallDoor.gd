extends Area2D

var life = 40
var destroyed = false

func loose_life():
	life -= 1
	#print("Perdeu vida: ", life)
	if life <= 0 and !destroyed:
		destroyed = true
		get_parent().get_parent().doorDestroyed()
		
