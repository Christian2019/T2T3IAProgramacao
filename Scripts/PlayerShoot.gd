extends KinematicBody2D

export (PackedScene) var bullet
var bullet_speed_player = 500
var bullet_type = 1
var facing_right = true
var is_jumping = false
var is_shooting = false

var bullet_direction : Vector2 = Vector2.ZERO
var can_shoot = true

var bullet_adjacent_1 : Vector2 = Vector2.ZERO
var bullet_adjacent_2 : Vector2 = Vector2.ZERO
var bullet_adjacent_3 : Vector2 = Vector2.ZERO
var bullet_adjacent_4 : Vector2 = Vector2.ZERO

var animated_sprite_node
var bullet_position_node
var cool_down_timer_node

var sin_cos5 = [0.0872, 0.9962]
var sin_cos10 = [0.1736, 0.9848]
var sin_cos35 = [0.5736, 0.8192]
var sin_cos40 = [0.6428, 0.7660]
var sin_cos45 = 0.7071

func _ready():
	animated_sprite_node = $AnimatedSprite
	bullet_position_node = $BulletPosition
	cool_down_timer_node = $CoolDownTimer

func _process(delta):
	jump()
	move()
	shoot()

func move():
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		if facing_right:
			flip_player()
		shooting_directions("up_left")
		if not is_jumping:
			animated_sprite_node.play("run_shoot_up")
		
	elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
		if not facing_right:
			flip_player()
		shooting_directions("up_right")
		if not is_jumping:
			animated_sprite_node.play("run_shoot_up")
		
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
		if facing_right:
			flip_player()
		shooting_directions("down_left")
		if not is_jumping:
			animated_sprite_node.play("run_shoot_down")
		
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
		if not facing_right:
			flip_player()
		shooting_directions("down_right")
		if not is_jumping:
			animated_sprite_node.play("run_shoot_down")
		
	elif Input.is_action_pressed("ui_up"):
		shooting_directions("up")
		if not is_jumping:
			animated_sprite_node.play("idle_look_up")
		
	elif Input.is_action_pressed("ui_down"):
		if is_jumping:
			shooting_directions("down")
		else:
			if facing_right:
				shooting_directions("lowered_right")
			else:
				shooting_directions("lowered_left")
			animated_sprite_node.play("idle_lowered")
		
	elif Input.is_action_pressed("ui_left"):
		if facing_right:
			flip_player()
		shooting_directions("left")
		if not is_jumping:
			if is_shooting:
				animated_sprite_node.play("run_shoot")
			else:
				animated_sprite_node.play("run")
		
	elif Input.is_action_pressed("ui_right"):
		if not facing_right:
			flip_player()
		shooting_directions("right")
		if not is_jumping:
			if is_shooting:
				animated_sprite_node.play("run_shoot")
			else:
				animated_sprite_node.play("run")
		
	else:
		if facing_right:
			shooting_directions("right")
		else:
			shooting_directions("left")
		if not is_jumping:
			animated_sprite_node.play("idle")

func jump():
	if Input.is_action_just_pressed("jump"):
		is_jumping = !is_jumping
	if is_jumping:
		animated_sprite_node.play("jump")

func shoot():
	if Input.is_action_pressed("shoot"):
		is_shooting = true
		if can_shoot:
			bullet_shoot(bullet_direction)
			
			if bullet_type == 1:
				spread_bullet()
			
			can_shoot = false
			cool_down_timer_node.start()
	else:
		is_shooting = false

func bullet_shoot(dir):
	var bullet_instance = bullet.instance()
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = bullet_position_node.global_position
	bullet_instance.set_scale(Vector2(3,3))
	bullet_instance.set_bullet(bullet_speed_player, bullet_type, dir, false)

