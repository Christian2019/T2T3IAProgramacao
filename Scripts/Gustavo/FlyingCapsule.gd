extends KinematicBody2D

export (PackedScene) var falcon
export var falcon_index = 0

var angle = PI / 2
var max_speed = 100
var angular_speed = 0.7
var radius = 5

var stop = false

func _process(delta):
	if stop:
		return
	
	move()

func move():
	var horizontal_speed = max_speed * Fps.MAX_FPS
	position.x += horizontal_speed
	
	angle += PI * angular_speed * Fps.MAX_FPS
	var dy = cos(angle) * radius
	position.y += dy

func explode():
	$AnimatedSprite.play("explosion")
	$CollisionShape2D.queue_free()
	falcon()
	print("certo mizeravi")

func falcon():
	var falcon_instance = falcon.instance()
	falcon_instance.falcon_index = falcon_index
	print(falcon_instance.falcon_index, falcon_index)
	falcon_instance.global_position = global_position
	falcon_instance.set_scale(Vector2(3,3))
	get_parent().add_child(falcon_instance)
	

func _on_AnimatedSprite_animation_finished():
	queue_free()
