extends KinematicBody2D

onready var bullet = preload("res://Scenes/Bullet.tscn")

var bullet_position
var bullet_speed = 100

func _process(delta):
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right") :
		$AnimatedSprite.play("run_shoot_up")
		$BulletPosition.position = Vector2(8, -14)
		bullet_position = 1
	elif Input.is_action_pressed("ui_up"):
		$AnimatedSprite.play("idle_look_up")
		$BulletPosition.position = Vector2(0, -20)
		bullet_position = 2
	else:
		$AnimatedSprite.play("idle");
		$BulletPosition.position = Vector2(12, -1)
		bullet_position = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		var bullet_instance = bullet.instance()
		get_parent().add_child(bullet_instance)
		bullet_instance.global_position = $BulletPosition.global_position
		
		
