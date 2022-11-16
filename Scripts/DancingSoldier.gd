extends AnimatedSprite

var final =500
var speed=1

func _process(delta):
	print(global_position)
	if( global_position.y >=final):
		global_position.y-=speed
