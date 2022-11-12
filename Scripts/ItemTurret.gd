extends Area2D


export var item_index = 0
var item_pick_up = preload("res://Scenes/ItemPickUp.tscn")

var is_close = true
var is_transitioning = false

var animated_sprite

func _ready() -> void:
	animated_sprite = $AnimatedSprite
	$CollisionShape2D.disabled = true
	$Timer.start()

func loose_life():
	call_deferred("disableCollision")
	animated_sprite.play("explosion")
	call_item()

func disableCollision():
	$CollisionShape2D.disabled = true
	
func call_item():
	var item_instance = item_pick_up.instance()
	item_instance.falcon_index = item_index
	item_instance.global_position = global_position
	item_instance.set_scale(Vector2(3,3))
	get_parent().call_deferred("add_child", item_instance)

func _on_Timer_timeout():
	animated_sprite.animation = "transition"
	$CollisionShape2D.disabled = true
	is_transitioning = true

func _on_AnimatedSprite_animation_finished():
	if is_transitioning:
		if is_close:
			animated_sprite.play("open")
			$CollisionShape2D.disabled = false
			is_close = false
		else:
			animated_sprite.play("closed")
			is_close = true
		is_transitioning = false
	if animated_sprite.animation == "explosion":
		queue_free()
