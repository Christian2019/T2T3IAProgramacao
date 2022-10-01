extends KinematicBody2D

export (PackedScene) var bullet

var bullet_position
var bullet_velocity : Vector2 = Vector2.ZERO
var can_shoot = true

func _process(delta):
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right") :
		$AnimatedSprite.play("run_shoot_up")
		$BulletPosition.position = Vector2(8, -14)
		#bullet_position = 1
		bullet_velocity.x = 1
		bullet_velocity.y = -1
	elif Input.is_action_pressed("ui_up"):
		$AnimatedSprite.play("idle_look_up")
		$BulletPosition.position = Vector2(0, -20)
		#bullet_position = 2
		bullet_velocity.x = 0
		bullet_velocity.y = -1
	else:
		$AnimatedSprite.play("idle");
		$BulletPosition.position = Vector2(12, -1)
		#bullet_position = 0
		bullet_velocity.x = 1
		bullet_velocity.y = 0
	
	if Input.is_action_pressed("ui_accept"):
		if can_shoot:
			var bullet_instance = bullet.instance()
			get_parent().add_child(bullet_instance)
			bullet_instance.global_position = $BulletPosition.global_position
			bullet_instance.direction(bullet_velocity)
			can_shoot = false
			$CoolDownTimer.start()
		
	

func _on_CoolDownTimer_timeout():
	can_shoot = true
