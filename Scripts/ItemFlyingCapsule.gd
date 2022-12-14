extends Node2D

export var falcon_index = 0

var falcon = preload("res://Scenes/ItemPickUp.tscn")

var angle = PI / 2
var max_speed = 350
var angular_speed = 1
var radius = 3
var distanceToActivate=330

var stop = true
var disable=true
var camera
var start=true

func _ready() -> void:
	$AnimatedSprite.visible=false
	$Area2D/CollisionShape2D.disabled=true

func _process(delta):
	
	if(start):
		start=false
		camera =  Global.MainScene.get_node("Camera2D")
	if (disable):
		activation()
	else:
		outOfScreen()
	move()
	

func activation():
	if (Global.MainScene.get_node("Camera2D").global_position.x>global_position.x+distanceToActivate):
		disable=false
		stop=false
		$Area2D/CollisionShape2D.disabled=false
		$AnimatedSprite.visible=true

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
	createItem()

func createItem():
	var falcon_instance = falcon.instance()
	falcon_instance.falcon_index = falcon_index
	falcon_instance.global_position = global_position
	falcon_instance.set_scale(Vector2(3,3))
	get_parent().call_deferred("add_child", falcon_instance)
	queue_free()

func outOfScreen():
	var ext=600
	if (camera.global_position.x-ext>global_position.x or camera.global_position.x+ext<global_position.x
	or camera.global_position.y-ext>global_position.y or camera.global_position.y+ext<global_position.y):
		queue_free()
