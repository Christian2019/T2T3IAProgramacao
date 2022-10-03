extends KinematicBody2D

export (PackedScene) var bullet

var facing_right = true
var is_shooting = false

var bullet_position
var bullet_direction : Vector2 = Vector2.ZERO
var can_shoot = true

func _process(delta):
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		if facing_right:
			flip_player()
		shooting_directions("up_left")
		$AnimatedSprite.play("run_shoot_up")
		
	elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
		if not facing_right:
			flip_player()
		shooting_directions("up_right")
		$AnimatedSprite.play("run_shoot_up")
		
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
		if facing_right:
			flip_player()
		shooting_directions("down_left")
		$AnimatedSprite.play("run_shoot_down")
		
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
		if not facing_right:
			flip_player()
		shooting_directions("down_right")
		$AnimatedSprite.play("run_shoot_down")
		
	elif Input.is_action_pressed("ui_up"):
		shooting_directions("up")
		$AnimatedSprite.play("idle_look_up")
		
	elif Input.is_action_pressed("ui_down"):
		if facing_right:
			shooting_directions("lowered_right")
		else:
			shooting_directions("lowered_left")
		$AnimatedSprite.play("idle_lowered")
		
	elif Input.is_action_pressed("ui_left"):
		if facing_right:
			flip_player()
		shooting_directions("left")
		if is_shooting:
			$AnimatedSprite.play("run_shoot")
		else:
			$AnimatedSprite.play("run")
		
	elif Input.is_action_pressed("ui_right"):
		if not facing_right:
			flip_player()
		shooting_directions("right")
		if is_shooting:
			$AnimatedSprite.play("run_shoot")
		else:
			$AnimatedSprite.play("run")
		
	else:
		if facing_right:
			shooting_directions("right")
		else:
			shooting_directions("left")
		$AnimatedSprite.play("idle")
	
	if Input.is_action_pressed("ui_accept"):
		is_shooting = true
		if can_shoot:
			var bullet_instance = bullet.instance()
			get_parent().add_child(bullet_instance)
			bullet_instance.global_position = $BulletPosition.global_position
			bullet_instance.set_direction(bullet_direction)
			can_shoot = false
			$CoolDownTimer.start()
	else:
		is_shooting = false

func shooting_directions(direction):
	match direction:
		"up":
			$BulletPosition.position = Vector2(0, -20)
			bullet_direction.x = 0
			bullet_direction.y = -1
		"up_left":
			$BulletPosition.position = Vector2(-8, -14)
			bullet_direction.x = -1
			bullet_direction.y = -1
		"up_right":
			$BulletPosition.position = Vector2(8, -14)
			bullet_direction.x = 1
			bullet_direction.y = -1
		"left":
			$BulletPosition.position = Vector2(-12, -1)
			bullet_direction.x = -1
			bullet_direction.y = 0
		"right":
			$BulletPosition.position = Vector2(12, -1)
			bullet_direction.x = 1
			bullet_direction.y = 0
		"down_left":
			$BulletPosition.position = Vector2(-10, 7)
			bullet_direction.x = -1
			bullet_direction.y = 1
		"down_right":
			$BulletPosition.position = Vector2(10, 7)
			bullet_direction.x = 1
			bullet_direction.y = 1
		"lowered_left":
			$BulletPosition.position = Vector2(-17, 13)
			bullet_direction.x = -1
			bullet_direction.y = 0
		"lowered_right":
			$BulletPosition.position = Vector2(17, 13)
			bullet_direction.x = 1
			bullet_direction.y = 0
	

func flip_player():
	if(facing_right):
		facing_right = false
		$AnimatedSprite.flip_h = true
	else:
		facing_right = true
		$AnimatedSprite.flip_h = false

func _on_CoolDownTimer_timeout():
	can_shoot = true
