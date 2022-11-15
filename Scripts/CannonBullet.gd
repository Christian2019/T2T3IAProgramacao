extends Area2D

var horizontal_speed
var vertical_force = -2
export var gravityForce=5
var camera 
var stop = false
var start

func _ready():
	start=true
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	horizontal_speed = rng.randi_range(40,80)

func _process(delta):
	if (start):
		start=false
		camera =  Global.MainScene.get_node("Camera2D")
	outOfScreen()
	if stop:
		return
	
	gravity()
	horizontal_velocity()
	
	if position.y > get_parent().get_parent().get_node("Position2D").position.y:
		explode()

func gravity():
	position.y += vertical_force
	vertical_force += gravityForce * Global.Inverse_MAX_FPS

func horizontal_velocity():
	position.x -= horizontal_speed * Global.Inverse_MAX_FPS

func explode():
	stop = true
	$Sprite.visible = false
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("explosion")
	#queue_free()

func _on_AnimatedSprite_animation_finished():
	queue_free()

func _on_CannonBullet_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Player")):
		var player = area.get_parent()
		if (player.contactCollision==area.get_children()[0]):
			stop = true
			player.dead=true
			explode()

func outOfScreen():
	var ext=600
	if (camera.global_position.x-ext>global_position.x or camera.global_position.x+ext<global_position.x
	or camera.global_position.y-ext>global_position.y or camera.global_position.y+ext<global_position.y):
		queue_free()

