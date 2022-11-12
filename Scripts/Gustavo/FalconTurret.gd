extends Area2D

export (PackedScene) var falcon
export var falcon_index = 0

var DetectionDistance = 400
var is_close = true
var is_transitioning = false
var life = 1

var animated_sprite

func _ready() -> void:
	animated_sprite = $AnimatedSprite
	$CollisionShape2D.disabled = true
	$Timer.start()

func _process(delta):
	pass
	#animations()

func closed():
	animated_sprite.play("closed")

func transition():
	animated_sprite.play("transition")

func open():
	animated_sprite.play("open")

func loose_life():
	life -= 1
	if life <= 0:
		destroy_falcon_turret()

func destroy_falcon_turret():
	$CollisionShape2D.queue_free()
	animated_sprite.play("explosion")
	call_falcon()

func call_falcon():
	var falcon_instance = falcon.instance()
	falcon_instance.falcon_index = falcon_index
	falcon_instance.global_position = global_position
	falcon_instance.set_scale(Vector2(3,3))
	get_parent().add_child(falcon_instance)


func _on_Timer_timeout():
	print("timeout")
	animated_sprite.animation = "transition"
	$CollisionShape2D.disabled = true
	is_transitioning = true


func _on_AnimatedSprite_animation_finished():
	#print("entro")
	if is_transitioning:
		print("change animation")
		if is_close:
			print("abriu")
			animated_sprite.play("open")
			$CollisionShape2D.disabled = false
			is_close = false
		else:
			animated_sprite.play("closed")
			print("fecho")
			#$CollisionShape2D.disabled = true
			is_close = true
		is_transitioning = false