func shooting_directions(direction):
	match direction:
		"up":
			bullet_position_node.position = Vector2(0, -20)
			bullet_direction = Vector2(0, -1)
			bullet_adjacent_1 = Vector2(-sin_cos10[0], -sin_cos10[1])
			bullet_adjacent_2 = Vector2(-sin_cos5[0], -sin_cos5[1])
			bullet_adjacent_3 = Vector2(sin_cos5[0], -sin_cos5[1])
			bullet_adjacent_4 = Vector2(sin_cos10[0], -sin_cos10[1])
		"up_left":
			bullet_position_node.position = Vector2(-8, -14)
			bullet_direction = Vector2(-sin_cos45, -sin_cos45)
			bullet_adjacent_1 = Vector2(-sin_cos35[1], -sin_cos35[0])
			bullet_adjacent_2 = Vector2(-sin_cos40[1], -sin_cos40[0])
			bullet_adjacent_3 = Vector2(-sin_cos40[0], -sin_cos40[1])
			bullet_adjacent_4 = Vector2(-sin_cos35[0], -sin_cos35[1])
		"up_right":
			bullet_position_node.position = Vector2(8, -14)
			bullet_direction = Vector2(sin_cos45, -sin_cos45)
			bullet_adjacent_1 = Vector2(sin_cos35[1], -sin_cos35[0])
			bullet_adjacent_2 = Vector2(sin_cos40[1], -sin_cos40[0])
			bullet_adjacent_3 = Vector2(sin_cos40[0], -sin_cos40[1])
			bullet_adjacent_4 = Vector2(sin_cos35[0], -sin_cos35[1])
		"left":
			bullet_position_node.position = Vector2(-12, -1)
			bullet_direction = Vector2(-1, 0)
			bullet_adjacent_1 = Vector2(-sin_cos10[1], -sin_cos10[0])
			bullet_adjacent_2 = Vector2(-sin_cos5[1], -sin_cos5[0])
			bullet_adjacent_3 = Vector2(-sin_cos5[1], sin_cos5[0])
			bullet_adjacent_4 = Vector2(-sin_cos10[1], sin_cos10[0])
		"right":
			bullet_position_node.position = Vector2(12, -1)
			bullet_direction = Vector2(1, 0)
			bullet_adjacent_1 = Vector2(sin_cos10[1], -sin_cos10[0])
			bullet_adjacent_2 = Vector2(sin_cos5[1], -sin_cos5[0])
			bullet_adjacent_3 = Vector2(sin_cos5[1], sin_cos5[0])
			bullet_adjacent_4 = Vector2(sin_cos10[1], sin_cos10[0])
		"down":
			bullet_position_node.position = Vector2(0, 20)
			bullet_direction = Vector2(0, 1)
			bullet_adjacent_1 = Vector2(-sin_cos10[0], sin_cos10[1])
			bullet_adjacent_2 = Vector2(-sin_cos5[0], sin_cos5[1])
			bullet_adjacent_3 = Vector2(sin_cos5[0], sin_cos5[1])
			bullet_adjacent_4 = Vector2(sin_cos10[0], sin_cos10[1])
		"down_left":
			bullet_position_node.position = Vector2(-10, 7)
			bullet_direction = Vector2(-sin_cos45, sin_cos45)
			bullet_adjacent_1 = Vector2(-sin_cos35[1], sin_cos35[0])
			bullet_adjacent_2 = Vector2(-sin_cos40[1], sin_cos40[0])
			bullet_adjacent_3 = Vector2(-sin_cos40[0], sin_cos40[1])
			bullet_adjacent_4 = Vector2(-sin_cos35[0], sin_cos35[1])
		"down_right":
			bullet_position_node.position = Vector2(10, 7)
			bullet_direction = Vector2(sin_cos45, sin_cos45)
			bullet_adjacent_1 = Vector2(sin_cos35[1], sin_cos35[0])
			bullet_adjacent_2 = Vector2(sin_cos40[1], sin_cos40[0])
			bullet_adjacent_3 = Vector2(sin_cos40[0], sin_cos40[1])
			bullet_adjacent_4 = Vector2(sin_cos35[0], sin_cos35[1])
		"lowered_left":
			bullet_position_node.position = Vector2(-17, 13)
			bullet_direction = Vector2(-1, 0)
			bullet_adjacent_1 = Vector2(-sin_cos10[1], -sin_cos10[0])
			bullet_adjacent_2 = Vector2(-sin_cos5[1], -sin_cos5[0])
			bullet_adjacent_3 = Vector2(-sin_cos5[1], sin_cos5[0])
			bullet_adjacent_4 = Vector2(-sin_cos10[1], sin_cos10[0])
		"lowered_right":
			bullet_position_node.position = Vector2(17, 13)
			bullet_direction = Vector2(1, 0)
			bullet_adjacent_1 = Vector2(sin_cos10[1], -sin_cos10[0])
			bullet_adjacent_2 = Vector2(sin_cos5[1], -sin_cos5[0])
			bullet_adjacent_3 = Vector2(sin_cos5[1], sin_cos5[0])
			bullet_adjacent_4 = Vector2(sin_cos10[1], sin_cos10[0])
	

func spread_bullet():
	bullet_shoot(bullet_adjacent_1)
	bullet_shoot(bullet_adjacent_2)
	bullet_shoot(bullet_adjacent_3)
	bullet_shoot(bullet_adjacent_4)

func flip_player():
	if(facing_right):
		facing_right = false
		animated_sprite_node.flip_h = true
	else:
		facing_right = true
		animated_sprite_node.flip_h = false

func _on_CoolDownTimer_timeout():
	can_shoot = true
