extends Node2D

export (PackedScene) var falcon
export var falcon_index = 0

var angle = PI / 2
var max_speed = 100
var angular_speed = 0.7
var radius = 3

var stop = false

func _process(delta):
	move()

func move():
	if stop:
		return

	var horizontal_speed = max_speed * Global.Inverse_MAX_FPS
	position.x += horizontal_speed
	
	angle += PI * angular_speed * Global.Inverse_MAX_FPS
	var dy = cos(angle) * radius
	position.y += dy

func explode():
	if (stop):
		return
	stop = true
	$AnimatedSprite.play("explosion")
	$Area2D.queue_free()
	falcon()

func falcon():
	var falcon_instance = falcon.instance()
	falcon_instance.falcon_index = falcon_index
	print(falcon_instance.falcon_index, falcon_index)
	falcon_instance.global_position = global_position
	falcon_instance.set_scale(Vector2(3,3))
	get_parent().add_child(falcon_instance)
	

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "explosion":
		queue_free()
